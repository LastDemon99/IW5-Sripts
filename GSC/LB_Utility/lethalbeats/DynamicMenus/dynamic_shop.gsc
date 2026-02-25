#define TABLE "mp/dynamic_shop.csv"

#define OPTION_BUY -5
#define OPTION_DISABLE -4
#define OPTION_OWNED -3
#define OPTION_UPGRADE -2
#define OPTION_SCRIPTRESPONSE -1
// OPTION >= 0 -> item_price

init()
{
	precachemenu("ui_shop_display");
	precachemenu("dynamic_shop");
	
    level endon("game_ended");
	
	for (;;)
	{
		level waittill("connected", player);
		if(player isTestClient()) continue;
		
        player.menuPages = [];
        player.isMenuBusy = false;        
		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	level endon("game_ended");
    self endon("disconnect");

    for (;;)
    {
        self waittill("menuresponse",  menu, response);

        if (isDefined(self.isMenuBusy) && self.isMenuBusy) continue;
        self.isMenuBusy = true;

		if (menu == "class" && response == "back")
		{
			self closepopupMenu();
			self closeInGameMenu();
            self.isMenuBusy = false;
			continue;
		}
		
		if (menu != "dynamic_shop")
        {
            self.isMenuBusy = false;
            continue;
        }

		if (response == "close_self")
		{
			self closeShop();
			continue;
		}
		
        if (response == "prev_menu")
        {
            if (isDefined(self.menuPages) && self.menuPages.size > 1)
            {
                self.menuPages[self.menuPages.size - 1] = undefined; 
                self openShop(self getPage(), true);
            }
            else self closeShop();
            continue;
        }

		page = self getPage();

        if (!isDefined(page) || page == "")
        {
            self closeShop();
            continue;
        }
        
		index = getIndex(page, response);
        if (!isDefined(index) || index < 0)
        {
            self closeShop();
            continue;
        }

		option_type = getOptionType(page, response, index);
        self [[level.onSelectOption]](page, response, getPrice(response), option_type, index);

        if (isDefined(self.isMenuBusy) && self.isMenuBusy) self.isMenuBusy = false;
	}
}

openShop(page, is_back)
{
	self endon("close_shop");

    if (!isDefined(page) || page == "")
    {
        self closeShop();
        return;
    }

	if (!isDefined(is_back)) is_back = false;
	isMainPage = tablelookup(TABLE, 1, page, 6) == "close_self";	
	if (isMainPage && !is_back) self.menuPages = [];	
	if (!is_back) self.menuPages[self.menuPages.size] = page;
	
    self [[level.onOpenPage]](page);
	wait(0.07);
    
	self updateLabels(page);
    if (isMainPage)
    {
        self openpopupmenu("dynamic_shop");
        self playLocalSound("nav_hover");
    }

    self.isMenuBusy = false;
}

closeShop()
{
	self notify("close_shop");
	self.shop = undefined;
    self.menuPages = [];
	self closeMenu("dynamic_shop");
    if(isDefined(self)) self.isMenuBusy = false;
}

getOptionType(page, item, index)
{
	// get item price or set a value for price_label
	// .menu to get a var requires the name as plain text: "price_iw5_usp45", does not support concatenation: "price_" + {item}
	if (self [[level.isOwnedOption]](page, item, index)) return OPTION_OWNED; // price_label: "Owned", forecolor (1, 0.5, 0)
	if (self [[level.isDisabledOption]](page, item, index)) return OPTION_DISABLE; // price_label: "", disabled option, forecolor (0, 0, 0)
	if (self [[level.isUpgradeOption]](page, item, index)) return OPTION_UPGRADE; // price_label: "Upgrade", forecolor (1, 0.5, 0)
	if (getDvar("price_" + item) == "") return OPTION_SCRIPTRESPONSE; // price_label: "", forecolor (1, 1, 1)
	return OPTION_BUY; // price_label: {price}, {current_price} >= {price} forecolor (1, 1, 1), {current_price} < {price} forecolor (1, 0, 0)
}

updateLabels(page)
{
	if (!isDefined(page)) page = self getPage();
	start_index = int(tablelookup(TABLE, 1, page, 0)) + 1;
	for(i = 0; i < 11; i++)
	{
		row = i + start_index;
		option_label = tableLookupByRow(TABLE, row, 2);
		if (option_label == "") break;
		item = tableLookupByRow(TABLE, row, 6);
		price_label = getOptionType(page, item, i);
		
		if (isDefined(level.onUpdateOption)) [[level.onUpdateOption]](i, item, option_label, price_label);
		else updateOption(i, item, option_label, price_label);
	}
	self setClientDvar("ui_shop_display", page);
    self openMenu("ui_shop_display");
}

updateOption(index, item, option_label, price_label)
{
    if (price_label == OPTION_BUY) price_label = getPrice(item);    
    self setOption(index, option_label);
    self setPrice(index, price_label);
}

setPrice(index, price)
{
	self setClientDvar("armory_price_" + index, price);
}

setOption(index, label)
{
	self setClientDvar("armory_option_" + index, label);
}

getPage(index)
{
	if (!isDefined(index)) index = 1;
	if (index < 0) index = index * -1;
    
    if (!isDefined(self.menuPages) || self.menuPages.size == 0) return undefined;

    real_index = self.menuPages.size - index;

    if (real_index < 0 || real_index >= self.menuPages.size) return undefined;

	page = self.menuPages[real_index];
	return page;
}

getPrice(item)
{
	return getDvarFloat("price_" + item);
}

getIndex(page, item)
{
    if (!isDefined(page) || page == "" || !isDefined(item) || item == "") return -1;

	start_index_str = tablelookup(TABLE, 1, page, 0);
    item_index_str = tablelookup(TABLE, 6, item, 0);

    if (start_index_str == "" || item_index_str == "") return -1;

	start_index = int(start_index_str);
	item_index = int(item_index_str);

	return item_index - (start_index + 1);
}

buyItem(price)
{
	if (isDefined(level.setMoney)) [[level.setMoney]](self.score - int(price));
    self playLocalSound("arcademode_checkpoint");
    self updateLabels();
}

shopInit(menu)
{
    self.shop = spawnstruct();
    self.shop.menu = menu;
    self.shop.page = -1;
    self.shop.owner = self;
}

isShopOpen()
{
	return isDefined(self.shop);
}

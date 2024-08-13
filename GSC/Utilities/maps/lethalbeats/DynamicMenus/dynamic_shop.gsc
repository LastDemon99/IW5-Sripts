#define TABLE "mp/dynamic_shop.csv"

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
		if (menu != "dynamic_shop") continue;
		
        if (response == "prev_menu")
        {
			newMenuPages = [];
			for (i = 0; i < self.menuPages.size - 1; i++)
				newMenuPages[i] = self.menuPages[i];	
			self.menuPages = newMenuPages;
            self openShop(self getPage(), true);
            continue;
        }

		page = self getPage();
		option_value = getOptionValue(page, response);
		self.selectedItems[page] = response;
		
		if (option_value == -3)
		{
			self openShop(self [[level.getUpgradeMenu]](page, response));
			continue;
		}

        if (option_value == -4)
        {
            if (tablelookup(TABLE, 1, response, 0) == "")
                self openpopupmenu(response);
            else
                self openShop(response);
            continue;
        }

        if (isDefined(level.onBuy))
		{
			self [[level.onBuy]](page, response, option_value); // page, item, price
			self updatePrices(page);
		}
	}
}

openShop(page, is_back)
{
	if (!isDefined(is_back)) is_back = false;
	isMainPage = tablelookup(TABLE, 1, page, 6) == "close_self";
	
	if (isMainPage && !is_back)
	{
		self.menuPages = [];
		self.selectedItems = [];
	}
	
	if (!is_back) self.menuPages[self.menuPages.size] = page;
	self [[level.onOpenPage]](page);
	wait(0.07);

    self updatePrices(page);
	self setClientDvar("ui_shop_display", page);
    self openMenu("ui_shop_display");

    if (isMainPage)
    {
        self openpopupmenu("dynamic_shop");
        self playLocalSound("nav_hover");
    }
}

getOptionValue(page, item)
{
	// get item price or set a value for price_label
	// .menu to get a var requires the name as plain text: "price_iw5_usp45", does not support concatenation: "price_" + {item}	
	if (self [[level.isOwnedItem]](page, item)) return -2; // -2 -> owned item, price_label: "Owned", forecolor (1, 0.5, 0)
	if (self [[level.isDisabledItem]](page, item)) return -1;// -1 -> disabled option, forecolor (0, 0, 0), no handler is defined because the menu disables click option
	if (self [[level.isUpgradeAvailable]](page, item)) return -3; // -3 -> open new menu, price_label: "Upgrade", forecolor (1, 0.5, 0)
	if (getDvar("price_" + item) == "") return -4; // -4 -> open new menu, price_label: "", forecolor (1, 1, 1)
	return getDvarInt("price_" + item); // >= 0 -> price_label: {price}
}

updatePrices(page)
{
	self.hasStock = self [[level.getShopStock]](page);
    start_index = int(tablelookup(TABLE, 1, page, 0)) + 1;		
	for(i = 0; i < 10; i++)
	{
		row = i + start_index;        
		if (tableLookupByRow(TABLE, row, 2) == "") break;
		self setClientDvar("ui_price_" + i, getOptionValue(page, tableLookupByRow(TABLE, row, 6)));
	}
}

getPage(index)
{
	if (!isDefined(index)) index = 1;
	if (index < 0) index = index * -1;
	return self.menuPages[self.menuPages.size - index];
}

getItem(page)
{
	return self.selectedItems[page];
}

disableItem(item)
{
	start_index = int(tablelookup(TABLE, 1, self getPage(), 0)) + 1;
	for(i = 0; i < 10; i++)
		if (tableLookupByRow(TABLE, i + start_index, 6) == "item")
		{
			self setClientDvar("ui_price_" + i, -1);
			break;
		}
}

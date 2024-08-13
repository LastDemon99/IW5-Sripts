#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\lethalbeats\utility;

init()
{
	level.customWeapons = [];
	add_custom_weapon("iw5_cheytac", "Interveon", "weapon_sniper", ["acog", "silencer03", "thermal", "xmags", "heartbeat", "vzscope"], 2);
	add_custom_weapon("iw5_ak74u", "AK74-u", "weapon_smg", ["reflex", "silencer", "rof", "acog", "eotech", "xmags", "thermal"]);
}

refillAmmo()
{
    level endon("game_ended");
    self endon("disconnect");

    for (;;)
    {
        self waittill("reload");
		
		if(player_is_infect(self)) break;
		
		currWep = self getCurrentWeapon();
		
		if(currWep == "riotshield_mp" || !isDefined(currWep)) continue;		
		self giveMaxAmmo(currWep);
    }
}

refillSingleCountAmmo()
{
    level endon("game_ended");
    self endon("disconnect");

    for (;;)
    {
		wait 0.3;
		if(player_is_infect(self)) break;
		
		currWep = self getCurrentWeapon();
		if(currWep == "riotshield_mp" || !isDefined(currWep)) continue;		
        if (isAlive(self) && self getammocount(currWep) == 0) self notify("reload");
	}
}

refillNades()
{
	self endon("disconnect");
	level endon( "game_ended" );
	
	for (;;)
    {
		self waittill("grenade_fire", grenade, weaponName);
		
		if(player_is_infect(self)) break;
		
		if(array_contains(weaponName, level.weapons["lethal"]))
		{
			if(weaponName != "c4_mp") wait(1);
			else wait(3);
		}
		else if(array_contains(weaponName, level.weapons["tactical"])) wait(4);
		
		if(weaponName == "scrambler_mp") self thread maps\mp\gametypes\_scrambler::setScrambler();
		else if (weaponName == "portable_radar_mp") self thread maps\mp\gametypes\_portable_radar::setPortableRadar();
		else if (weaponName == "flare_mp") self maps\mp\perks\_perkfunctions::setTacticalInsertion();
		else self giveStartAmmo(weaponName);
		
		self playLocalSound("scavenger_pack_pickup");
	}
}

stingerFire()
{
	self endon("disconnect");
	self notifyOnPlayerCommand("attack", "+attack");
	
	for(;;)
	{
		self waittill("attack");
		
		if (self getCurrentWeapon() == "stinger_mp" && self playerAds() >= 1)
			if (self getWeaponAmmoClip(self getCurrentWeapon()) != 0)
			{
				vector = anglesToForward(self getPlayerAngles());
				dsa = (vector[0] * 1000000, vector[1] * 1000000, vector[2] * 1000000);
				magicBullet("stinger_mp", self getTagOrigin("tag_weapon_left"), dsa, self);
				self setWeaponAmmoClip("stinger_mp", 0);
			}	
		wait 0.3;
	}
}

give_spawn_weapon(weapon, switch_to_weapon)
{
	if (!isSubStr(weapon, "_mp_") && !string_end_with(weapon, "_mp"))
		weapon = weapon + "_mp";
	
	self takeAllWeapons();
	self _giveWeapon(weapon);
	self.primaryWeapon = weapon;
	self.pers["primaryWeapon"] = weapon;
	
	if (isDefined(switch_to_weapon) && switch_to_weapon)
		self switchToWeaponImmediate(weapon);
	else
		self setSpawnWeapon(weapon);
}

give_weapon(weapon)
{
	if (!isSubStr(weapon, "_mp_") && !string_end_with(weapon, "_mp"))
		weapon = weapon + "_mp";	
	self _giveWeapon(weapon);
}

give_nade(grenade, slot)
{
	if (!isDefined(slot)) slot = 0;	
	if (slot) self setOffhandSecondaryClass(get_equipment_class(grenade));
	else self setOffhandPrimaryClass(get_equipment_class(grenade));
	
	if(isSubStr(grenade, "sp"))
	{
		self givePerk(grenade, false);
		return;
	}
	
	self _giveWeapon(grenade);
	if (grenade != "emp_grenade_mp") self _setPerk(grenade, false);
}

add_custom_weapon(baseName, name, weapon_class, attachs, attach_combo_count)
{
	if (!isDefined(attach_combo_count)) attach_combo_count = 3;
	level.customWeapons[baseName] = [weapon_class, name, attachs, attach_combo_count];
}

get_equipment_class(grenade)
{
	if (grenade == "frag_grenade_mp") return "frag";
	if (grenade == "throwingknife_mp") return "throwingknife";
	if (grenade == "concussion_grenade_mp" || grenade == "smoke_grenade_mp") return "smoke";
	if (array_contains(["semtex_mp", "bouncingbetty_mp", "claymore_mp", "c4_mp"], grenade)) return "other";
	if (array_contains(["flash_grenade_mp", "specialty_scrambler", "emp_grenade_mp", "trophy_mp", "specialty_tacticalinsertion", "specialty_portable_radar"], grenade)) return "flash";
}

get_custom_weapons()
{
	return getArrayKeys(level.customWeapons);
}

get_weapon_class(baseName)
{
	weapon_class = getWeaponClass(baseName);
	return getSubStr(weapon_class, 7, weapon_class.size);
}

get_weapons(weapon_class)
{
	custom_weapons = array_filter(get_custom_weapons(), ::_custom_class_filter, "{i}", weapon_class);	
	weapon_class = getSubStr(weapon_class, 7, weapon_class.size);
	recipe_index = [2, 8, 18, 24, 28, 34, 39, 45, 53, 51, 52];
	index = array_index(["pistol", "assault", "smg", "machine_pistol", "shotgun", "lmg", "sniper", "projectile", "", "riot"], ::equal_filter, weapon_class);
	index_array = array_arange(recipe_index[index], recipe_index[index + 1]);
	if (weapon_class == "projectile") index_array = array_filter(index_array, ::_projectile_filter);	
	weapons = array_map(index_array, ::get_weapon_from_recipe);
	if (custom_weapons.size != 0) return array_combine(weapons, custom_weapons);
	return weapons;
}
_projectile_filter(i) { return i != 46 && i != 51; }
_custom_class_filter(i, class_name) { return level.customWeapons[i][0] == class_name; }

get_primaries()
{
	return arrays_combine(array_map(["weapon_assault", "weapon_smg", "weapon_shotgun", "weapon_lmg", "weapon_sniper", "weapon_riot"], ::get_weapons));
}

get_secondaries()
{
	return arrays_combine(array_map(["weapon_pistol", "weapon_machine_pistol", "weapon_projectile"], ::get_weapons));
}

get_camos()
{
	camos = [];
	for(i = 1; i < 14; i++)
		camos[camos.size] = i < 10 ? "camo0" + i : "camo" + i;
	return camos;
}

get_weapon_bareName(baseName)
{
	return isSubstr(baseName, "iw5_") ? getSubStr(baseName, 4, baseName.size) : baseName;
}

get_player_weapon(baseName)
{
	weapons = self getWeaponsListPrimaries();
    foreach(weapon in weapons)
        if (getBaseWeaponName(weapon) == baseName) return weapon;
    return undefined;
}

get_weapon_display(baseName)
{	
	if (is_custom_weapon(baseName)) return level.customWeapons[baseName][1];

	if (string_starts_with(baseName, "iw5"))
		baseName = getSubStr(baseName, 4, baseName.size);
	
	switch(baseName)
	{		
		case "1887": return &"WEAPON_MODEL1887";
		case "44magnum": return &"WEAPON_MAGNUM";
		case "barrett": return &"WEAPON_BARRETT";		
		case "cm901": return &"WEAPON_CM901";
		case "javelin": return &"WEAPON_JAVELIN";		
		case "ksg": return &"WEAPON_KSG";		
		case "l96a1": return &"WEAPON_L96A1";		
		case "type95": return &"WEAPON_TYPE95";
		case "xm25": return &"WEAPON_XM25";
	}
	
	start = baseName[0];
	
	if (start == "a")
	{
		switch(baseName)
		{
			case "aa12": return &"WEAPON_AA12";
			case "acr": return &"WEAPON_ACR";
			case "ak47": return &"WEAPON_AK47";
			case "as50": return &"WEAPON_AS50";
		}
	}
	
	if (start == "d")
		return baseName == "deserteagle" ? &"WEAPON_DESERTEAGLE" : &"WEAPON_DRAGUNOV";
	
	if (start == "f")
	{
		switch(baseName)
		{
			case "fad": return &"WEAPON_FAD";
			case "fmg9": return &"WEAPON_FMG9";
			case "fnfiveseven": return &"WEAPON_FNFIVESEVEN";
		}
	}
	
	if (start == "g")
	{
		switch(baseName)
		{
			case "g18": return &"WEAPON_GLOCK";
			case "g36c": return &"WEAPON_G36";
			case "gl": return &"WEAPON_GRENADE_LAUNCHER";
		}
	}
	
	if (start == "m")
	{
		switch(baseName)
		{
			case "m16": return &"WEAPON_M16";
			case "m320": return &"WEAPON_M320";
			case "m4": return &"WEAPON_M4";
			case "m60": return &"WEAPON_M60";
			case "m60jugg": return &"WEAPON_M60";
			case "m9": return &"WEAPON_UZI";
			case "mg36": return &"WEAPON_MG36";
			case "mk14": return &"WEAPON_MK14";
			case "mk46": return &"WEAPON_MK46";
			case "mp412": return &"WEAPON_MP412";
			case "mp412jugg": return &"WEAPON_MP412";
			case "mp5": return &"WEAPON_MP5K";
			case "mp7": return &"WEAPON_MP7";
			case "mp9": return &"WEAPON_MP9";
			case "msr": return &"WEAPON_MSR";
		}
	}
	
	if (start == "p")
	{
		switch(baseName)
		{
			case "p90": return &"WEAPON_P90";
			case "p99": return &"WEAPON_P99";
			case "pecheneg": return &"WEAPON_PECHENEG";
			case "pp90m1": return &"WEAPON_PP90M1";
		}
	}
	
	if (start == "r")
	{
		switch(baseName)
		{
			case "riotshield": return &"WEAPON_RIOTSHIELD";
			case "riotshield": return &"WEAPON_RIOTSHIELD";
			case "rpg": return &"WEAPON_RPG";
			case "rsass": return &"WEAPON_RSASS";
		}
	}
	
	if (start == "s")
	{
		switch(baseName)
		{
			case "sa80": return &"WEAPON_SA80";
			case "scar": return &"WEAPON_SCAR";
			case "skorpion": return &"WEAPON_SKORPION";
			case "smaw": return &"WEAPON_SMAW";
			case "spas12": return &"WEAPON_SPAS12";
			case "stinger": return &"WEAPON_STINGER";
			case "striker": return &"WEAPON_STRIKER";
		}
	}
	
	switch(baseName)
	{
		case "ump45": return &"WEAPON_UMP45";
		case "usas12": return &"WEAPON_USAS12";
		case "usp45": return &"WEAPON_USP";
		case "usp45jugg": return &"WEAPON_USP";
	}
}

get_weapon_from_recipe(column)
{
	return tableLookupByRow("mp/recipe.csv", 388, column);
}

get_current_attachs(weapon)
{
	tokens = strTok(weapon, "_");
	is_attach = false;
	attachs = [];

	foreach(token in tokens)
	{
		if (is_attach)
		{
			if(!string_starts_with(token, "vz") && isSubStr(token, "scope")) continue;
			attachs[attachs.size] = token;
		}
		if (token == "mp") is_attach = true;
	}
	return attachs;
}

get_weapon_attachs(baseName, rail_fix)
{
	if (is_custom_weapon(baseName)) return level.customWeapons[baseName][2];
	
	table = tableLookup("mp/challengetable.csv", 6, baseName, 4);
	
	attachs = [];	
	for (row = 2; tableLookupByRow(table, row, 2) != ""; row++)
		attachs[row - 2] = tableLookupByRow(table, row, 2);
	
	if (isDefined(rail_fix))
	{
		for(i = 0; i < attachs.size; i++)
			if (getAttachmentType(attachs[i]) == "rail")
				attachs[i] = fix_rail_attach(attachs[i], baseName);
	}
	
	return attachs;
}

get_attach_combos(attachs, attach)
{
	attachmentCombos = [];
	colIndex = tableLookupRowNum("mp/attachmentCombos.csv", 0, attach);	
	for (i = 0; i < attachs.size; i++)
	{
		if (tableLookup("mp/attachmentCombos.csv", 0, attachs[i], colIndex) == "no")
			continue;
		attachmentCombos[attachmentCombos.size] = attachs[i];
	}
	return attachmentCombos;
}

get_max_attachs_count(baseName)
{
	if (is_custom_weapon(baseName)) return level.customWeapons[baseName][3];
	attachs_size = get_weapon_attachs(baseName).size;
	return attachs_size < 3 ? attachs_size : 3;
}

get_random_attachs(baseName, attachs_count, rail_fix, include_none)
{
	if (!isDefined(attachs_count)) attachs_count = 2;
	if (!isDefined(rail_fix)) rail_fix = false;
	if (!isDefined(include_none)) include_none = false;		
	
	if (is_custom_weapon(baseName)) 
	{
		if(attachs_count > level.customWeapons[baseName][3])
			attachs_count = level.customWeapons[baseName][3];
	}
	
	allowed_attachs = get_weapon_attachs(baseName);
	
	if (allowed_attachs.size < attachs_count) attachs_count = allowed_attachs.size;
	attachs = [];
	
	while(attachs_count != 0)
	{
		if (include_none && cointoss() && cointoss())
		{
			attachs_count--;
			continue;
		}
		
		attach = random(allowed_attachs);
		attachs[attachs.size] = attach;
		allowed_attachs = get_attach_combos(allowed_attachs, attach);
		attachs_count--;
	}
	
	if (rail_fix)
	{
		for(i = 0; i < attachs.size; i++)
			if (getAttachmentType(attachs[i]) == "rail")
				attachs[i] = fix_rail_attach(baseName, attachs[i]);
	}
	
	return attachs;
}

build_weapon(baseName, attachs) //add camos, reticle
{
	if (!isDefined(attachs)) return maps\mp\gametypes\_class::buildweaponname(baseName, "none", "none", 0, 0);

	attachs = array_map(attachs, ::fix_rail_attach, baseName, "{i}");	
	attachs = alphabetize(attachs);
	hasSight = array_any(attachs, ::isSight);
	
	fullname = baseName + "_mp_";
	if (!hasSight && getWeaponClass(baseName) == "weapon_sniper")
		fullname += get_weapon_bareName(baseName) + "scope_";

	return fullname + string_array_join("_", attachs);
}

fix_rail_attach(baseName, attach)
{
	if (attach == "vzscope") return getSubStr(baseName, 4, baseName.size) + "scopevz";
	wep_class = get_weapon_class(baseName);
	if (wep_class == "weapon_assault" && (attach == "gp25" || attach == "gp25")) return "gl";
	if (wep_class == "smg" || wep_class == "lmg" || wep_class == "machine_pistol") return attachmentMap(attach, baseName);
	return attach;
}

is_custom_weapon(baseName)
{
	return array_contains(get_custom_weapons(), baseName);
}

is_cammo_allow(baseName)
{
	return array_contains(["smg", "assault", "sniper", "shotgun", "lmg"], get_weapon_class(baseName));
}

isSight(attach)
{
	return getAttachmentType(attach) == "rail" || attach == "zoomscope";
}

is_combo_attach(attachs, attach)
{
	colIndex = tableLookupRowNum("mp/attachmentCombos.csv", 0, attach);
	for (i = 0; i < attachs.size; i++)
	{
		if (tableLookup("mp/attachmentCombos.csv", 0, attachs[i], colIndex) == "no")
			return false;
	}
	return true;
}

player_hasWeapon_ByBaseName(baseName)
{
    return isDefined(get_player_weapon(baseName));
}

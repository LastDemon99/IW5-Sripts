/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : weapon           |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

#include lethalbeats\array;
#include lethalbeats\player;
#include lethalbeats\attach;

#define WEAPON_CLASSES ["pistol", "assault", "smg", "machine_pistol", "shotgun", "lmg", "sniper", "projectile", "riot"]
#define WEAPON_CLASSES_PRIMARY ["assault", "smg", "shotgun", "lmg", "sniper", "riot"]
#define WEAPON_CLASSES_SECONDARY ["pistol", "machine_pistol", "projectile"]

#define CAMMO_ALLOWED_CLASS ["smg", "assault", "sniper", "shotgun", "lmg"]

#define RECIPE_TABLE "mp/recipe.csv"
#define RECIPE_WEAPONS_ROW 388

#define CHALLENGE_TABLE "mp/challengetable.csv"
#define CHALLENGE_BASENAME_COLUMN 6
#define CHALLENGE_TABLES_COLUMN 4
#define WEAPON_CHALLENGE_ATTACH_COLUMN 2

#define RAIL "rail"

#define FRAG "frag_grenade_mp"
#define THROWING_KNIFE "throwingknife_mp"

#define GRENADE_FRAG_CLASS "frag"
#define GRENADE_THROWINGKNIFE_CLASS "throwingknife"
#define GRENADE_SMOKE_CLASS "smoke"
#define GRENADE_OTHER_CLASS "other"
#define GRENADE_FLASH_CLASS "flash"

#define GRENADES_SMOKE ["concussion_grenade_mp", "smoke_grenade_mp"]
#define GRENADES_OTHER ["semtex_mp", "bouncingbetty_mp", "claymore_mp", "c4_mp"]
#define GRENADES_FLASH ["flash_grenade_mp", "specialty_scrambler", "emp_grenade_mp", "trophy_mp", "specialty_tacticalinsertion", "specialty_portable_radar"]

/*
///DocStringBegin
detail: weapon_init(): <Void>
summary: Load custom pluto weapons and required data structures for this library.
///DocStringEnd
*/
weapon_init()
{
	level.customWeapons = [];
	weapon_custom_add("iw5_cheytac", "Interveon", "sniper", ["acog", "silencer03", "thermal", "xmags", "heartbeat", "cheytacscopevz"], 2);
	weapon_custom_add("iw5_ak74u", "AK74-u", "smg", ["reflex", "silencer", "rof", "acog", "eotech", "xmags", "thermal"]);

	recipe_indexes = [];
	recipe_indexes["pistol"] = [2, 8];
	recipe_indexes["assault"] = [8, 18];
	recipe_indexes["smg"] = [18, 24];
	recipe_indexes["machine_pistol"] = [24, 28];
	recipe_indexes["shotgun"] = [28, 34];
	recipe_indexes["lmg"] = [34, 39];
	recipe_indexes["sniper"] = [39, 45];
	recipe_indexes["projectile"] = [45, 52];
	recipe_indexes["riot"] = [51];
	level.recipe_indexes = recipe_indexes;
}

/*
///DocStringBegin
detail: weapon_custom_add(baseName: <String>, name: <String>, weapon_class: <String>, attachs: <String[]>, attachs_max_count?: <Int> = 3): <Void>
summary: Allows you to add a new weapon to be considered in the functions of this library.
///DocStringEnd
*/
weapon_custom_add(baseName, name, weapon_class, attachs, attachs_max_count)
{
	if (!isDefined(attachs_max_count)) attachs_max_count = 3;
	level.customWeapons[baseName] = [weapon_class, name, attachs, attachs_max_count];
}

/*
///DocStringBegin
detail: weapon_build(baseName: <String>, attachs?: <Array> | <Undefined>, camo?: <Int> | <String> | <Undefined> = 0): <String>
summary: Builds the full weapon name with the given base name, attachments, and camo. If no attachments are provided, it returns the base weapon name with "none" attachments.
///DocStringEnd
*/
weapon_build(baseName, attachs, camo)
{
	if (!isDefined(camo)) camo = 0;
	if (isstring(camo)) camo = attach_get_camo_index(camo);
	if (!isDefined(attachs) || attachs.size == 0 || array_all(attachs, ::filter_equal, "none")) return maps\mp\gametypes\_class::buildWeaponName(baseName, "none", "none", camo, 0);

	attachs = array_filter(attachs, ::filter_not_equal, "none");
	attachs = array_map(attachs, ::attach_build, i(), baseName);
	hasSight = array_any(attachs, ::attach_is_sight);
	camo = attach_build_camo(camo);
	
	if (!hasSight && weapon_get_class(baseName) == "sniper")
		attachs[attachs.size] = weapon_get_barename(baseName) + "scope";
	attachs = array_alphabetize(attachs);

	fullname = baseName + "_mp_";
	if (camo != "") camo = "_" + camo;

	return fullname + lethalbeats\string::string_join("_", attachs) + camo;
}

/*
///DocStringBegin
detail: weapon_is_secondary_class(baseName: <String>): <Bool>
summary: Returns true if the weapon is a secondary type: `pistol`, `machine_pistol` or `projectile`.
///DocStringEnd
*/
weapon_is_secondary_class(baseName)
{
	wep_class = weapon_get_class(baseName);
	switch(wep_class)
	{
		case "pistol":
		case "machine_pistol":
		case "projectile":
			return true;
		default:
			return false;
	}
}

/*
///DocStringBegin
detail: weapon_is_primary_class(baseName: <String>): <Bool>
summary: Returns true if the weapon is a primary type: `assault`, `smg`, `shotgun`, `lmg`, `sniper` or `riot`.
///DocStringEnd
*/
weapon_is_primary_class(baseName)
{
	return !weapon_is_secondary_class(baseName);
}

/*
///DocStringBegin
detail: weapon_is_custom(baseName: <String>): <Bool>
summary: Returns true if weapon it was defined as custom.
///DocStringEnd
*/
weapon_is_custom(baseName)
{
	return isDefined(level.customWeapons[baseName]);
}

/*
///DocStringBegin
detail: weapon_is_cammo_allowed(baseName: <String>): <Bool>
summary: Returns true if the weapon allows camo.
///DocStringEnd
*/
weapon_is_cammo_allowed(baseName)
{
	return array_contains(CAMMO_ALLOWED_CLASS, weapon_get_class(baseName));
}

/*
///DocStringBegin
detail: weapon_is_valid_buff(perkName: <String>): <Bool>
summary: Returns true if the perk is an weapon buff.
///DocStringEnd
*/
weapon_is_valid_buff(perkName)
{
	switch (perkName)
	{
		case "specialty_bulletpenetration":
		case "specialty_marksman":
		case "specialty_bling":
		case "specialty_sharp_focus":
		case "specialty_armorpiercing":
		case "specialty_holdbreathwhileads":
		case "specialty_longerrange":
		case "specialty_fastermelee":
		case "specialty_reducedsway":
		case "specialty_lightweight":
		case "specialty_moredamage":
			return true;
		default:
			return false;
	}
}

weapon_has_attach(weapon)
{
	return weapon_get_current_attachs(weapon).size != 0;
}

weapon_has_silencer(weapon)
{
	return array_any(weapon_get_current_attachs(weapon), ::attach_is_silencer);
}

/*
///DocStringBegin
detail: weapon_has_attach_alt(weapon: <String>): <Bool>
summary: Returns true if any of the weapon attachments is a `grenade launcher` or `shotgun`.
///DocStringEnd
*/
weapon_has_attach_alt(weapon)
{
	return array_any(weapon_get_current_attachs(weapon), ::attach_is_alt);
}

/*
///DocStringBegin
detail: weapon_has_attach_shotgun(weapon: <String>): <Bool>
summary: Returns true if any of the weapon attachments is a `shotgun`.
///DocStringEnd
*/
weapon_has_attach_shotgun(weapon)
{
	return array_any(weapon_get_current_attachs(weapon), ::attach_is_shotgun);
}

/*
///DocStringBegin
detail: weapon_has_attach_sight(weapon: <String>): <Bool>
summary: Returns true if any of the weapon attachments is a `eotech`, `reflex`, `acog`, `hybrid` or `scopevz`.
///DocStringEnd
*/
weapon_has_attach_sight(weapon)
{
	return array_any(weapon_get_current_attachs(weapon), ::attach_is_sight);
}

/*
///DocStringBegin
detail: weapon_has_attach_gl(weapon: <String>): <Bool>
summary: Returns true if any of the weapon attachments is a `grenade launcher`.
///DocStringEnd
*/
weapon_has_attach_gl(weapon)
{
	return array_any(weapon_get_current_attachs(weapon), ::attach_is_gl);
}

/*
///DocStringBegin
detail: weapon_has_attach_akimbo(weapon: <String>): <Bool>
summary: Returns true if any of the weapon attachments is a `akimbo`.
///DocStringEnd
*/
weapon_has_attach_akimbo(weapon)
{
	return array_any(weapon_get_current_attachs(weapon), ::attach_is_akimbo);
}

/*
///DocStringBegin
detail: weapon_get_list(weapon_class: <String>): <String[]>
summary: Returns an array of weapons that match the given class.
///DocStringEnd
*/
weapon_get_list(weapon_class)
{
	if (!isDefined(weapon_class)) return array_flatten(array_map(WEAPON_CLASSES, ::weapon_get_list));
	if (weapon_class == "lethal") return array_combine([FRAG, THROWING_KNIFE], GRENADES_OTHER);
	if (weapon_class == "tactical") return array_combine(GRENADES_FLASH, GRENADES_SMOKE);
	if (weapon_class == "custom") return array_get_keys(level.customWeapons);
	if (weapon_class == "riot") weapons = ["riotshield"];
	else
	{
		index_range = level.recipe_indexes[weapon_class];
		indexes = array_range(index_range[0], index_range[1]);
		if (weapon_class == "projectile") indexes = array_filter(indexes, ::_filter_projectile);
		weapons = array_map(indexes, ::_map_recipe_weapon);
	}
	custom_weapons = array_filter(array_get_keys(level.customWeapons), ::_filter_custom_weapon, weapon_class);
	if (custom_weapons.size) return array_combine(weapons, custom_weapons);
	return weapons;
}

/*
///DocStringBegin
detail: weapon_get_primaries(): <String[]>
summary: Returns an array of primaries weapons.
///DocStringEnd
*/
weapon_get_primaries()
{
	return array_flatten(array_map(WEAPON_CLASSES_PRIMARY, ::weapon_get_list));
}

/*
///DocStringBegin
detail: weapon_get_secondaries(): <String[]>
summary: Returns an array of secondaries weapons.
///DocStringEnd
*/
weapon_get_secondaries()
{
	return array_flatten(array_map(WEAPON_CLASSES_SECONDARY, ::weapon_get_list));
}

weapon_get_lethals()
{
	return weapon_get_list("lethal");
}

weapon_get_tacticals()
{
	return weapon_get_list("tactical");
}

/*
///DocStringBegin
detail: weapon_get_barename(baseName: <String>): <String>
summary: Returns the weapon name without iw5 prefix.
///DocStringEnd
*/
weapon_get_barename(baseName)
{
	return isSubStr(baseName, "iw5_") ? getSubStr(baseName, 4, baseName.size) : baseName;
}

/*
///DocStringBegin
detail: weapon_get_display_name(baseName: <String>): <String>
summary: Returns the locstring with weapon display name.
///DocStringEnd
*/
weapon_get_display_name(weapon)
{
    baseName = weapon_get_baseName(weapon);
	if (weapon_is_custom(baseName)) return level.customWeapons[baseName][1];

    switch(baseName)
    {
        case "iw5_44magnum":
            weaponDisplay = ".44 Magnum";
            break;
        case "iw5_usp45":
        case "iw5_usp45jugg":
            weaponDisplay = "USP .45";
            break;
        case "iw5_deserteagle": weaponDisplay = "Desert Eagle"; break;
        case "iw5_mp412":
        case "iw5_mp412jugg":
            weaponDisplay = "MP412";
            break;
        case "iw5_p99": weaponDisplay = "P99"; break;
        case "iw5_fnfiveseven": weaponDisplay = "Five Seven"; break;
        case "iw5_fmg9": weaponDisplay = "FMG9"; break;
        case "iw5_skorpion": weaponDisplay = "Skorpion"; break;
        case "iw5_mp9": weaponDisplay = "MP9"; break;
        case "iw5_g18": weaponDisplay = "G18"; break;
        case "iw5_mp5": weaponDisplay = "MP5"; break;
        case "iw5_m9": weaponDisplay = "M9"; break;
        case "iw5_p90": weaponDisplay = "P90"; break;
        case "iw5_pp90m1": weaponDisplay = "PP90M1"; break;
        case "iw5_ump45": weaponDisplay = "UMP45"; break;
        case "iw5_mp7": weaponDisplay = "MP7"; break;
        case "iw5_ak47": weaponDisplay = "AK-47"; break;
        case "iw5_m16": weaponDisplay = "M16A4"; break;
        case "iw5_m4": weaponDisplay = "M4A1"; break;
        case "iw5_fad": weaponDisplay = "FAD"; break;
        case "iw5_acr": weaponDisplay = "ACR 6.8"; break;
        case "iw5_type95": weaponDisplay = "Type 95";
        case "iw5_mk14": weaponDisplay = "MK14"; break;
        case "iw5_scar": weaponDisplay = "SCAR-L"; break;
        case "iw5_g36c": weaponDisplay = "G36C"; break;
        case "iw5_cm901": weaponDisplay = "CM901"; break;
        case "iw5_ksg": weaponDisplay = "KSG 12"; break;
        case "iw5_1887": weaponDisplay = "Model 1887"; break;
        case "iw5_striker": weaponDisplay = "Striker"; break;
        case "iw5_aa12": weaponDisplay = "AA-12"; break;
        case "iw5_usas12": weaponDisplay = "USAS 12"; break;
        case "iw5_spas12": weaponDisplay = "SPAS-12"; break;
        case "iw5_m60":
        case "iw5_m60jugg": 
            weaponDisplay = "M60E4"; 
            break;
        case "iw5_mk46": weaponDisplay = "MK46"; break;
        case "iw5_pecheneg": weaponDisplay = "PKP Pecheneg"; break;
        case "iw5_sa80": weaponDisplay = "L86 LSW"; break;
        case "iw5_mg36": weaponDisplay = "MG36"; break;
        case "iw5_dragunov": weaponDisplay = "Dragunov"; break;
        case "iw5_msr": weaponDisplay = "MSR"; break;
        case "iw5_barrett": weaponDisplay = "Barrett .50cal"; break;
        case "iw5_rsass": weaponDisplay = "RSASS"; break;
        case "iw5_as50": weaponDisplay = "AS50"; break;
        case "iw5_l96a1": weaponDisplay = "L118A"; break;
        case "gl": weaponDisplay = "Grenade Launcher"; break;
        case "m320": weaponDisplay = "M320 GLM"; break;
        case "rpg": weaponDisplay = "RPG-7"; break;
        case "iw5_smaw": weaponDisplay = "SMAW"; break;
        case "stinger": weaponDisplay = "Stinger"; break;
        case "javelin": weaponDisplay = "Javelin"; break;
        case "xm25": weaponDisplay = "XM25"; break;
        case "riotshield":
        case "iw5_riotshieldjugg": 
            weaponDisplay = "Riot Shield"; 
            break;
        default: weaponDisplay = weapon; break;
    }

    attachs = weapon_get_current_attachs(weapon);    
    if (!isDefined(attachs) || attachs.size == 0) return weaponDisplay;
 
    foreach(attachment in attachs)
    {
        attachDisplay = attach_get_display_name(attachment);        
        if (isDefined(attachDisplay)) weaponDisplay += " " + attachDisplay;
    }

    return weaponDisplay;
}

/*
///DocStringBegin
detail: weapon_get_class(baseName: <String>): <String>
summary: Returns the weapon class. Unlike `maps\mp\_utility::getWeaponClass` this function returns the class without the `weapon_` prefix.
///DocStringEnd
*/
weapon_get_class(baseName)
{
	if (weapon_is_custom(baseName)) return level.customWeapons[baseName][0];
	weapon_class = maps\mp\_utility::getWeaponClass(baseName);
	return isSubStr(weapon_class, "weapon") ? getSubStr(weapon_class, 7, weapon_class.size) : weapon_class;
}

/*
///DocStringBegin
detail: weapon_get_attachs(baseName: <String>, return_builded?: <Bool> = true): <String[]>
summary: Returns an array of attachments that the weapon can have. If second argument is defined specifies if the attach is required with a format for built.
///DocStringEnd
*/
weapon_get_attachs(baseName, return_builded)
{
	if (!isDefined(return_builded)) return_builded = true;
	if (weapon_is_custom(baseName)) return level.customWeapons[baseName][2]; // where did the part about specifying the format... if is custom wep, returns built and that's it?? (￢_￢)(´･ω･`)?
	
	table = tableLookup(CHALLENGE_TABLE, CHALLENGE_BASENAME_COLUMN, baseName, CHALLENGE_TABLES_COLUMN);
	attachs = [];	
	for (row = 2; tableLookupByRow(table, row, WEAPON_CHALLENGE_ATTACH_COLUMN) != ""; row++)
		attachs[row - 2] = tableLookupByRow(table, row, WEAPON_CHALLENGE_ATTACH_COLUMN);
	
	if (return_builded)
	{
		for(i = 0; i < attachs.size; i++)
			if (attach_get_type(attachs[i]) == RAIL)
				attachs[i] = attach_build(attachs[i], baseName);
	}
	
	return attachs;
}

/*
///DocStringBegin
detail: weapon_get_current_attachs(weapon: <String>, return_builded?: <Bool> = true): <String[]>
summary: Returns an array of current weapon attachs. If second argument is defined specifies if the attach is required with a format for built.
///DocStringEnd
*/
weapon_get_current_attachs(weapon, return_builded)
{
	if (!isDefined(return_builded)) return_builded = true;

	baseName = weapon_get_baseName(weapon);
	
	if (weapon == baseName || !isSubStr(weapon, "_mp_")) return [];

	weapon = lethalbeats\string::string_remove(weapon, baseName);
	tokens = strTok(weapon, "_");
	tokens = array_remove(tokens, "mp");

	attachs = [];
	foreach(token in tokens)
	{
		if(attach_is_camo(token) || (isSubStr(token, "scope") && token != "vzscope")) continue;
		attachs[attachs.size] = return_builded ? attach_build(token, baseName) : token;
	}
	return attachs;
}

/*
///DocStringBegin
detail: weapon_get_max_attachs(baseName: <String>): <Int>
summary: Returns the maximum number of attachments that the weapon can have.
///DocStringEnd
*/
weapon_get_max_attachs(baseName)
{
	if (weapon_is_custom(baseName)) return level.customWeapons[baseName][3];
	attachs_size = weapon_get_attachs(baseName).size;
	return attachs_size < 3 ? attachs_size : 3;
}

/*
///DocStringBegin
detail: weapon_get_current_camo(weapon: <String>): <String> | <Undefined>
summary: Returns the current camo of the weapon. If it do not have, returns undefined.
///DocStringEnd
*/
weapon_get_current_camo(weapon)
{
	weapon = weapon_get_barename(weapon);
	if (isSubStr(weapon, "_mp")) weapon = lethalbeats\string::string_replace(weapon, "_mp", "");
	if (!isSubStr(weapon, "_")) return undefined;
	tokens = strTok(weapon, "_");
	return tokens[tokens.size - 1];
}

/*
///DocStringBegin
detail: weapon_get_equipment_class(baseName: <String>): <String>
summary: Returns grenade class.
///DocStringEnd
*/
weapon_get_equipment_class(baseName)
{
	if (baseName == FRAG) return GRENADE_FRAG_CLASS;
	if (baseName == THROWING_KNIFE) return GRENADE_THROWINGKNIFE_CLASS;
	if (array_contains(GRENADES_SMOKE, baseName)) return GRENADE_SMOKE_CLASS;
	if (array_contains(GRENADES_OTHER, baseName)) return GRENADE_OTHER_CLASS;
	if (array_contains(GRENADES_FLASH, baseName)) return GRENADE_FLASH_CLASS;
}

/*
///DocStringBegin
detail: weapon_get_baseName(weapon: <String>): <String>
summary: Returns weapon base name.
///DocStringEnd
*/
weapon_get_baseName(weapon)
{
	tokens = strtok(weapon, "_");
	switch(tokens[0])
	{
		case "alt": return tokens[1] + "_" + tokens[2];
		case "iw5": return tokens[0] + "_" + tokens[1];
		default: return tokens[0];
	}
}

weapon_get_random_ammo_data(weapon)
{
	ammoData = [];
	
	if (weapon_has_attach_alt(weapon))
	{
		ammoData["type"] = "alt";

		maxClip = weaponClipSize(weapon);
		maxStock = weaponMaxAmmo(weapon);
		ammoData["clip"] = randomInt(maxClip + 1);
		ammoData["stock"] = randomInt(maxStock + 1);
		
		altWeapon = "alt_" + weapon;
		maxAltClip = weaponClipSize(altWeapon);
		maxAltStock = weaponMaxAmmo(altWeapon);
		ammoData["alt_clip"] = randomInt(maxAltClip + 1);
		ammoData["alt_stock"] = randomInt(maxAltStock + 1);
	}
	else if (weapon_has_attach_akimbo(weapon))
	{
		ammoData["type"] = "akimbo";

		maxClip = weaponClipSize(weapon);
		maxStock = weaponMaxAmmo(weapon);

		ammoData["left_clip"] = randomInt(maxClip + 1);
		ammoData["right_clip"] = randomInt(maxClip + 1);
		ammoData["stock"] = randomInt(maxStock + 1);
	}
	else
	{
		ammoData["type"] = "standard";

		maxClip = weaponClipSize(weapon);
		maxStock = weaponMaxAmmo(weapon);

		ammoData["clip"] = randomInt(maxClip + 1);
		ammoData["stock"] = randomInt(maxStock + 1);
	}

	return ammoData;
}

weapon_get_random()
{
	return array_random(weapon_get_list());
}

/*
///DocStringBegin
detail: weapon_get_classes(): <String[]>
summary: Returns: ["pistol", "assault", "smg", "machine_pistol", "shotgun", "lmg", "sniper", "projectile", "riot"]
///DocStringEnd
*/
weapon_get_classes()
{
	return WEAPON_CLASSES;
}

_filter_projectile(i) { return i != 46 && i != 51; }
_map_recipe_weapon(column) { return tableLookupByRow(RECIPE_TABLE, RECIPE_WEAPONS_ROW, column); }
_filter_custom_weapon(i, class_name) { return level.customWeapons[i][0] == class_name; }

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

#include scripts\lethalbeats\array;
#include scripts\lethalbeats\string;
#include scripts\lethalbeats\player;
#include scripts\lethalbeats\attach;

init()
{
	level.customWeapons = [];
	weapon_custom_add("iw5_cheytac", "Interveon", "sniper", ["acog", "silencer03", "thermal", "xmags", "heartbeat", "vzscope"], 2);
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

weapon_custom_add(baseName, name, weapon_class, attachs, attachs_max_count)
{
	if (!isDefined(attachs_max_count)) attachs_max_count = 3;
	level.customWeapons[baseName] = [weapon_class, name, attachs, attachs_max_count];
}

weapon_build(baseName, attachs, camo) // add reticle?
{
	if (!isDefined(camo)) camo = 0;
	if (isstring(camo)) camo = attach_get_camo_index(camo);
	if (!isDefined(attachs) || attachs.size == 0) return maps\mp\gametypes\_class::buildweaponname(baseName, "none", "none", camo, 0);

	attachs = array_map(attachs, ::attach_build, i(), baseName);
	attachs = array_alphabetize(attachs);
	hasSight = array_any(attachs, ::attach_is_sight);
	camo = attach_build_camo(camo);
	
	fullname = baseName + "_mp_";
	if (!hasSight && weapon_get_class(baseName) == "sniper")
		fullname += weapon_get_barename(baseName) + "scope_";

	if (camo != "") camo = "_" + camo;

	return fullname + string_join("_", attachs) + camo;
}

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

weapon_is_primary_class(weapon)
{
	return !weapon_is_secondary_class(weapon);
}

weapon_is_custom(baseName)
{
	return isDefined(level.customWeapons[baseName]);
}

weapon_is_cammo_allowed(baseName)
{
	return array_contains(["smg", "assault", "sniper", "shotgun", "lmg"], weapon_get_class(baseName));
}

weapon_has_attach_alt(weapon)
{
	return array_any(get_current_attachs(weapon), ::attach_is_alt);
}

weapon_has_attach_shotgun(weapon)
{
	return array_any(get_current_attachs(weapon), ::attach_is_shotgun);
}

weapon_has_attach_sight(weapon)
{
	return array_any(get_current_attachs(weapon), ::attach_is_sight);
}

weapon_has_attach_gl(weapon)
{
	return array_any(get_current_attachs(weapon), ::attach_is_gl);
}

weapon_has_attach_akimbo(weapon)
{
	return array_any(get_current_attachs(weapon), ::attach_is_akimbo);
}

weapon_get(weapon_class)
{
	if (weapon_class == "riot") weapons = ["riotshield"];
	else
	{
		index_range = level.recipe_indexes[weapon_class];
		indexes = array_arange(index_range[0], index_range[1]);
		if (weapon_class == "projectile") indexes = array_filter(index_array, ::_projectile_filter);
		weapons = array_map(indexes, ::_weapon_from_recipe);
	}
	custom_weapons = array_filter(array_get_keys(level.customWeapons), ::_weapon_custom_filter, i(), weapon_class);
	if (custom_weapons.size) return array_combine(weapons, custom_weapons);
	return weapons;
}

_projectile_filter(i) { return i != 46 && i != 51; }
_weapon_from_recipe(column) { return tableLookupByRow("mp/recipe.csv", 388, column); }
_weapon_custom_filter(i, class_name) { return level.customWeapons[i][0] == class_name; }

weapon_get_all()
{
	return array_flatten(array_map(["assault", "smg", "shotgun", "lmg", "sniper", "riot", "pistol", "machine_pistol", "projectile"], ::weapon_get));
}

weapon_get_primaries()
{
	return array_flatten(array_map(["assault", "smg", "shotgun", "lmg", "sniper", "riot"], ::weapon_get));
}

weapon_get_secondaries()
{
	return array_flatten(array_map(["pistol", "machine_pistol", "projectile"], ::weapon_get));
}

weapon_get_barename(baseName)
{
	return string_contains(baseName, "iw5_") ? getSubStr(baseName, 4, baseName.size) : baseName;
}

weapon_get_display_name(baseName)
{	
	if (weapon_is_custom(baseName)) return level.customWeapons[baseName][1];
	return &tablelookup("mp/statstable.csv", 4, baseName, 3);
}

weapon_get_class(baseName)
{
	if (weapon_is_custom(baseName)) return level.customWeapons[baseName][0];
	weapon_class = getWeaponClass(baseName);
	return string_get_substring(weapon_class, 7, weapon_class.size);
}

weapon_get_attachs(baseName, return_builded)
{
	if (!isDefined(return_builded)) return_builded = true;
	if (weapon_is_custom(baseName)) return level.customWeapons[baseName][2]; // return_builded?
	
	table = tableLookup("mp/challengetable.csv", 6, baseName, 4);
	
	attachs = [];	
	for (row = 2; tableLookupByRow(table, row, 2) != ""; row++)
		attachs[row - 2] = tableLookupByRow(table, row, 2);
	
	if (isDefined(return_builded))
	{
		for(i = 0; i < attachs.size; i++)
			if (attach_get_type(attachs[i]) == "rail")
				attachs[i] = attach_build(attachs[i], baseName);
	}
	
	return attachs;
}

weapon_get_current_attachs(weapon, get_baseName)
{
	if (!isDefined(get_baseName)) get_baseName = true;

	tokens = string_split(weapon, "_");
	is_attach = false;
	attachs = [];

	foreach(token in tokens)
	{
		if (is_attach)
		{
			if(attach_is_camo(token) || !string_starts_with(token, "vz") && string_contains(token, "scope")) continue;
			if (get_baseName) attachs[attachs.size] = attach_get_basename(token);
			else attachs[attachs.size] = token;
		}
		if (token == "mp") is_attach = true;
	}
	return attachs;
}

weapon_get_max_attachs(baseName)
{
	if (weapon_is_custom(baseName)) return level.customWeapons[baseName][3];
	attachs_size = weapon_get_attachs(baseName).size;
	return attachs_size < 3 ? attachs_size : 3;
}

weapon_get_current_camo(weapon)
{
	tokens = strTok(weapon, "_");
	return tokens[tokens.size - 1];
}

weapon_get_equipment_class(grenade)
{
	if (grenade == "frag_grenade_mp") return "frag";
	if (grenade == "throwingknife_mp") return "throwingknife";
	if (grenade == "concussion_grenade_mp" || grenade == "smoke_grenade_mp") return "smoke";
	if (array_contains(["semtex_mp", "bouncingbetty_mp", "claymore_mp", "c4_mp"], grenade)) return "other";
	if (array_contains(["flash_grenade_mp", "specialty_scrambler", "emp_grenade_mp", "trophy_mp", "specialty_tacticalinsertion", "specialty_portable_radar"], grenade)) return "flash";
}

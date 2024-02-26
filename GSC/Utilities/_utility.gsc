#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : Utility          |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/


/*
=========================
	Hud Region
=========================
*/

createTimer(time, font, size, align, relative, x, y)
{
	timer = createServerTimer(font, size);	
	timer setpoint(align, relative, x, y);
	timer.alpha = 1;
	timer.hideWhenInMenu = true;
	timer.foreground = true;
	timer setTimer(time);
	
	return timer;
}

createHudText(text, font, size, align, relative, x, y)
{
	hudText = createServerFontString(font, size);
	hudText setpoint(align, relative, x, y);
	hudText setText(text); 
	hudText.alpha = 1;
	hudText.hideWhenInMenu = true;
	hudText.foreground = true;
	return hudText;
}

/*
=========================
	Weapons Region
=========================
*/

add_custom_weapon(baseName, name, weapon_class, attachs)
{
	if (!isDefined(level.customWeapons)) level.customWeapons = [];
	if (!isDefined(level.customWeapons[weapon_class])) level.customWeapons[weapon_class] = [];
	if (!isDefined(level.customWeapon)) level.customWeapon = [];
	
	level.customWeapons[weapon_class][level.customWeapons[weapon_class].size] = baseName;
	level.customWeapon[baseName] = [name, attachs];
}

customWeaponsHas(baseName)
{
	return array_contain(getArrayKeys(level.customWeapon), baseName);
}

giveSpawnWeapon(weapon, switch_to_weapon)
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

__giveWeapon(weapon)
{
	if (!isSubStr(weapon, "_mp_") && !string_end_with(weapon, "_mp"))
		weapon = weapon + "_mp";	
	self _giveWeapon(weapon);
}

giveNade(nade, isPrimary)
{
	if (!isDefined(isPrimary)) isPrimary = true;
	
	if (isPrimary) self setOffhandPrimaryClass(getEquipmentClass(nade));
	else self setOffhandSecondaryClass(getEquipmentClass(nade));
	
	if(isSubStr(nade, "sp"))
	{
		self givePerk(nade, false);
		return;
	}
	
	self _giveWeapon(nade);
	if (nade != "emp_grenade_mp") self _setPerk(nade, false);
}

fix_rail_attach(attach, baseName)
{
	if (attach == "vzscope") return getSubStr(baseName, 4, baseName.size) + "scopevz";
	wep_class = getWeaponClass(baseName);
	if (wep_class == "weapon_smg" || wep_class == "weapon_lmg" || wep_class == "weapon_machine_pistol") return attachmentMap(attach, baseName);
	return attach;
}

getWeaponAttachs(baseName, rail_fix)
{
	if (customWeaponsHas(baseName))
		return level.customWeapon[baseName][1];
	
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

getAttachCombos(attachs, attach)
{
	if (!isDefined(attach)) return attachs;
	
	attachmentCombos = [];
	colIndex = tableLookupRowNum("mp/attachmentCombos.csv", 0, attach);
	
	for (i = 0; i < attachs.size - 1; i++)
	{
		if (tableLookup("mp/attachmentCombos.csv", 0, attachs[i], colIndex) == "no")
			continue;
				
		attachmentCombos[attachmentCombos.size] = attachs[i];
	}
	return attachmentCombos;
}

buildWeaponAttachs(baseName, attachs, rail_fix)
{
	if (!isDefined(rail_fix)) rail_fix = false;
	
	attachs = array_map(attachs, ::fix_rail_attach, baseName);

	if (!isSubStr(baseName, "_mp_") && !string_end_with(baseName, "_mp"))
		baseName = baseName + "_mp";
	
	attachs = alphabetize(attachs);
	foreach(attach in attachs) baseName += "_" + attach;
		
	return baseName;
}

getRandomAttachs(baseName, attachs_count, rail_fix, include_none)
{
	if (!isDefined(attachs_count)) attachs_count = 2;
	if (!isDefined(rail_fix)) rail_fix = false;
	if (!isDefined(include_none)) include_none = false;
	
	if (getWeaponClass(baseName) == "weapon_sniper")
	{
		allowed_attachs = ["silencer03", "xmags", "heartbeat"];
		attachs = [random(["vzscope", "acog", "thermal"])];
		attachs_count = attachs_count - 1;
	}
	else
	{
		allowed_attachs = getWeaponAttachs(baseName);
		if (allowed_attachs.size < attachs_count) attachs_count = allowed_attachs.size;		
		attachs = [];
	}
	
	while(attachs_count != 0)
	{
		if (include_none && cointoss() && cointoss())
		{
			attachs_count--;
			continue;
		}
		
		attach = random(allowed_attachs);
		attachs[attachs.size] = attach;
		allowed_attachs = getAttachCombos(allowed_attachs, attach);
		attachs_count--;
	}
	
	if (rail_fix)
	{
		for(i = 0; i < attachs.size; i++)
			if (getAttachmentType(attachs[i]) == "rail")
				attachs[i] = fix_rail_attach(attachs[i], baseName);
	}
	
	return attachs;
}

getNades(class_type)
{
	if (isDefined(class_type))
		return class_type == "lethal" ? array_arange_map(37, 43, ::getNadesbyperktableRow) : array_arange_map(43, 51, ::getNadesbyperktableRow);	
	return array_arange_map(37, 51, ::getNadesbyperktableRow);
}

getNadesbyperktableRow(row)
{
	return tableLookupByRow("mp/perktable.csv", row, 1);
}

getEquipmentClass(nade)
{
	if (nade == "frag_grenade_mp") return "frag";
	if (nade == "throwingknife_mp") return "throwingknife";
	if (nade == "concussion_grenade_mp" || nade == "smoke_grenade_mp") return "smoke";
	if (array_contain(["semtex_mp", "bouncingbetty_mp", "claymore_mp", "c4_mp"], nade)) return "other";
	if (array_contain(["flash_grenade_mp", "specialty_scrambler", "emp_grenade_mp", "trophy_mp", "specialty_tacticalinsertion", "specialty_portable_radar"], nade)) return "flash";
}

getCamos()
{
	camos = [];
	for(i = 1; i < 14; i++)
		camos[camos.size] = i < 10 ? "camo0" + i : "camo" + i;
	return camos;
}

getPrimaries()
{
	return getWeaponsByClasses(["weapon_assault", "weapon_smg", "weapon_shotgun", "weapon_lmg", "weapon_sniper", "weapon_riot"]);
}

getSecondaries()
{
	return getWeaponsByClasses(["weapon_pistol", "weapon_machine_pistol", "weapon_projectile"]);
}

getWeapons()
{
	return array_combine(getPrimaries(), getSecondaries());
}

getWeaponsByClasses(classes)
{
	weapons = [];
	foreach(class in classes)
		foreach(weapon in getWeaponsByClass(class))
			weapons[weapons.size] = weapon;
	return weapons;
}

getWeaponsByClass(weapon_class)
{
	if (weapon_class == "weapon_riot") weapons = [getWeaponsByRecipeColumn(51)];
	else
	{
		recipe_index = [2, 8, 18, 24, 28, 34, 39, 45, 53]; // index_range:: i = start, i + 1 = end
		wep_class = ["weapon_pistol", "weapon_assault", "weapon_smg", "weapon_machine_pistol", "weapon_shotgun", "weapon_lmg", "weapon_sniper", "weapon_projectile"];
		
		index = array_first_index(wep_class, ::equal, weapon_class);
		weapons = array_arange_map(recipe_index[index], recipe_index[index + 1], ::getWeaponsByRecipeColumn);
		
		if (weapon_class == "weapon_projectile") weapons = array_filter(weapons, ::notEqual, "", "riotshield"); //index 46, 51
	}
	
	if (!array_is_blank(level.customWeapons[weapon_class])) return array_combine(weapons, level.customWeapons[weapon_class]);
	return weapons;
}

getWeaponsByRecipeColumn(column)
{
	return tableLookupByRow("mp/recipe.csv", 388, column);
}

camoIsAllow(weapon)
{
	return array_contain(["weapon_smg", "weapon_assault", "weapon_sniper", "weapon_shotgun", "weapon_lmg"], getWeaponClass(weapon));
}

refillAmmo()
{
    level endon("game_ended");
    self endon("disconnect");

    for (;;)
    {
        self waittill("reload");
		
		if(isInfect(self)) break;
		
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
		if(isInfect(self)) break;
		
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
		
		if(isInfect(self)) break;
		
		if(array_contain(weaponName, level.weapons["lethal"]))
		{
			if(weaponName != "c4_mp") wait(1);
			else wait(3);
		}
		else if(array_contain(weaponName, level.weapons["tactical"])) wait(4);
		
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

getWeaponName(baseName)
{
	if (customWeaponsHas(baseName))
		return level.customWeapon[baseName][0];
	
	switch(baseName)
	{
		case "riotshield": return &"WEAPON_RIOTSHIELD";
		case "iw5_44magnum": return &"WEAPON_MAGNUM";
		case "iw5_usp45": return &"WEAPON_USP";
		case "iw5_usp45jugg": return &"WEAPON_USP";
		case "iw5_deserteagle": return &"WEAPON_DESERTEAGLE";
		case "iw5_mp412": return &"WEAPON_MP412";
		case "iw5_mp412jugg": return &"WEAPON_MP412";
		case "iw5_p99": return &"WEAPON_P99";
		case "iw5_fnfiveseven": return &"WEAPON_FNFIVESEVEN";
		case "iw5_fmg9": return &"WEAPON_FMG9";
		case "iw5_skorpion": return &"WEAPON_SKORPION";
		case "iw5_mp9": return &"WEAPON_MP9";
		case "iw5_g18": return &"WEAPON_GLOCK";
		case "iw5_mp5": return &"WEAPON_MP5K";
		case "iw5_m9": return &"WEAPON_UZI";
		case "iw5_p90": return &"WEAPON_P90";
		case "iw5_pp90m1": return &"WEAPON_PP90M1";
		case "iw5_ump45": return &"WEAPON_UMP45";
		case "iw5_mp7": return &"WEAPON_MP7";
		case "iw5_ak47": return &"WEAPON_AK47";
		case "iw5_m16": return &"WEAPON_M16";
		case "iw5_m4": return &"WEAPON_M4";
		case "iw5_fad": return &"WEAPON_FAD";
		case "iw5_acr": return &"WEAPON_ACR";
		case "iw5_type95": return &"WEAPON_TYPE95";
		case "iw5_mk14": return &"WEAPON_MK14";
		case "iw5_scar": return &"WEAPON_SCAR";
		case "iw5_g36c": return &"WEAPON_G36";
		case "iw5_cm901": return &"WEAPON_CM901";
		case "gl": return &"WEAPON_GRENADE_LAUNCHER";
		case "m320": return &"WEAPON_M320";
		case "rpg": return &"WEAPON_RPG";
		case "iw5_smaw": return &"WEAPON_SMAW";
		case "stinger": return &"WEAPON_STINGER";
		case "javelin": return &"WEAPON_JAVELIN";
		case "xm25": return &"WEAPON_XM25";
		case "iw5_dragunov": return &"WEAPON_DRAGUNOV";
		case "iw5_msr": return &"WEAPON_MSR";
		case "iw5_barrett": return &"WEAPON_BARRETT";
		case "iw5_rsass": return &"WEAPON_RSASS";
		case "iw5_as50": return &"WEAPON_AS50";
		case "iw5_l96a1": return &"WEAPON_L96A1";
		case "iw5_ksg": return &"WEAPON_KSG";
		case "iw5_1887": return &"WEAPON_MODEL1887";
		case "iw5_striker": return &"WEAPON_STRIKER";
		case "iw5_aa12": return &"WEAPON_AA12";
		case "iw5_usas12": return &"WEAPON_USAS12";
		case "iw5_spas12": return &"WEAPON_SPAS12";
		case "iw5_m60jugg": return &"WEAPON_M60";
		case "iw5_m60": return &"WEAPON_M60";
		case "iw5_mk46": return &"WEAPON_MK46";
		case "iw5_pecheneg": return &"WEAPON_PECHENEG";
		case "iw5_sa80": return &"WEAPON_SA80";
		case "iw5_mg36": return &"WEAPON_MG36";
	}
}

/*
=========================
	String Region
=========================
*/

string_reverse(string)
{
	reverse = "";
	for (i = string.size - 1; i > -1; i--)
		reverse += string[i];
	return reverse;
}

string_end_with(string, end)
{
	if (string.size < end.size)
		return false;
	
	end = string_reverse(end);
	for (i = 0; i < end.size; i++)
	{
		if (tolower(string[string.size - i - 1]) != tolower(end[i]))
			return false;
	}

	return true;	
}

upper(string)
{
	upper_string = "";
	foreach(i in string)
	{
		switch(i)
		{
			case "a": upper_string += "A"; break;
			case "b": upper_string += "B"; break;
			case "c": upper_string += "C"; break;
			case "d": upper_string += "D"; break;
			case "e": upper_string += "E"; break;
			case "f": upper_string += "F"; break;
			case "g": upper_string += "G"; break;
			case "h": upper_string += "H"; break;
			case "i": upper_string += "I"; break;
			case "j": upper_string += "J"; break;
			case "k": upper_string += "K"; break;
			case "l": upper_string += "L"; break;
			case "m": upper_string += "M"; break;
			case "n": upper_string += "N"; break;
			case "o": upper_string += "O"; break;
			case "p": upper_string += "P"; break;
			case "q": upper_string += "Q"; break;
			case "r": upper_string += "R"; break;
			case "s": upper_string += "S"; break;
			case "t": upper_string += "T"; break;
			case "u": upper_string += "U"; break;
			case "v": upper_string += "V"; break;
			case "w": upper_string += "W"; break;
			case "x": upper_string += "X"; break;
			case "y": upper_string += "Y"; break;
			case "z": upper_string += "Z"; break;
			default: upper_string += i;
		}
	}	
	return upper_string;
}

/*
=========================
	Array Region
=========================
*/

array_first_index(array, filter, var1, var2, var3)
{
	if (isDefined(var3))
	{
		for(i = 0; i < array.size; i++)
			if ([[filter]](array[i], var1, var2, var3))
				return i;
	}
	
	if (isDefined(var2))
	{
		for(i = 0; i < array.size; i++)
			if ([[filter]](array[i], var1, var2))
				return i;
	}
	
	if (isDefined(var1))
	{
		for(i = 0; i < array.size; i++)
			if ([[filter]](array[i], var1))
				return i;
	}
	
	for(i = 0; i < array.size; i++)
		if ([[filter]](array[i]))
			return i;

	return undefined;
}

array_first(array, filter, var1, var2, var3)
{
	if (isDefined(var3)) return array[array_first_index(array_first_index(array, filter, var1, var2, var3))];
	if (isDefined(var2)) return array[array_first_index(array_first_index(array, filter, var1, var2))];
	if (isDefined(var1)) return array[array_first_index(array_first_index(array, filter, var1))];
	return array[array_first_index(array_first_index(array, filter))];
}

array_arange(start, end, filter, var1, var2, var3)
{
	new_array = [];
	
	if (isDefined(filter))
	{
		if (isDefined(var3))
		{
			for(i = start; i < end; i++)
				if ([[filter]](i, var1, var2, var3))
					new_array[new_array.size] = i;
			return new_array;
		}
		
		if (isDefined(var2))
		{
			for(i = start; i < end; i++)
				if ([[filter]](i, var1, var2))
					new_array[new_array.size] = i;
			return new_array;
		}
		
		if (isDefined(var1))
		{
			for(i = start; i < end; i++)
				if ([[filter]](i, var1))
					new_array[new_array.size] = i;
			return new_array;
		}
		
		for(i = start; i < end; i++)
			if ([[filter]](i))
				new_array[new_array.size] = i;
		return new_array;
	}
	
	for(i = start; i < end; i++)
		new_array[new_array.size] = i;
	return new_array;
}

array_arange_map(start, end, function, var1, var2, var3)
{
	new_array = [];
	
	if (isdefined(var3))
	{
		for(i = start; i < end; i++)
			new_array[new_array.size] = [[function]](i, var1, var2, var3);
		return new_array;
	}
	
	if (isdefined(var2))
	{
		for(i = start; i < end; i++)
			new_array[new_array.size] = [[function]](i, var1, var2);
		return new_array;
	}
	
	if (isdefined(var1))
	{
		for(i = start; i < end; i++)
			new_array[new_array.size] = [[function]](i, var1);
		return new_array;
	}
	
	for(i = start; i < end; i++)
		new_array[new_array.size] = [[function]](i);
	return new_array;
}

array_filter(array, filter, var1, var2, var3)
{
	new_array = [];

	if (isDefined(var3))
	{
		foreach(i in array)
			if ([[filter]](i, var1, var2, var3))
				new_array[new_array.size] = i;
		return new_array;
	}
	
	if (isDefined(var2))
	{
		foreach(i in array)
			if ([[filter]](i, var1, var2))
				new_array[new_array.size] = i;
		return new_array;
	}
	
	if (isDefined(var1))
	{
		foreach(i in array)
			if ([[filter]](i, var1))
				new_array[new_array.size] = i;
		return new_array;
	}
	
	foreach(i in array)
		if ([[filter]](i))
			new_array[new_array.size] = i;
	return new_array;
}

array_map(array, function, var1, var2, var3)
{
	new_array = [];
	
	if (isDefined(var3))
	{
		foreach(i in array) 
			new_array[new_array.size] = [[function]](i, var1, var2, var3);
		return new_array;
	}
	
	if (isDefined(var2))
	{
		foreach(i in array) 
			new_array[new_array.size] = [[function]](i, var1, var2);
		return new_array;
	}
	
	if (isDefined(var1))
	{
		foreach(i in array) 
			new_array[new_array.size] = [[function]](i, var1);
		return new_array;
	}
	
	foreach(i in array) 
		new_array[new_array.size] = [[function]](i);
	return new_array;
}

array_contain(array, item)
{
	if (!isDefined(array)) return false;
	foreach(i in array)
		if (i == item) return true;
	return false;
}

array_contain_array(array, array_items)
{
	foreach(item in array_items)
		if (array_contain(array, item))	return true;
	return false;
}

_array_combine(array1, array2, array3, array4, array5)
{
	new_array = [];
			
	foreach (i in array1)
		new_array[new_array.size] = i;
			
	if (!isDefined(array2)) return new_array;
	foreach (i in array2)
		new_array[new_array.size] = i;
			
	if (!isDefined(array3)) return new_array;
	foreach (i in array3)
		new_array[new_array.size] = i;
			
	if (!isDefined(array4)) return new_array;
	foreach (i in array4)
		new_array[new_array.size] = i;
			
	if (!isDefined(array5)) return new_array;
	foreach (i in array5)
		new_array[new_array.size] = i;
	
	return new_array;
}

array_is_blank(array) { return !isDefined(array) || array.size == 0; }

/*
=========================
	Game Logic Region
=========================
*/

spawnBypass()
{
	replacefunc(maps\mp\_utility::allowTeamChoice, ::returnFalse);
	replacefunc(maps\mp\_utility::allowClassChoice, ::returnFalse);
}

teamBypass() { replacefunc(maps\mp\_utility::allowTeamChoice, ::returnFalse); }
classBypass() { replacefunc(maps\mp\_utility::allowClassChoice, ::returnFalse); }

setSpecialLoadout()
{
	level.specialLoadout["loadoutPrimary"] = "none";
    level.specialLoadout["loadoutPrimaryAttachment"] = "none";
    level.specialLoadout["loadoutPrimaryAttachment2"] = "none";
    level.specialLoadout["loadoutPrimaryBuff"] = "specialty_null";
    level.specialLoadout["loadoutPrimaryCamo"] = "none";
    level.specialLoadout["loadoutPrimaryReticle"] = "none";
    level.specialLoadout["loadoutSecondary"] = "none";
    level.specialLoadout["loadoutSecondaryAttachment"] = "none";
    level.specialLoadout["loadoutSecondaryAttachment2"] = "none";
    level.specialLoadout["loadoutSecondaryBuff"] = "specialty_null";
    level.specialLoadout["loadoutSecondaryCamo"] = "none";
    level.specialLoadout["loadoutSecondaryReticle"] = "none";
    level.specialLoadout["loadoutEquipment"] = "none";
    level.specialLoadout["loadoutOffhand"] = "none";
    level.specialLoadout["loadoutPerk1"] = "specialty_null";
    level.specialLoadout["loadoutPerk2"] = "specialty_null";
    level.specialLoadout["loadoutPerk3"] = "specialty_null";
	level.specialLoadout["loadoutStreakType"] = "specialty_null";
	level.specialLoadout["loadoutKillstreak1"] = "none";
	level.specialLoadout["loadoutKillstreak2"] = "none";
	level.specialLoadout["loadoutKillstreak3"] = "none";
    level.specialLoadout["loadoutDeathstreak"] = "specialty_null";
    level.specialLoadout["loadoutJuggernaut"] = false;
	
	level.onSpawnPlayer = ::onSpawnPlayerSpecialLoadout;
}

setPlayerSpecialLoadout()
{ 
	if (!isDefined(level.specialLoadout)) setSpecialLoadout();
	self.specialLoadout = level.specialLoadout; 
}

onSpawnPlayerSpecialLoadout()
{
	self.class = "gamemode";
	self.pers["class"] = "gamemode";
	self.pers["gamemodeLoadout"] = isDefined(self.specialLoadout) ? self.specialLoadout : level.specialLoadout;
	level notify ("spawned_player");	
}

giveLoadout(team, class, allowCopycat, setPrimarySpawnWeapon)
{
	if(self isTestClient()) self maps\mp\bots\_bot_utility::botGiveLoadout(team, class, allowCopycat, setPrimarySpawnWeapon);
	else self maps\mp\gametypes\_class::giveLoadout(team, class, allowCopycat, setPrimarySpawnWeapon);
}

/*
=========================
	Player Region
=========================
*/

giveModeAllPerks(splashPerks)
{
	if(self isTestClient()) return;
	if (!isDefined(splashPerks)) splashPerks = false;
	
	perks = [ "specialty_longersprint",
				"specialty_fastreload",
				"specialty_blindeye",
				"specialty_paint",
				"specialty_coldblooded",
				"specialty_quickdraw",				
				"specialty_autospot",
				"specialty_bulletaccuracy",
				"specialty_quieter",
				"specialty_stalker",
				"specialty_bulletpenetration",
				"specialty_marksman",
				"specialty_sharp_focus",
				"specialty_longerrange",
				"specialty_fastermelee",
				"specialty_reducedsway",
				"specialty_scavenger",
				"specialty_lightweight"];
			
	foreach(perk in perks)
		if(!self _hasPerk(perk))
		{
			self givePerk(perk, false);
			if(maps\mp\gametypes\_class::isPerkUpgraded(perk))
			{
				perkUpgrade = tablelookup( "mp/perktable.csv", 1, perk, 8);
				self givePerk(perkUpgrade, false);
			}
		}
	
	if (!splashPerks) return;	
	if(self isFirstSpawn()) wait 4.8;
	self maps\mp\gametypes\_hud_message::killstreakSplashNotify("all_perks_bonus");
}

isFirstSpawn()
{
	return !gameFlag( "prematch_done" ) || !self.hasSpawned && game["state"] == "playing" && game["status"] != "overtime";
}

isInfect(player)
{
	return getDvar("g_gametype") == "infect" && player.sessionTeam == "axis";
}

clearScoreInfo()
{
	maps\mp\gametypes\_rank::registerScoreInfo("kill", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("assist", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("suicide", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("teamkill", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("headshot", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("execution", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("avenger", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("defender", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("posthumous", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("revenge", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("double", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("triple", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("multi", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("buzzkill", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("firstblood", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("comeback", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("longshot", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("assistedsuicide", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("knifethrow", 0);
}

/*
=========================
	Random Stuff Region
=========================
*/

meleePenalty()
{
	level.knife_kill = int(maps\mp\gametypes\_rank::getScoreInfoValue("kill"));
	level.knife_kill = -level.knife_kill;
	maps\mp\gametypes\_rank::registerScoreInfo("knife_kill", level.knife_kill);
	
	level.onPlayerDamage = ::onPlayerDamageMeleePenalty;	
	replacefunc(maps\mp\bots\_bot::onPlayerDamage, ::onPlayerDamageMeleePenalty);
}

onPlayerDamageMeleePenalty(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset)
{
	if(sMeansOfDeath == "MOD_MELEE" && getWeaponClass(sWeapon) != "weapon_riot")
	{
	    maps\mp\gametypes\_gamescore::givePlayerScore("knife_kill", eAttacker);
		maps\mp\gametypes\_gamescore::givePlayerScore("knife_kill", eAttacker);
		eAttacker thread maps\mp\gametypes\_rank::giveRankXP("knife_kill");		
		eAttacker notify("melee_kill");
	}
	
	if(self isTestClient())
	{
		self maps\mp\bots\_bot_internal::onDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
		self maps\mp\bots\_bot_script::onDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
	}

	self [[level.prevCallbackPlayerDamage]](eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset);
}

meleePopUpInit()
{
	if(self isTestClient()) return;
	
	eventPopup = self maps\mp\gametypes\_rank::createXpEventPopup();
	eventPopup setText("^1" + level.knife_kill + " Melee");
	eventPopup.alpha = 0;
	eventPopup.y = -65;
	eventPopup fadeOverTime(0.5);
	self.meleePopUp = eventPopup;
	
	for(;;)
	{
		self waittill("melee_kill");
		self thread meleePopUp();
	}
}

meleePopUp()
{
	self endon("melee_kill");
	self.meleePopUp.alpha = 0.85;
	wait 1;
	self.meleePopUp.alpha = 0;
}

returnFalse() { return false; }
returnTrue() { return true; }
concat(arg1, arg2, arg3, arg4, arg5)
{
	if (isDefined(arg5)) return arg1 + arg2 + arg3 + arg4 + arg5;
	if (isDefined(arg4)) return arg1 + arg2 + arg3 + arg4;
	if (isDefined(arg3)) return arg1 + arg2 + arg3;
	return arg1 + arg2;
}
equal(arg1, arg2, arg3, arg4, arg5)
{
	if (isDefined(arg5)) return arg1 == arg2 && arg1 == arg3 && arg1 == arg4 && arg1 == arg5;
	if (isDefined(arg4)) return arg1 == arg2 && arg1 == arg3 && arg1 == arg4;
	if (isDefined(arg3)) return arg1 == arg2 && arg1 == arg3;
	return arg1 == arg2;
}
notEqual(arg1, arg2, arg3, arg4, arg5)
{
	if (isDefined(arg5)) return arg1 != arg2 && arg1 != arg3 && arg1 != arg4 && arg1 != arg5;
	if (isDefined(arg4)) return arg1 != arg2 && arg1 != arg3 && arg1 != arg4;
	if (isDefined(arg3)) return arg1 != arg2 && arg1 != arg3;
	return arg1 != arg2;
}
blank(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10) {}
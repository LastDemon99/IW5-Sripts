/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : player           |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

#include scripts\lethalbeats\string;
#include scripts\lethalbeats\array;
#include scripts\lethalbeats\weapon;

player_count(team, alives)
{
	count = 0;
	foreach (player in level.players)
	{
		if (isDefined(alives) && isAlive(player) != alives) continue;
		if (isDefined(team) && player.team != team) continue;
		count++;
	}
	return count;
}

player_get_list(team, alives)
{
	players = [];
	foreach (player in level.players)
	{
		if (isDefined(alives) && isAlive(player) != alives) continue;
		if (isDefined(team) && player.team != team) continue;
		players[players.size] = player;
	}
	return players;
}

player_give_weapon(weapon, variant, dualWieldOverRide)
{
	if (!string_contains(weapon, "_mp_") && !string_ends_with(weapon, "_mp"))
		weapon = weapon + "_mp";
	
	if (!isDefined(variant))
		variant = -1;
	
	if ( string_contains( weapon, "_akimbo" ) || isDefined(dualWieldOverRide) && dualWieldOverRide == true)
		self giveWeapon(weapon, variant, true);
	else
		self giveWeapon(weapon, variant, false);
}

player_give_spawn_weapon(weapon, switch_to_weapon)
{
	self takeAllWeapons();
	self player_give_weapon(weapon);
	self.primaryWeapon = weapon;
	self.pers["primaryWeapon"] = weapon;
	
	if (isDefined(switch_to_weapon) && switch_to_weapon)
		self switchToWeaponImmediate(weapon);
	else
		self setSpawnWeapon(weapon);
}

player_set_perk(perkName, useSlot)
{
	self.perks[perkName] = true;

	if (isDefined(level.perkSetFuncs[perkName]))
		self thread [[level.perkSetFuncs[perkName]]]();
	
	self setPerk(perkName, !isDefined(level.scriptPerks[perkName]), useSlot);
}

player_refill_ammo()
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

player_refill_single_count_ammo()
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

player_refill_nades()
{
	self endon("disconnect");
	level endon("game_ended");
	
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

player_stinger_fire()
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

player_give_nade(grenade, slot)
{
	if (!isDefined(slot)) slot = 0;	
	if (slot) self setOffhandSecondaryClass(weapon_get_equipment_class(grenade));
	else self setOffhandPrimaryClass(weapon_get_equipment_class(grenade));
	
	if(string_contains(grenade, "sp"))
	{
		self givePerk(grenade, false);
		return;
	}
	
	self player_give_weapon(grenade);
	if (grenade != "emp_grenade_mp") self player_set_perk(grenade, false);
}

player_is_infect()
{
	return getDvar("g_gametype") == "infect" && self.sessionTeam == "axis";
}

player_is_flashed()
{
	if (!isdefined(self.flashEndTime))
		return false;

	return gettime() < self.flashEndTime;
}

player_get_primaries()
{
	weapons = self getWeaponsListPrimaries();
	result = [];
	foreach(wep in weapons)
		if (!string_starts_with(wep, "alt_"))
			result[result.size] = wep;
	return result;
}

player_get_build_weapon(baseName)
{
	weapons = self getWeaponsListPrimaries();
    foreach(weapon in weapons)
		if (getBaseWeaponName(weapon) == baseName) return weapon;
    return undefined;
}

player_has_weapon(weapon)
{
	if (string_contains(weapon, "_mp"))
		return self hasWeapon(weapon);
    return isDefined(player_get_build_weapon(weapon));
}

player_has_max_ammo(weapon)
{
	hasMaxClip = weaponClipSize(weapon) == self getWeaponAmmoClip(weapon);
	hasMaxStock = int(self getFractionMaxAmmo(weapon)) == 1;

	if (hasAkimbo(weapon))
	{
		hasMaxClip = hasMaxClip && weaponClipSize(weapon) == self getWeaponAmmoClip(weapon, "left");
	}
	else if (hasAltAttach(weapon))
	{
		hasMaxClip = hasMaxClip && weaponClipSize("alt_" + weapon) == self getWeaponAmmoClip("alt_" + weapon);
		hasMaxStock = hasMaxStock && int(self getFractionMaxAmmo("alt_" + weapon)) == 1;
	}

	return hasMaxClip && hasMaxStock;
}

player_has_killstreak()
{
	return self.pers["killstreaks"].size >= 6;
}

player_save_ammo(weapon, key)
{
	if (!isDefined(key)) key = weapon;
	attachs = get_current_attachs(weapon);

	if (array_any(attachs, ::isAltAttach))
	{
		self.restoreWeaponClipAmmo["alt_" + key] = self getWeaponAmmoClip("alt_" + weapon);
		self.restoreWeaponStockAmmo["alt_" + key] = self getWeaponAmmoStock("alt_" + weapon);
		self.restoreWeaponClipAmmo[key] = self getWeaponAmmoClip(weapon);
		self.restoreWeaponStockAmmo[key] = self getWeaponAmmoStock(weapon);
		return;
	}

	if (array_contains(attachs, "akimbo"))
	{
		self.restoreWeaponClipAmmo["left_" + key] = self getWeaponAmmoClip(weapon, "left");
		self.restoreWeaponClipAmmo["right_" + key] = self getWeaponAmmoClip(weapon, "right");
	}
	else self.restoreWeaponClipAmmo[key] = self getWeaponAmmoClip(weapon);
	self.restoreWeaponStockAmmo[key] = self getWeaponAmmoStock(weapon);
}

player_restore_ammo(weapon, key)
{
	if (!isDefined(key)) key = weapon;
	if (isDefined(self.restoreWeaponClipAmmo["alt_" + key]))
	{
		self setWeaponAmmoClip("alt_" + weapon, self.restoreWeaponClipAmmo["alt_" + key]);
		self setWeaponAmmoStock("alt_" + weapon, self.restoreWeaponStockAmmo["alt_" + key]);
		self setWeaponAmmoClip(weapon, self.restoreWeaponClipAmmo[key]);
		self setWeaponAmmoStock(weapon, self.restoreWeaponStockAmmo[key]);
		return;
	}

	if (isDefined(self.restoreWeaponClipAmmo["left_" + key]))
	{
		self setWeaponAmmoClip(weapon, self.restoreWeaponClipAmmo["left_" + key], "left");
		self setWeaponAmmoClip(weapon, self.restoreWeaponClipAmmo["right_" + key], "right");
	}
	else self setWeaponAmmoClip(weapon, self.restoreWeaponClipAmmo[key]);
	self setWeaponAmmoStock(weapon, self.restoreWeaponStockAmmo[key]);
}

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

#include lethalbeats\string;
#include lethalbeats\array;
#include lethalbeats\weapon;

/*
///DocStringBegin
detail: player_suicide(): <Void>
summary: Engine functions cannot be sent as a pointer so this wrapper is used to ::suicide
///DocStringEnd
*/
player_suicide()
{
	self suicide();
}

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

player_give_weapon(weapon, variant, dualWieldOverRide)
{
	if (!string_contains(weapon, "_mp_") && !string_ends_with(weapon, "_mp"))
		weapon = weapon + "_mp";
	
	if (!isDefined(variant))
		variant = -1;
	
	if (string_contains(weapon, "_akimbo") || isDefined(dualWieldOverRide) && dualWieldOverRide == true)
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

player_give_start_ammo(perkName)
{
	self giveStartAmmo(perkName);
}

player_give_max_ammo(weapon)
{
	if (!isDefined(weapon)) weapon = self getCurrentWeapon();
	self giveMaxAmmo(weapon);
	self setWeaponAmmoClip(weapon, weaponClipSize(weapon));
	if (string_starts_with(weapon, "alt_")) return;
	if (weapon_has_attach_akimbo(weapon)) self setWeaponAmmoClip(weapon, weaponClipSize(weapon), "left");
	if (weapon_has_attach_alt(weapon))
	{
		weapon = "alt_" + weapon;
		self giveMaxAmmo(weapon);
		self setWeaponAmmoClip(weapon, weaponClipSize(weapon));
	}
}

player_set_offhand_primary_class(class)
{
	self setOffhandPrimaryClass(class);
}

player_set_offhand_secondary_class(class)
{
	self setOffhandPrimaryClass(class);
}

player_give_perk(perkName, useSlot)
{
	if (!isDefined(useSlot)) useSlot = false;

	if (string_contains(perkName, "_mp"))
	{
		switch(perkName)
		{
			case "frag_grenade_mp":
				self setOffhandPrimaryClass("frag");
				break;
			case "throwingknife_mp":
				self setOffhandPrimaryClass("throwingknife");
				break;
			case "trophy_mp":
				self setOffhandSecondaryClass("flash");
				break;
		}

		self player_give_weapon(perkName, 0);
		self giveStartAmmo(perkName);
		self player_set_perk(perkName, useSlot);
		return;
	}

	if(string_contains(perkName, "specialty_weapon_"))
	{
		self player_set_perk(perkName, useSlot);
		return;
	}

	self player_set_perk(perkName, useSlot);
	self player_set_extra_perks(perkName);
}

player_set_extra_perks(perkName)
{
	if(perkName == "specialty_coldblooded")
		self player_give_perk("specialty_heartbreaker", false);
	if(perkName == "specialty_fasterlockon")
		self player_give_perk("specialty_armorpiercing", false);
	if(perkName == "specialty_spygame")
		self player_give_perk("specialty_empimmune", false);
	if(perkName == "specialty_rollover")
		self player_give_perk("specialty_assists", false);
}

player_set_perk(perkName, useSlot)
{
	self.perks[perkName] = true;

	if (isDefined(level.perkSetFuncs[perkName]))
		self thread [[level.perkSetFuncs[perkName]]]();
	
	self setPerk(perkName, !isDefined(level.scriptPerks[perkName]), useSlot);
}

player_unset_Perk(perkName)
{
	self.perks[perkName] = undefined;
	if (isDefined(level.perkUnsetFuncs[perkName]))
		self thread [[level.perkUnsetFuncs[perkName]]]();
	self unsetPerk(perkName, !isDefined(level.scriptPerks[perkName]));
}

player_has_perk(perkName)
{
	if (isDefined(self.perks[perkName]))
		return true;	
	return false;
}

player_refill_ammo()
{
    level endon("game_ended");
    self endon("disconnect");

    for (;;)
    {
        self waittill("reload");
		if(player_is_infect(self)) break;
		weapon = self getCurrentWeapon();
		if(!isDefined(weapon) || weapon_get_class(weapon) == "riot") continue;
		self giveMaxAmmo(weapon);
    }
}

player_refill_single_count_ammo()
{
    level endon("game_ended");
    self endon("disconnect");

    for (;;)
    {
		wait 0.5;
		if(player_is_infect(self)) break;
		weapon = self getCurrentWeapon();
		if (!isDefined(weapon) || weapon_get_class(weapon) != "riot" && self getammocount(weapon) == 0)
        {
            wait 2;
            self notify("reload");
            wait 1;
            continue;
        }
        wait 0.05;
	}
}

player_nades_refill()
{
	self endon("disconnect");
	level endon("game_ended");
	
	for (;;)
    {
		self waittill("grenade_fire", grenade, weaponName);
		
		if(player_is_infect(self)) break;
		
		if(array_contains(level.weapons["lethal"], weaponName))
		{
			if(weaponName != "c4_mp") wait(1);
			else wait(3);
		}
		else if(array_contains(level.weapons["tactical"], weaponName)) wait(4);
		
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
		self player_give_perk(grenade, false);
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

/*
///DocStringBegin
detail: player_get_list(team?: <String | Undefined>, alives?: <Boolean | Undefined>): <Entity[]>
summary: Returns an array of players optionally filtered by team and alive status.
///DocStringEnd
*/
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

player_get_perks()
{
	return array_get_keys(self.perks);
}

player_get_weapons_buffs()
{
	return array_filter(self player_get_perks(), lethalbeats\perk::perk_is_weapon_buff);
}

/*
///DocStringBegin
detail: <Player> player_get_weapons(returnsAltWeapon: <Bool | Undefined>): <Bool>
summary: Returns a player weapons list.
///DocStringEnd
*/
player_get_weapons(returnsAltWeapon)
{
	if (!isDefined(returnsAltWeapon)) returnsAltWeapon = false;
	return returnsAltWeapon ? self getWeaponsList("primary") : array_filter(self getWeaponsList("primary"), ::filter_not_starts_with, "alt_");
}

player_get_primary()
{
	primary = self getWeaponsListPrimaries()[0];
	if (isDefined(primary) && primary == "none") return undefined;
	return primary;
}

player_get_secondary()
{
	secondary = self getWeaponsListPrimaries()[1];
	if (isDefined(secondary) && secondary == "none") return undefined;
	return secondary;
}

player_get_weapon_index(weapon, baseNameFormat)
{
	if (!isDefined(baseNameFormat)) baseNameFormat = false;
	return int(self player_is_weapon_secondary(weapon, baseNameFormat));
}

player_is_weapon_primary(weapon, baseNameFormat)
{
	if (!isDefined(baseNameFormat)) baseNameFormat = false;
	weaponTarget = self getWeaponsListPrimaries()[0];
	if (!isDefined(weaponTarget)) return false;
	if (!baseNameFormat) return weapon == weaponTarget;
	return weapon_get_baseName(weapon) == weapon_get_baseName(weaponTarget);
}

player_is_weapon_secondary(weapon, baseNameFormat)
{
	if (self getWeaponsListPrimaries().size == 1) return false;
	if (!isDefined(baseNameFormat)) baseNameFormat = false;
	weaponTarget = self getWeaponsListPrimaries()[1];
	if (!isDefined(weaponTarget)) return false;
	if (!baseNameFormat) return weapon == weaponTarget;
	return weapon_get_baseName(weapon) == weapon_get_baseName(weaponTarget);
}

/*
///DocStringBegin
detail: <Player> player_get_build_weapon(baseName: <String>): <String | Undefined>
summary: Returns a weapon owned by the player if it matches the given base name, ignoring attachments, or returns undefined if the weapon is not found.
///DocStringEnd
*/
player_get_build_weapon(baseName)
{
	weapons = self player_get_weapons();
    return array_find(weapons, lethalbeats\string::string_contains, baseName);
}

player_get_fraction_ammo(weapon) 
{
    if (weapon_has_attach_akimbo(weapon))
	{
        weaponLeftFraction = (self getFractionMaxAmmo(weapon) * 0.475) + ((self getWeaponAmmoClip(weapon) / weaponClipSize(weapon)) * 0.025);
        weaponRightFraction = (self getFractionMaxAmmo(weapon) * 0.475) + ((self getWeaponAmmoClip(weapon, "left") / weaponClipSize(weapon)) * 0.025);
        return weaponLeftFraction + weaponRightFraction;
    } 
	else if (weapon_has_attach_alt(weapon))
	{
        weaponFraction = (self getFractionMaxAmmo(weapon) * 0.75) + ((self getWeaponAmmoClip(weapon) / weaponClipSize(weapon)) * 0.05);
        weapon = "alt_" + weapon;
        if (weapon_has_attach_gl(weapon)) weaponAltFraction = (self getFractionMaxAmmo(weapon) * 0.1) + ((self getWeaponAmmoClip(weapon) / weaponClipSize(weapon)) * 0.1);
        else weaponAltFraction = (self getFractionMaxAmmo(weapon) * 0.15) + ((self getWeaponAmmoClip(weapon) / weaponClipSize(weapon)) * 0.05);
        return weaponFraction + weaponAltFraction;
    }

    return (self getFractionMaxAmmo(weapon) * 0.95) + ((self getWeaponAmmoClip(weapon) / weaponClipSize(weapon)) * 0.05);
}

/*
///DocStringBegin
detail: <Player> player_has_weapon(weapon: <String>, relative: <Boolean | Undefined>): <Boolean>
summary: Checks if the player possesses a specific weapon. If `relative` is true, it determines possession based on the base name of the weapon, ignoring attachments.
///DocStringEnd
*/
player_has_weapon(weapon, relative)
{
	weapon = weapon_get_baseName(weapon);
	if (isDefined(relative) && relative) return isDefined(self player_get_build_weapon(weapon));
	return self hasWeapon(weapon);
}

player_has_max_ammo(weapon)
{
	return self player_get_fraction_ammo(weapon) == 1;
}

player_has_killstreak()
{
	return self.pers["killstreaks"].size >= 6;
}

player_save_ammo(weapon, key)
{
	if (!isDefined(key)) key = weapon;

	if (weapon_has_attach_alt(weapon))
	{
		self.restoreWeaponClipAmmo["alt_" + key] = self getWeaponAmmoClip("alt_" + weapon);
		self.restoreWeaponStockAmmo["alt_" + key] = self getWeaponAmmoStock("alt_" + weapon);
		self.restoreWeaponClipAmmo[key] = self getWeaponAmmoClip(weapon);
		self.restoreWeaponStockAmmo[key] = self getWeaponAmmoStock(weapon);
		return;
	}

	if (weapon_has_attach_akimbo(weapon))
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

player_enable_usability()
{
	self.disabledUsability--;	
	if (!self.disabledUsability)
		self EnableUsability();
}

/*
///DocStringBegin
detail: players_play_sound(sound: <String>, team?: <String>, excludeTargets?: <Player[]>): <Void>
summary: Play local sounds on players. You can optionally specify the equipment or exclude players based on array.
///DocStringEnd
*/
players_play_sound(sound, team, excludeTargets)
{	
	if (isDefined(team)) targets = player_get_list(team);
	else targets = level.players;
	if (isDefined(excludeTargets)) targets = array_difference(targets, excludeTargets);
	foreach(player in targets)
		player playLocalSound(sound);
}

player_take_weapon(weapon)
{
	if (!isDefined(weapon)) weapon = self getCurrentWeapon();
	self takeWeapon(weapon);
}

player_take_all_weapon_buffs()
{
	foreach(buff in self player_get_weapons_buffs())
		self player_unset_Perk(buff);
}

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

player_give_weapon(weapon, switchInmmediate, maxAmmo)
{
	if (!string_contains(weapon, "_mp_") && !string_ends_with(weapon, "_mp"))
		weapon = weapon + "_mp";
	
	self giveWeapon(weapon);
	if (isDefined(maxAmmo) && maxAmmo) self giveMaxAmmo(weapon);
	if (isDefined(switchInmmediate) && switchInmmediate) self switchToWeaponImmediate(weapon);
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

player_give_all_perks()
{
	
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

player_refill_ammo(endonOnDeath)
{
    level endon("game_ended");
    self endon("disconnect");
	if (isDefined(endonOnDeath) && endonOnDeath) self endon("death");

    for (;;)
    {
        self waittill("reload");
		if(self player_is_infect()) break;
		weapon = self getCurrentWeapon();
		if(!isDefined(weapon) || weapon_get_class(weapon) == "riot") continue;
		self player_give_max_ammo(weapon);
    }
}

player_refill_single_count_ammo(endonOnDeath)
{
    level endon("game_ended");
    self endon("disconnect");
	if (isDefined(endonOnDeath) && endonOnDeath) self endon("death");

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

player_nades_refill(endonOnDeath)
{
    level endon("game_ended");
    self endon("disconnect");
	if (isDefined(endonOnDeath) && endonOnDeath) self endon("death");
	
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

player_stinger_fire(endonOnDeath)
{
	level endon("game_ended");
	self endon("disconnect");
	if (isDefined(endonOnDeath) && endonOnDeath) self endon("death");

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
detail: players_get_list(team?: <String | Undefined>, alives?: <Boolean | Undefined>): <Entity[]>
summary: Returns an array of players optionally filtered by team and alive status.
///DocStringEnd
*/
players_get_list(team, alives)
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

players_by_string(target)
{
    switch(target)
    {
        case "allies":
        case "axis":
        case "spectator":
            return players_get_list(target);
        case "alives":
            return players_get_list(undefined, true);
        case "allies_alive":
        case "axis_alive":
            return players_get_list(strTok(target, "_")[0], true);
        case "allies_death":
        case "axis_death":
            return players_get_list(strTok(target, "_")[0], false);
        default:
            if (target[0] == "@")
            {
                foreach(player in level.players)
                    if (lethalbeats\string::string_starts_with(player.name, "@" + target))
                        return player;
            }
			else return level.players;
            break;
    }
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
	weapons = array_remove_undefined(self getWeaponsList("primary"));
	return returnsAltWeapon ? weapons : array_filter(weapons, ::filter_not_starts_with, "alt_");
}

player_get_primary()
{
	primary = self getWeaponsListPrimaries()[0];
	if (!isDefined(primary) || primary == "none") return undefined;
	return primary;
}

player_get_secondary()
{
	secondary = self getWeaponsListPrimaries()[1];
	if (!isDefined(secondary) || secondary == "none") return undefined;
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
	weaponList = self getWeaponsListPrimaries();
	if (!isDefined(weaponList) || weaponList.size == 0 || weaponList[0] == "none") return true;

	weaponTarget = weaponList[0];
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
	if (isDefined(relative) && relative)
	{
		weapon = weapon_get_baseName(weapon);
		return isDefined(self player_get_build_weapon(weapon));
	}
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
	if (!isDefined(self.restoreAmmo)) self.restoreAmmo = [];
	self.restoreAmmo[key] = self player_get_ammo_data(weapon);
}

player_restore_ammo(weapon, key, clear)
{
	if (!isDefined(clear)) clear = false;
	if (!isDefined(key)) key = weapon;
	if (!isDefined(self.restoreAmmo) || !isDefined(self.restoreAmmo[key])) return;	
	ammoDataToRestore = self.restoreAmmo[key];
	self player_set_ammo_from_data(weapon, ammoDataToRestore);
	if (clear) self.restoreAmmo = array_remove_key(self.restoreAmmo, key);
}

player_get_ammo_data(weapon)
{
	ammoData = [];
	if (weapon_has_attach_alt(weapon))
	{
		ammoData["type"] = "alt";
		ammoData["clip"] = self getWeaponAmmoClip(weapon);
		ammoData["stock"] = self getWeaponAmmoStock(weapon);
		ammoData["alt_clip"] = self getWeaponAmmoClip("alt_" + weapon);
		ammoData["alt_stock"] = self getWeaponAmmoStock("alt_" + weapon);
	}
	else if (weapon_has_attach_akimbo(weapon))
	{
		ammoData["type"] = "akimbo";
		ammoData["left_clip"] = self getWeaponAmmoClip(weapon, "left");
		ammoData["right_clip"] = self getWeaponAmmoClip(weapon, "right");
		ammoData["stock"] = self getWeaponAmmoStock(weapon);
	}
	else
	{
		ammoData["type"] = "standard";
		ammoData["clip"] = self getWeaponAmmoClip(weapon);
		ammoData["stock"] = self getWeaponAmmoStock(weapon);
	}
	return ammoData;
}

player_set_ammo_from_data(weapon, ammoData)
{
	if (!isDefined(ammoData) || !isDefined(ammoData["type"])) return;
	switch(ammoData["type"])
	{
		case "alt":
			self setWeaponAmmoClip(weapon, ammoData["clip"]);
			self setWeaponAmmoStock(weapon, ammoData["stock"]);
			self setWeaponAmmoClip("alt_" + weapon, ammoData["alt_clip"]);
			self setWeaponAmmoStock("alt_" + weapon, ammoData["alt_stock"]);
			break;

		case "akimbo":
			self setWeaponAmmoClip(weapon, ammoData["left_clip"], "left");
			self setWeaponAmmoClip(weapon, ammoData["right_clip"], "right");
			self setWeaponAmmoStock(weapon, ammoData["stock"]);
			break;

		case "standard":
		default:
			self setWeaponAmmoClip(weapon, ammoData["clip"]);
			self setWeaponAmmoStock(weapon, ammoData["stock"]);
			break;
	}
}

player_add_ammo_from_data(weapon, ammoData)
{
	if (!isDefined(ammoData) || !isDefined(ammoData["type"])) return;

	switch(ammoData["type"])
	{
		case "alt":
			currentStock = self getWeaponAmmoStock(weapon);
			ammoToAdd = ammoData["clip"] + ammoData["stock"];
			maxStock = weaponMaxAmmo(weapon);
			newStock = int(min(currentStock + ammoToAdd, maxStock));
			self setWeaponAmmoStock(weapon, newStock);
			
			altWeapon = "alt_" + weapon;
			currentAltStock = self getWeaponAmmoStock(altWeapon);
			altAmmoToAdd = ammoData["alt_clip"] + ammoData["alt_stock"];
			maxAltStock = weaponMaxAmmo(altWeapon);
			newAltStock = int(min(currentAltStock + altAmmoToAdd, maxAltStock));
			self setWeaponAmmoStock(altWeapon, newAltStock);
			break;

		case "akimbo":
			currentStock = self getWeaponAmmoStock(weapon);
			ammoToAdd = ammoData["left_clip"] + ammoData["right_clip"] + ammoData["stock"];
			maxStock = weaponMaxAmmo(weapon);
			newStock = int(min(currentStock + ammoToAdd, maxStock));
			self setWeaponAmmoStock(weapon, newStock);
			break;

		case "standard":
		default:
			currentStock = self getWeaponAmmoStock(weapon);
			ammoToAdd = ammoData["clip"] + ammoData["stock"];
			maxStock = weaponMaxAmmo(weapon);
			newStock = int(min(currentStock + ammoToAdd, maxStock));
			self setWeaponAmmoStock(weapon, newStock);
			break;
	}
}

/*
///DocStringBegin
detail: players_play_sound(sound: <String>, team?: <String>, excludeTargets?: <Player[]>): <Void>
summary: Play local sounds on players. You can optionally specify the equipment or exclude players based on array.
///DocStringEnd
*/
players_play_sound(sound, team, excludeTargets)
{	
	if (isDefined(team)) targets = players_get_list(team);
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

player_take_all_weapons()
{
	foreach(weapon in self getWeaponsListPrimaries())
		self takeWeapon(weapon);
}

player_take_all_weapon_buffs()
{
	foreach(buff in self player_get_weapons_buffs())
		self player_unset_Perk(buff);
}

player_is_usability_enabled()
{
    return !self.disabledusability;
}

player_disable_usability()
{
    self.disabledusability = true;
    self disableusability();
}

player_enable_usability()
{
    self.disabledusability = false;
	self enableusability();
}

player_is_weapon_enabled()
{
    return !self.disabledweapon;
}

player_disable_weapons()
{
    self.disabledweapon = true;
    self disableweapons();
}

player_enable_weapons()
{
    self.disabledweapon = false;
	self enableweapons();
}

player_is_weapon_switch_enabled()
{
    return !self.disabledweaponswitch;
}

player_disable_weapon_switch()
{
    self.disabledweaponswitch = true;
    self disableweaponswitch();
}

player_enable_weapon_switch()
{
    self.disabledweaponswitch = false;
	self enableweaponswitch();
}

player_is_offhand_weapon_enabled()
{
    return !self.disabledoffhandweapons;
}

player_disable_offhand_weapons()
{
    self.disabledoffhandweapons = true;
    self disableoffhandweapons();
}

player_enable_offhand_weapons()
{
    self.disabledoffhandweapons = false;
	self enableoffhandweapons();
}

player_is_weapon_pickup_enabled()
{
    return !self.disabledWeaponPickup;
}

player_disable_weapon_pickup()
{
    self.disabledWeaponPickup = true;
    self disableWeaponPickup();
}

player_enable_weapon_pickup()
{
    self.disabledWeaponPickup = false;
	self enableWeaponPickup();
}

player_give_laststand_weapon(weapon)
{
	self thread _player_enable_laststand_weapon();

	self.lastStandWeapon = weapon;
	self.removeLastStandWeapon = !self hasWeapon(weapon);
	if (self.removeLastStandWeapon) self player_give_weapon(weapon);
	else self player_save_ammo(weapon, "onlaststand");

	self player_give_max_ammo(weapon);
	self switchtoweapon(weapon);

	self player_disable_usability();
	self player_disable_weapon_switch();
	self player_disable_offhand_weapons();
	self player_disable_weapon_pickup();
}

_player_enable_laststand_weapon()
{
	self endon("death");
    self endon("disconnect");
	self endon("revive");
    level endon("game_ended");

	self maps\mp\_utility::freezeControlsWrapper(true);
    wait 0.3;
    self maps\mp\_utility::freezeControlsWrapper(false);
}

player_set_action_slot(slotID, type, item)
{
	self.saved_actionslotdata[slotID].type = type;
    self.saved_actionslotdata[slotID].item = item;
    self setActionSlot(slotID, type, item);
}

player_black_screen(time)
{
	if (!isDefined(time)) time = 0.5;
	self visionSetNakedForPlayer("blacktest", 0);
	wait time;
	self visionSetNakedForPlayer("", 2);
}

player_can_see(targetOrigin)
{
	eyePos = self getEye();
	toTargetDir = vectorNormalize(targetOrigin - eyePos);
	forward = anglesToForward(self.angles);
	return vectorDot(toTargetDir, forward) > 0.18;
}

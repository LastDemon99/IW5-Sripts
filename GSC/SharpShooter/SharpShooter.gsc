#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	loadDvar();
	
	customMode = checkMode(getDvar("lb_customMode"));	
	if(!customMode["enable"])
	{
		setDvar("ui_gametype", getDvar("g_gametype"));	
		setDvar("jump_slowdownEnable", getDvarInt("lb_defaultJumpSlowValue"));
		setDvar("jump_disableFallDamage", getDvarInt("lb_defaultFallDamageValue"));
		return;
	}
	else if (customMode["mode"] != "SharpShooter") return;
	
	replacefunc(maps\mp\_utility::allowTeamChoice, ::teamChoice);
	replacefunc(maps\mp\_utility::allowClassChoice, ::classChoice);
	
	setDvar("ui_gametype", "SharpShooter");			
	loadWeaponData();
	
	level thread modeInit();
	level thread onPlayerConnect();
	level thread credits();
	
	if(getDvar("g_gametype") != "infect") 
	{
		setDvar("jump_slowdownEnable", 0);
		setDvar("jump_disableFallDamage", 1);	
	}
	
	level waittill("game_ended");
	setDvar("jump_slowdownEnable", getDvarInt("lb_defaultJumpSlowValue"));
	setDvar("jump_disableFallDamage", getDvarInt("lb_defaultFallDamageValue"));
}

loadDvar()
{
	SetDvarIfUninitialized("ss_switch_time", 30);
	SetDvarIfUninitialized("ss_type", 0);
	SetDvarIfUninitialized("ss_equipment_enable", 0);
	SetDvarIfUninitialized("ss_credits", "Gamemode Developed by LastDemon99");
	
	SetDvarIfUninitialized("lb_customMode", "");
	SetDvarIfUninitialized("lb_defaultJumpSlowValue", getDvarInt("jump_slowdownEnable"));
	SetDvarIfUninitialized("lb_defaultFallDamageValue", getDvarInt("jump_disableFallDamage"));
}

modeInit()
{
	setWeapons();
	level.ssHud = createHudText("Next Weapons: ", "small", 1.6, "TOP LEFT", "TOP LEFT", 115, 5);
	level.ssTimer = createHudText("0:" + getDvarInt("ss_switch_time"), "small", 1.6, "TOP LEFT", "TOP LEFT", 115, 22);
	
	level waittill("prematch_over");
	onInfectedInit();
	level.ssTimer destroy();
	for(;;)
	{
		level.ssTimer = createTimer(getDvarInt("ss_switch_time"), "small", 1.6, "TOP LEFT", "TOP LEFT", 115, 22);	
		
		wait(getDvarInt("ss_switch_time"));
		level.ssTimer Destroy();
		setWeapons();
		
		foreach(team in ["axis", "allies"])
			playSoundOnPlayers("scavenger_pack_pickup", team);
		
		foreach(player in level.players)
		{
			if(getDvar("g_gametype") == "infect" && player.sessionteam == "axis") continue;
			player ss_giveWeapon(level.currentWeapon);
		}
	}
}

onPlayerConnect()
{
  for (;;)
  {
    level waittill("connected", player);	
	
	player thread stingerFire(); 
	player thread infiniteStock();
	player thread onPlayerSpawn();
  }
}

onPlayerSpawn()
{
	self endon("disconnect");
	
	self.welcomeHud = false;
	for(;;)
	{
		self waittill("spawned_player");
		
		if(!self.welcomeHud) self thread welcomeGameMode();
		if(getDvar("g_gametype") == "infect" && self.sessionteam == "axis") break;
		
		self giveAllPerks();		
		self openMenu("perk_hide");		
		self disableWeaponPickup();
		
		self ss_giveWeapon(level.currentWeapon);
	}
}

ss_giveWeapon(weapon)
{
	self takeAllWeapons();	
		
	_giveWeapon(level.ss_primary);		
	if(getDvarInt("ss_type") == 1) _giveWeapon(level.ss_secondary); 
	self switchToWeapon(level.ss_primary);
	self setSpawnWeapon(level.ss_primary);		
	self.pers["primaryWeapon"] = level.ss_primary;	
	self.primaryWeapon = level.ss_primary;	
	
	if(getDvarInt("ss_equipment_enable"))
	{
		equipment = [level.ss_lethal, level.ss_tactical];
		
		self setOffhandPrimaryClass(level.ss_lethalClass);
		self setOffhandSecondaryClass(level.ss_tacticalClass);
		
		foreach(i in equipment)
		{
			if(i == "scrambler_mp")
				self thread maps\mp\gametypes\_scrambler::setScrambler();
			else if (i == "portable_radar_mp")
				self thread maps\mp\gametypes\_portable_radar::setPortableRadar();
			else if (i == "flare_mp")
				self maps\mp\perks\_perkfunctions::setTacticalInsertion();
			
			self _giveWeapon(i);
			self giveStartAmmo(i);
		}
	}
}

teamChoice()
{
	gametype = getDvar("g_gametype");	
	
	if (gametype == "dm" || gametype == "oitc") return false;
	else
	{
		allowed = int( tableLookup( "mp/gametypesTable.csv", 0, level.gameType, 4 ) );
		assert( isDefined( allowed ) );
	
		return allowed;
	}
}

classChoice()
{
	return false;	
}

infiniteStock()
{
	for(;;)
	{
		if(getDvar("g_gametype") == "infect" && self.sessionteam == "axis") break;
		
		self setWeaponAmmoStock(self getCurrentWeapon(), 300);		
		wait(0.5);
	}
}

stingerFire()
{
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
		wait(0.3);
	}
}

giveAllPerks()
{
	self givePerk("specialty_longersprint", false);
	self givePerk("specialty_fastreload", false);
	self givePerk("specialty_blindeye", false);
	self givePerk("specialty_paint", false);
	self givePerk("specialty_hardline", false);
	self givePerk("specialty_coldblooded", false);
	self givePerk("specialty_quickdraw", false);
	self givePerk("specialty_twoprimaries", false);
	self givePerk("specialty_assists", false);
	self givePerk("_specialty_blastshield", false);
	self givePerk("specialty_detectexplosive", false);
	self givePerk("specialty_autospot", false);
	self givePerk("specialty_bulletaccuracy", false);
	self givePerk("specialty_quieter", false);
	self givePerk("specialty_stalker", false);
}

setWeapons()
{
	if(getDvarInt("ss_type") == 0)
	{
		wep = getRandomWeapon();	
		level.ss_primary = wep.weaponWithAttachs; 
	}
	else
	{
		primaryWep = getRandomWeapon("primary");
		level.ss_primary = primaryWep.weaponWithAttachs; 		
		
		secondaryWep = getRandomWeapon("secondary");	
		level.ss_secondary = secondaryWep.weaponWithAttachs; 
	}
	
	if(getDvarInt("ss_equipment_enable"))
	{
		level.ss_lethal = level.ss_equipmentLetal[randomIntRange(0, level.ss_equipmentLetal.size)];
		level.ss_tactical = level.ss_equipmentTactical[randomIntRange(0, level.ss_equipmentTactical.size)];

		level.ss_lethalClass = getEquipmentClass(level.ss_lethal);
		level.ss_tacticalClass = getEquipmentClass(level.ss_tactical);		
	}
}

getRandomWeapon(weaponClass)
{
	if(!isDefined(weaponClass))
	{
		allWeapons = [];
		
		foreach(weapon in level.ss_primaryWeapons)
			allWeapons[allWeapons.size] = weapon;
		
		foreach(weapon in level.ss_secondaryWeapons)
			allWeapons[allWeapons.size] = weapon;
		
		self.weapon = allWeapons[randomIntRange(0, allWeapons.size)];
	}	
	else if(weaponClass == "primary") self.weapon = level.ss_primaryWeapons[randomIntRange(0, level.ss_primaryWeapons.size)];
	else if (weaponClass == "secondary") self.weapon = level.ss_secondaryWeapons[randomIntRange(0, level.ss_secondaryWeapons.size)];
	
	self.attachs = ["", "", ""];
	
	self.weaponWithAttachs = self.weapon;
	
	if(contains(self.weapon, level.ss_snipers)) self.attachs[0] = StrTok(self.weapon, "_")[1] + "scopevz";
	
	if (randomIntRange(0, 2) == 1) self setRandomSight();
	if (randomIntRange(0, 2) == 1) self setRandomExtraAttach();
	if (randomIntRange(0, 2) == 1) self setSilencer();
	
	self updateWeaponWithAttachs();
	return self;
}

setRandomSight()
{
	sightsAllowed = [];	
	
	foreach (sight in level.ss_sights)
		if (contains(self.weapon, level.ss_allowedAttach[sight]))
			sightsAllowed[sightsAllowed.size] = sight;

	if (sightsAllowed.size != 0) self.attachs[0] = sightsAllowed[randomIntRange(0, sightsAllowed.size)];
}

setRandomExtraAttach()
{
	attachAllowed = [];	
	
	foreach (attach in level.ss_extraAttach)
		if (contains(self.weapon, level.ss_allowedAttach[attach]))
			attachAllowed[attachAllowed.size] = attach;
		
	foreach (attach in level.ss_extraAttach2)
		if (contains(self.weapon, level.ss_allowedAttach[attach]))
			attachAllowed[attachAllowed.size] = attach;

	if (attachAllowed.size != 0) 
	{
		for(;;)
		{
			self.attachs[1] = attachAllowed[randomIntRange(0, attachAllowed.size)];
			if(self.attachs[0] != "hybrid") break;
			if(self.attachs[0] == "hybrid" && !contains(self.attachs[1], level.ss_extraAttach2)) break;
		}
	}
}

setSilencer()
{
	foreach(silencer in level.ss_silencer)
		if (contains(self.weapon, level.ss_allowedAttach[silencer]))
		{
			self.attachs[2] = silencer;
			break;
		}
}

setRandomCamo()
{
	if(!contains(self.weapon, level.ss_noCamoWeapons))
	{
		camoNum = randomIntRange(1, 13);
		if (camoNum < 10) self.weaponWithAttachs += "_" + "camo0" + camoNum;
		else self.weaponWithAttachs += "_" + "camo" + camoNum;
	}
}

updateWeaponWithAttachs()
{
	self.attachs = alphabetize(self.attachs);
	foreach(attach in self.attachs)
	{
		if(attach == "") continue;
		self.weaponWithAttachs += "_" + attach;	
	}
	self setRandomCamo();
}

loadWeaponData()
{
	level.ss_primary = undefined;
	level.ss_secondary = undefined;
	level.ss_lethal = undefined;
	level.ss_tactical = undefined;	
	
	level.ss_attachs = ["reflex", "silencer", "m320", "acog", "heartbeat", "eotech", "shotgun", "hybrid", "xmags", "thermal", "rof", "gl", "gp25", "reflexsmg", "acogsmg", "eotechsmg", "hamrhybrid", "thermalsmg", "grip", "silencer03", "reflexlmg", "eotechlmg", "barrettscopevz", "msrscopevz", "rsassscopevz", "dragunovscopevz", "as50scopevz", "l96a1scopevz", "cheytacscopevz", "silencer02", "akimbo", "tactical"];
	
	level.ss_noCamoWeapons = ["iw5_44magnum_mp", "iw5_usp45_mp", "iw5_deserteagle_mp", "iw5_mp412_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp", "iw5_g18_mp", "iw5_fmg9_mp", "iw5_mp9_mp", "iw5_skorpion_mp", "m320_mp", "rpg_mp", "iw5_smaw_mp", "stinger_mp", "xm25_mp", "javelin_mp", "iw5_m60jugg_mp", "iw5_riotshieldjugg_mp", "riotshield_mp"];
	
	level.ss_silencer = ["silencer", "silencer03", "silencer02"];
	
	level.ss_sights = ["reflex", "reflexsmg", "acog", "eotech", "reflexlmg", "reflexsmg", "eotechsmg", "eotechlmg", "acogsmg", "thermalsmg", "hamrhybrid", "barrettscopevz", "as50scopevz", "l96a1scopevz", "cheytacscopevz", "msrscopevz", "dragunovscopevz", "rsassscopevz", "thermal", "hybrid"];
		
	level.ss_extraAttach = ["heartbeat", "xmags", "rof", "grip", "akimbo", "tactical"];
	
	level.ss_extraAttach2 = ["gl", "gp25", "m320", "shotgun"];
	
	level.ss_snipers = ["iw5_barrett_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_msr_mp", "iw5_l96a1_mp", "iw5_as50_mp", "iw5_cheytac_mp"];
	
	level.ss_allowedAttach = [];
	level.ss_allowedAttach["reflex"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp"];
	level.ss_allowedAttach["silencer"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_mp5_mp", "iw5_ak74u_mp","iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"];
	level.ss_allowedAttach["m320"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp"];
	level.ss_allowedAttach["acog"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp", "iw5_cheytac_mp"];
	level.ss_allowedAttach["heartbeat"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_mk46_mp", "iw5_sa80_mp", "iw5_mg36_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp", "iw5_cheytac_mp"];
	level.ss_allowedAttach["eotech"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp"];
	level.ss_allowedAttach["shotgun"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp"];
	level.ss_allowedAttach["hybrid"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp"];
	level.ss_allowedAttach["xmags"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_mp5_mp", "iw5_ak74u_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp", "iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp", "iw5_cheytac_mp", "iw5_usp45_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp", "iw5_fmg9_mp", "iw5_g18_mp", "iw5_mp9_mp", "iw5_skorpion_mp"];
	level.ss_allowedAttach["thermal"] = ["iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp", "iw5_cheytac_mp"];
	level.ss_allowedAttach["rof"] = ["iw5_type95_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_mp5_mp", "iw5_ak74u_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"];
	level.ss_allowedAttach["gl"] = ["iw5_m4_mp", "iw5_m16_mp"];
	level.ss_allowedAttach["gp25"] = ["iw5_ak47_mp"];
	level.ss_allowedAttach["reflexsmg"] = ["iw5_mp5_mp", "iw5_ak74u_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp", "iw5_fmg9_mp", "iw5_g18_mp", "iw5_mp9_mp", "iw5_skorpion_mp"];
	level.ss_allowedAttach["acogsmg"] = ["iw5_mp5_mp", "iw5_ak74u_mp","iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp"];
	level.ss_allowedAttach["eotechsmg"] = ["iw5_mp5_mp", "iw5_ak74u_mp","iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp"];
	level.ss_allowedAttach["hamrhybrid"] = ["iw5_mp5_mp", "iw5_ak74u_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp"];
	level.ss_allowedAttach["thermalsmg"] = ["iw5_mp5_mp", "iw5_ak74u_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp"];
	level.ss_allowedAttach["grip"] = ["iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"];
	level.ss_allowedAttach["silencer03"] = ["iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp", "iw5_cheytac_mp"];
	level.ss_allowedAttach["reflexlmg"] = ["iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"];
	level.ss_allowedAttach["eotechlmg"] = ["iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"];
	level.ss_allowedAttach["barrettscopevz"] = ["iw5_barrett_mp"];
	level.ss_allowedAttach["msrscopevz"] = ["iw5_msr_mp"];
	level.ss_allowedAttach["rsassscopevz"] = ["iw5_rsass_mp"];
	level.ss_allowedAttach["dragunovscopevz"] = ["iw5_dragunov_mp"];
	level.ss_allowedAttach["as50scopevz"] = ["iw5_as50_mp"];
	level.ss_allowedAttach["l96a1scopevz"] = ["iw5_l96a1_mp"];
	level.ss_allowedAttach["cheytacscopevz"] = ["iw5_cheytac_mp"];
	level.ss_allowedAttach["silencer02"] = ["iw5_usp45_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp", "iw5_fmg9_mp", "iw5_g18_mp", "iw5_mp9_mp", "iw5_skorpion_mp"];
	level.ss_allowedAttach["akimbo"] = ["iw5_usp45_mp", "iw5_mp412_mp", "iw5_44magnum_mp", "iw5_deserteagle_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp", "iw5_fmg9_mp", "iw5_g18_mp", "iw5_mp9_mp", "iw5_skorpion_mp"];
	level.ss_allowedAttach["tactical"] = ["iw5_usp45_mp", "iw5_mp412_mp", "iw5_44magnum_mp", "iw5_deserteagle_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp"];
	
	level.ss_primaryWeapons = ["iw5_m4_mp",
							   "iw5_ak47_mp",
							   "iw5_m16_mp",
							   "iw5_fad_mp",
							   "iw5_acr_mp",
							   "iw5_type95_mp",
							   "iw5_mk14_mp",
							   "iw5_scar_mp",
							   "iw5_g36c_mp",
							   "iw5_cm901_mp",
							   "iw5_mp7_mp",
							   "iw5_m9_mp",
							   "iw5_p90_mp",
							   "iw5_pp90m1_mp",
							   "iw5_ump45_mp",
							   "iw5_ak74u_mp",
							   "iw5_barrett_mp",
							   "iw5_rsass_mp",
							   "iw5_dragunov_mp",
							   "iw5_msr_mp",
							   "iw5_l96a1_mp",
							   "iw5_as50_mp",
							   "iw5_cheytac_mp",
							   "iw5_ksg_mp",
							   "iw5_1887_mp",
							   "iw5_striker_mp",
							   "iw5_aa12_mp",
							   "iw5_usas12_mp",
							   "iw5_spas12_mp",
							   "iw5_m60_mp",
							   "iw5_mk46_mp",
							   "iw5_pecheneg_mp",
							   "iw5_sa80_mp",
							   "iw5_mg36_mp",
							   "m320_mp",
							   "rpg_mp",
							   "iw5_smaw_mp",
							   "stinger_mp",
							   "xm25_mp",
							   "javelin_mp",
							   "riotshield_mp"];
							   
    level.ss_secondaryWeapons = ["iw5_44magnum_mp",
								   "iw5_usp45_mp",
								   "iw5_deserteagle_mp",
								   "iw5_mp412_mp",
								   "iw5_p99_mp",
								   "iw5_fnfiveseven_mp",
								   "iw5_g18_mp",
								   "iw5_fmg9_mp",
								   "iw5_mp9_mp",
								   "iw5_skorpion_mp"];
								   
    level.ss_equipmentLetal = ["frag_grenade_mp",
							   "semtex_mp",
							   "throwingknife_mp",
							   "claymore_mp",
							   "c4_mp",
							   "bouncingbetty_mp"];
								   
    level.ss_equipmentTactical = ["flash_grenade_mp",
								   "concussion_grenade_mp",
								   "smoke_grenade_mp",
								   "emp_grenade_mp",
								   "trophy_mp",
								   "flare_mp",
								   "scrambler_mp",
								   "portable_radar_mp"];
								   
    level.ss_offHandClass = [];	
	level.ss_offHandClass[0] = ["frag", "frag_grenade_mp"];
	level.ss_offHandClass[1] = ["flash", "flash_grenade_mp", "scrambler_mp", "emp_grenade_mp", "trophy_mp", "flare_mp", "portable_radar_mp"];
	level.ss_offHandClass[2] = ["other", "semtex_mp", "bouncingbetty_mp", "claymore_mp", "c4_mp"];
	level.ss_offHandClass[3] = ["smoke", "concussion_grenade_mp", "smoke_grenade_mp"];
	level.ss_offHandClass[4] = ["throwingknife", "throwingknife_mp"];
}

getEquipmentClass(equipment)
{
	equipment_class = "";
	for(i = 0; i < level.ss_offHandClass.size; i++)
	{
		if(equipment_class != "") break;		
		foreach(item in level.ss_offHandClass[i])
			if(equipment == item)
			{
				equipment_class = level.ss_offHandClass[i][0];
				break;
			}
	}
	return equipment_class;
}

onInfectedInit()
{
	if(getDvar("g_gametype") == "infect")
	{
		level.ssHud setPoint("TOP LEFT", "TOP LEFT", 115, 20);
		level.ssTimer SetPoint("TOP LEFT", "TOP LEFT", 115, 37);
		
		wait(8);
		level.ssHud setPoint("TOP LEFT", "TOP LEFT", 115, 5);
		level.ssTimer SetPoint("TOP LEFT", "TOP LEFT", 115, 22);
	}
}

welcomeGameMode()
{
	gameMode = createHudText("SharpShooter", "hudbig", 1, "TOPCENTER", "TOPCENTER",  0, 165);
	gameMode.glowColor = (0, 0, 1);
	gameMode.glowAlpha = 1;
	gameMode setPulseFX(150, 4700, 700);
	
	self.welcomeHud = true;
	wait(5);
	gameMode destroy();
}

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

contains(item, data)
{
	_contains = false;
	foreach(i in data)
		if(item == i)
		{
			_contains = true;
			break;
		}
	return _contains;
}

checkMode(mode)
{
	data = [];
	customModes = [ "OldSchool", "SharpShooter", "Cranked", "Switch", "RandomSniper", "RandomShotgun", "RandomPistol", "HugeGunGame"];
	data["enable"] = false;
	
	for(i = 0; i < customModes.size; i++)
		if(mode == customModes[i])
		{
			data["enable"] = true;
			data["mode"] = mode;
			break;
		}
			
	return data;
}

credits()
{
	for(;;) 
    {
		if(getDvar("ss_credits") != "Gamemode Developed by LastDemon99")
			setDvar("ss_credits", "Gamemode Developed by LastDemon99");		
		wait(0.35);
	}
}

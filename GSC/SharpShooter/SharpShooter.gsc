/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : SharpShooter     |
|Creator : LastDemon99	   |
|Type : Game Mode          |
============================
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\lethalbeats\_utility;

#define ALLOW_SECONDARIES_IN_GAME_ERR "[SharpShooter]\n[ERROR_EXEPTION]: Has allow secondary by dvar, are not defined, restart the map to update script"

init()
{
	gameSetup();
	level thread onPlayerConnect();
	level thread switchWeaponInit();
	level thread hudHideOnGameEnd();
	replacefunc(maps\mp\gametypes\_weapons::dropScavengerForDeath, ::blank);
}

gameSetup()
{
	add_custom_weapon("iw5_cheytac", "Intervention", "weapon_sniper", ["acog", "silencer03", "thermal", "xmags", "heartbeat", "vzscope"]);
	add_custom_weapon("iw5_ak74u", "AK74-u", "weapon_smg", ["reflex", "silencer", "rof", "acog", "eotech", "xmags", "thermal"]);
	
	setDvarIfUninitialized("ss_switch_time", 30);
	setDvarIfUninitialized("ss_allow_secondary", 0);
	setDvarIfUninitialized("ss_allow_attachs", 0);
	setDvarIfUninitialized("ss_allow_equipment", 0);
	setDvarIfUninitialized("ss_allow_knife", 1);
	
	preCacheShader("iw5_cardicon_skullguns");
			
	game["strings"]["axis_name"] = "SharpShooter";
	game["strings"]["allies_name"] = "SharpShooter";	
	game["icons"]["axis"] = "iw5_cardicon_skullguns";
	game["icons"]["allies"] = "iw5_cardicon_skullguns";
	
	level.killstreakRewards = 0;
	level.allow_secondaries = getDvarInt("ss_allow_secondary");
	
	if (level.allow_secondaries)
	{
		level.ss_primaries = getPrimaries();
		level.ss_secondaries = getSecondaries();
	}
	else level.ss_primaries = getWeapons();
	
	if (!level.teambased) teamBypass();
	classBypass();
	meleePenalty();
}

onPlayerConnect()
{
	for (;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawn();
		player thread stingerFire();
		player thread refillAmmo();
		player thread refillSingleCountAmmo();
		player thread meleePopUpInit();
	}
}

onPlayerSpawn()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self openMenu("perk_hide");
		self giveSSWeapon(false);		
		self giveModeAllPerks(true);
		self disableWeaponPickup();
	}
}

giveSSWeapon(switch_to_weapon)
{
	if (level.allow_secondaries && !isDefined(level.ss_secondaries)) print(ALLOW_SECONDARIES_IN_GAME_ERR);
	assertEx(level.allow_secondaries && !isDefined(level.ss_secondaries), ALLOW_SECONDARIES_IN_GAME_ERR);
	
	if (!isReallyAlive(self)) return;
	if (!isDefined(switch_to_weapon)) switch_to_weapon = true;
	
	self giveSpawnWeapon(level.ss_primary, switch_to_weapon);
	self giveMaxAmmo(self getCurrentWeapon()); // error=level.ss_primary no_error=getCurrentWeapon ...wtf black magic shit is this???
	
	if (level.allow_secondaries)
	{
		self __giveWeapon(level.ss_secondary);
		secondary_class = getWeaponClass(level.ss_secondary);
		self giveMaxAmmo(self getCurrentWeapon());
	}
	
	if(getDvarInt("ss_allow_equipment"))
	{
		self giveNade(level.ss_lethal, true);
		self giveNade(level.ss_tactical, false);
	}
}

switchWeaponInit()
{
	setWeapons();
	
	level.ss_hud = createHudText("Next Weapons: ", "small", 1.6, "TOP LEFT", "TOP LEFT", 115, 5);
	level.ss_timer = createHudText("0:" + getDvarInt("ss_switch_time"), "small", 1.6, "TOP LEFT", "TOP LEFT", 115, 22);
	
	if (!gameHasStarted()) level waittill("prematch_over");
	level.ss_timer destroy();
	
	for(;;)
	{
		level.ss_timer = createTimer(getDvarInt("ss_switch_time"), "small", 1.6, "TOP LEFT", "TOP LEFT", 115, 22);	
		
		wait(getDvarInt("ss_switch_time"));
		
		level.ss_timer Destroy();
		setWeapons();
	}
}

setWeapons()
{
	if (getDvarInt("ss_allow_secondary") && !isDefined(level.ss_secondaries)) print(ALLOW_SECONDARIES_IN_GAME_ERR);
	assertEx(getDvarInt("ss_allow_secondary") && !isDefined(level.ss_secondaries), ALLOW_SECONDARIES_IN_GAME_ERR);
	
	baseName = random(level.ss_primaries);
	level.ss_primary = build_weapon(baseName);	
	if (level.allow_secondaries) level.ss_secondary = build_weapon(random(level.ss_secondaries));
	
	if(getDvarInt("ss_allow_equipment"))
	{
		level.ss_lethal = random(getNades("lethal"));
		level.ss_tactical = random(getNades("tactical"));
	}
	
	playSoundOnPlayers("scavenger_pack_pickup");
	foreach(player in level.players)
	{
		player giveSSWeapon();
		player maps\mp\gametypes\_rank::xpEventPopup(getWeaponName(baseName));
	}
}

build_weapon(baseName)
{
	if (!getDvarInt("ss_allow_attachs"))
		return getWeaponClass(baseName) == "weapon_sniper" ? buildWeaponAttachs(baseName, ["vzscope"], true) : baseName;
	
	wep_class = getWeaponClass(baseName);
	if (wep_class == "weapon_projectile" || wep_class == "weapon_riot") return baseName;
	
	attach_count = baseName == "iw5_cheytac" ? 2 : 3;
	
	attachs = getRandomAttachs(baseName, attach_count, true, true);
	weapon = buildWeaponAttachs(baseName, attachs);
	
	return weapon;
}

hudHideOnGameEnd()
{
	level waittill("game_ended");	
    level.ssHud.alpha = 0;
    level.ssTimer.alpha = 0;
}
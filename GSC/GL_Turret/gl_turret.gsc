/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : gl_turret        |
|Creator : LastDemon99	   |
|Type : Addon              |
============================
*/

#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_autosentry;

init()
{	
	replacefunc(maps\mp\killstreaks\_autosentry::tryUseAutoSentry, ::_tryUseAutoSentry);
	replacefunc(maps\mp\killstreaks\_autosentry::sentry_initSentry, ::sentryInitSentry);
	replacefunc(maps\mp\killstreaks\_autosentry::sentry_burstFireStart, ::sentryBurstFireStart);
	replacefunc(maps\mp\killstreaks\_autosentry::sentry_setplaced, ::sentrySetPlaced);
	replacefunc(maps\mp\killstreaks\_airdrop::waitForDropCrateMsg, ::waitForDropCrateMsg);
	
	level.sentrySettings["gl_turret"] = spawnStruct();
	level.sentrySettings["gl_turret"].health = 999999;
	level.sentrySettings["gl_turret"].maxHealth = 1000;
	level.sentrySettings["gl_turret"].burstMin = 20;
	level.sentrySettings["gl_turret"].burstMax = 120;
	level.sentrySettings["gl_turret"].pauseMin = 0.15;
	level.sentrySettings["gl_turret"].pauseMax = 0.35;	
	level.sentrySettings["gl_turret"].sentryModeOn = "sentry";	
	level.sentrySettings["gl_turret"].sentryModeOff = "sentry_offline";	
	level.sentrySettings["gl_turret"].timeOut = 240;
	level.sentrySettings["gl_turret"].spinupTime = 0.05;
	level.sentrySettings["gl_turret"].overheatTime = 4.0;	
	level.sentrySettings["gl_turret"].cooldownTime = 0.5;	
	level.sentrySettings["gl_turret"].fxTime = 0.3;
	level.sentrySettings["gl_turret"].streakName = "sentry";
	level.sentrySettings["gl_turret"].weaponInfo = "manned_gl_turret_mp";
	level.sentrySettings["gl_turret"].modelBase = "sentry_grenade_launcher";
	level.sentrySettings["gl_turret"].modelPlacement = "sentry_grenade_launcher_obj";
	level.sentrySettings["gl_turret"].modelPlacementFailed =	"sentry_grenade_launcher_obj_red";
	level.sentrySettings["gl_turret"].modelDestroyed = "sentry_grenade_launcher_destroyed"; 
	level.sentrySettings["gl_turret"].hintString = &"SENTRY_PICKUP";
	level.sentrySettings["gl_turret"].headIcon = true;	
	level.sentrySettings["gl_turret"].teamSplash = "used_sentry";	
	level.sentrySettings["gl_turret"].shouldSplash = false;	
	level.sentrySettings["gl_turret"].voDestroyed = "sentry_destroyed";
	level.sentrySettings["gl_turret"].ownerHintString = "";
}

sentryInitSentry(sentryType, owner)
{
	self.sentryType = sentryType;
	self.canBePlaced = true;
	self setModel(level.sentrySettings[self.sentryType].modelBase);
	self.shouldSplash = true;	
	self setCanDamage(true);
		
	switch(sentryType)
	{
		case "minigun_turret":
		case "gl_turret":
			self SetLeftArc(80);
			self SetRightArc(80);
			self SetBottomArc(50);
			self SetDefaultDropPitch(0.0);
			self.originalOwner = owner;
			break;
		case "sam_turret":
			self SetLeftArc(180);
			self SetRightArc(180);
			self SetTopArc(80);
			self SetDefaultDropPitch(-89.0);
			self.laser_on = false;
			killCamEnt = Spawn("script_model", self GetTagOrigin("tag_laser"));
			killCamEnt LinkTo(self);
			self.killcament = killCamEnt;
			self.killcament setscriptmoverkillcam( "explosive" );
			break;
		default:
            self setdefaultdroppitch(-89.0);
            break;
	}	
	
	if (sentryType != "minigun_turret") self makeTurretInoperable();
	
	self setTurretModeChangeWait(true);
	self sentry_setInactive();	
	self sentry_setOwner(owner);
	self thread sentry_handleDamage();
	self thread sentry_handleDeath();
	self thread sentry_timeOut();
	
	switch(sentryType)
	{
		case "minigun_turret":
			self.momentum = 0;
			self.heatLevel = 0;
			self.overheated = false;		
			self thread sentry_heatMonitor();
			break;
		case "gl_turret":
            self.momentum = 0;
            self.heatlevel = 0;
            self.cooldownwaittime = 0;
            self.overheated = false;
            thread sentry_handleuse();
            thread sentry_attacktargets();
            thread sentry_beepsounds();
            break;
		case "sam_turret":
            thread sentry_handleuse();
            thread sentry_beepsounds();
            break;
        default:
            thread sentry_handleuse();
            thread sentry_attacktargets();
            thread sentry_beepsounds();
            break;
	}
}

sentryBurstFireStart()
{
	self endon("death");
	self endon("stop_shooting");
	level endon("game_ended");

	self sentry_spinUp();
	fireTime = weaponFireTime(level.sentrySettings[self.sentryType].weaponInfo);
	minShots = level.sentrySettings[self.sentryType].burstMin;
	maxShots = level.sentrySettings[self.sentryType].burstMax;
	minPause = level.sentrySettings[self.sentryType].pauseMin;
	maxPause = level.sentrySettings[self.sentryType].pauseMax;

	is_gl = self.sentryType == "gl_turret";

	for (;;)
	{		
		numShots = randomIntRange(minShots, maxShots + 1);		
		for (i = 0; i < numShots && !self.overheated; i++)
		{
			if (is_gl) playsoundatpos(self.origin, "weap_m203_fire_npc");
			
			self shootTurret();
			self.heatLevel += fireTime;
			wait (fireTime);
		}		
		wait (randomFloatRange(minPause, maxPause));
	}
}

waitForDropCrateMsg(dropCrate, dropImpulse, dropType, crateType)
{
	self waittill("drop_crate");
	
	dropCrate Unlink();
	dropCrate PhysicsLaunchServer((0,0,0), dropImpulse);		
	dropCrate thread maps\mp\killstreaks\_airdrop::physicsWaiter(dropType, crateType);
	
	if (dropCrate.crateType == "sentry" && randomint(2))
		dropCrate thread on_gl_turret_captured();

	if(IsDefined(dropCrate.killCamEnt))
	{
		dropCrate.killCamEnt Unlink();
		groundTrace = BulletTrace(dropCrate.origin, dropCrate.origin + (0, 0, -10000), false, dropCrate);
		travelDistance = Distance(dropCrate.origin, groundTrace[ "position" ]);
		travelTime = travelDistance / 800;
		dropCrate.killCamEnt MoveTo(groundTrace[ "position" ] + (0.0, 0.0, 300.0), travelTime);
	}
}

on_gl_turret_captured()
{
	self waittill("captured", player);
	player.has_gl_turret = true;
}

_tryUseAutoSentry(lifeId)
{
	if (isDefined(self.has_gl_turret))
	{
		killstreakWeapon = maps\mp\killstreaks\_killstreaks::getKillstreakWeapon(level.sentrySettings["sentry_minigun"].streakName);
		self TakeWeapon(killstreakWeapon);
		self.has_gl_turret = undefined;
		
		result = self giveSentry("gl_turret");
		if (result) self maps\mp\_matchdata::logKillstreakEvent("gl_turret", self.origin);
		return result;
	}
	
	result = self giveSentry("sentry_minigun");
	if (result)
	{
		self maps\mp\_matchdata::logKillstreakEvent(level.sentrySettings["sentry_minigun" ].streakName, self.origin);
		killstreakWeapon = maps\mp\killstreaks\_killstreaks::getKillstreakWeapon(level.sentrySettings["sentry_minigun"].streakName);
		self TakeWeapon(killstreakWeapon);
	}	
	return result;
}

sentrySetPlaced()
{
    self setmodel(level.sentrysettings[self.sentrytype].modelbase);

    if (self getmode() == "manual")
        self setmode(level.sentrysettings[self.sentrytype].sentrymodeoff);

    self setsentrycarrier(undefined);
    self setcandamage(1);

    switch (self.sentrytype)
    {
        case "minigun_turret":
            self.angles = self.carriedby.angles;

            if (isalive(self.originalowner))
                self.originalowner maps\mp\_utility::setlowermessage("pickup_hint", level.sentrysettings[self.sentrytype].ownerhintstring, 3.0, undefined, undefined, undefined, undefined, undefined, 1);

            self.ownertrigger = spawn("trigger_radius", self.origin + (0.0, 0.0, 1.0), 0, 105, 64);
            self.originalowner thread turret_handlepickup(self);
            thread turret_handleuse();
            break;
        default:
            break;
    }

    sentry_makesolid();
    self.carriedby forceusehintoff();
    self.carriedby = undefined;

    if (isdefined(self.owner))
        self.owner.iscarrying = 0;

    sentry_setactive();
    self playsound("sentry_gun_plant");
    self notify("placed");
}
/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : AlwaysUAV        |
|Creator : LastDemon99	   |
|Type : Addon              |
============================
*/

#include common_scripts\utility;
#include maps\mp\_utility;

main()
{
	replacefunc(maps\mp\killstreaks\_airdrop::addCrateType, ::addCrateType);
	replacefunc(maps\mp\perks\_perkfunctions::setPainted, ::blank);
	replacefunc(maps\mp\killstreaks\_remoteuav::remoteUAV_unmarkRemovedPlayer, ::blank);
	replacefunc(maps\mp\killstreaks\_uav::damageTracker, ::blank);
	replacefunc(maps\mp\killstreaks\_uav::updateUAVModelVisibility, ::updateUAVModelVisibility);
	replacefunc(maps\mp\killstreaks\_uav::_getRadarStrength, ::getRadarStrength);
	replacefunc(maps\mp\killstreaks\_uav::launchUAV, ::returnTrue);
}

init()
{
	setDvarIfUninitialized("always_uav", 0);
	setDvarIfUninitialized("sweep_uav", 1);
	
	if(!getDvarInt("always_uav")) return;
	
	if(getDvarInt("sweep_uav"))
	{
		if (level.teamBased)
		{
			uav_type = getDvarInt("always_uav") == 2 ? "directional_uav" : "double_uav";
			level thread launchUAV(undefined, "allies", 99999, uav_type);
			level thread launchUAV(undefined, "axis", 99999, uav_type);
		}
		else level.uav_type = getDvarInt("always_uav") == 2 ? "triple_uav" : "double_uav";
	}
	
	level thread onPlayerConnect();
}

onPlayerConnect()
{
	level endon("game_ended");
	for (;;)
	{
		level waittill("connected", player);
		player thread onPlayerSpawn();
	}
}

onPlayerSpawn()
{
	self endon("disconnect");
	self thread giveUavFFA();
	
	for(;;)
	{
		self waittill("spawned_player");
		if(!getDvarInt("sweep_uav")) self setPerk(getDvarInt("always_uav") == 1 ? "specialty_radarblip" : "specialty_radararrow", true, false);
		else if(getDvarInt("always_uav") == 2) self.radarShowEnemyDirection = true;
	}
}

giveUavFFA()
{
	if (level.teamBased) return;
	self waittill("spawned_player");
	level thread launchUAV(self, self.pers["team"], 99999, level.uav_type);
}

addCrateType(dropType, crateType, crateWeight, crateFunc)
{
	if (crateType == "uav" || crateType == "triple_uav") return;
	level.crateTypes[dropType][crateType] = crateWeight;
	level.crateFuncs[dropType][crateType] = crateFunc;
}

launchUAV(owner, team, duration, uavType)
{
    isCounter = uavType == "counter_uav" ? true : false;

    UAVModel = spawn("script_model", level.UAVRig getTagOrigin("tag_origin"));
    UAVModel.value = 1;

    if (uavType == "double_uav") UAVModel.value = 2;
	else if (uavType == "triple_uav") UAVModel.value = 3;

    if (UAVModel.value != 3)
	{
		UAVModel setModel("vehicle_uav_static_mp");
		UAVModel thread maps\mp\killstreaks\_uav::damageTracker(isCounter, false);
	}
	else
	{
		UAVModel setModel("vehicle_phantom_ray");		
		UAVModel thread maps\mp\killstreaks\_uav::spawnFxDelay(level.uav_fx[ "trail" ], "tag_jet_trail");
		UAVModel thread maps\mp\killstreaks\_uav::damageTracker(isCounter, true);
	}

    UAVModel.team = team;
	UAVModel.owner = owner;
	UAVModel.timeToAdd = 0;	
    UAVModel thread maps\mp\killstreaks\_uav::handleIncomingStinger();
    UAVModel maps\mp\killstreaks\_uav::addUAVModel();
	
    zOffset = randomIntRange(3000, 5000);

    if(IsDefined(level.spawnpoints)) spawns = level.spawnPoints;
	else spawns = level.startSpawnPoints;

    lowestSpawn = spawns[0];
	foreach(spawn in spawns)
		if (spawn.origin[2] < lowestSpawn.origin[2]) lowestSpawn = spawn; 

    lowestZ = lowestSpawn.origin[2];
	UAVRigZ = level.UAVRig.origin[2];

    if(lowestZ < 0)
	{
		UAVRigZ += lowestZ * -1;
		lowestZ = 0;
	}

    diffZ = UAVRigZ - lowestZ;

    if(diffZ + zOffset > 8100.0)
        zOffset -= ((diffZ + zOffset) - 8100.0);

    angle = randomInt(360);
	radiusOffset = randomInt(2000) + 5000;

	xOffset = cos(angle) * radiusOffset;
	yOffset = sin(angle) * radiusOffset;

	angleVector = vectorNormalize((xOffset,yOffset,zOffset));
	angleVector = (angleVector * RandomIntRange(6000, 7000));
	
	UAVModel LinkTo(level.UAVRig, "tag_origin", angleVector, (0,angle - 90,0));
	UAVModel thread updateUAVModelVisibility();	

    if (isCounter)
	{
		UAVModel.uavType = "counter";
		UAVModel maps\mp\killstreaks\_uav::addActiveCounterUAV();
	}	
	else 
	{
		UAVModel maps\mp\killstreaks\_uav::addActiveUAV();
		UAVModel.uavType = "standard";
	}

    if (isDefined(level.activeUAVs[team]))
		foreach (uav in level.UAVModels[team])
		{
			if (uav == UAVModel) continue;			
			if (uav.uavType == "counter" && isCounter) uav.timeToAdd += 5;
			else if (uav.uavType == "standard" && !isCounter) uav.timeToAdd += 5;
		}

    level notify("uav_update");

    switch (uavType)
	{
		case "uav_strike": duration = 2; break;
		default: duration = duration -7; break;			
	}

    UAVModel maps\mp\killstreaks\_uav::waittill_notify_or_timeout_hostmigration_pause("death", duration);

    if (UAVModel.damageTaken < UAVModel.maxHealth)
	{
		UAVModel unlink();
	
		destPoint = UAVModel.origin + (AnglesToForward(UAVModel.angles) * 20000);
		UAVModel moveTo(destPoint, 60);
		PlayFXOnTag(level._effect[ "ac130_engineeffect" ] , UAVModel, "tag_origin");

		UAVModel maps\mp\killstreaks\_uav::waittill_notify_or_timeout_hostmigration_pause("death", 3);

		if (UAVModel.damageTaken < UAVModel.maxHealth)
		{
			UAVModel notify("leaving");
			UAVModel.isLeaving = true;
			UAVModel moveTo(destPoint, 4, 4, 0.0);
		}
	
		UAVModel maps\mp\killstreaks\_uav::waittill_notify_or_timeout_hostmigration_pause("death", 4 + UAVModel.timeToAdd);
	}

	if (isCounter) UAVModel maps\mp\killstreaks\_uav::removeActiveCounterUAV();
	else UAVModel maps\mp\killstreaks\_uav::removeActiveUAV();

	UAVModel delete();
	UAVModel maps\mp\killstreaks\_uav::removeUAVModel();
	
	if(uavType == "directional_uav")
	{
		owner.radarShowEnemyDirection = false;
		if(level.teambased)
			foreach(player in level.players)
				if(player.pers["team"] == team) player.radarShowEnemyDirection = false;
	}
	
	level notify ("uav_update");
}

getRadarStrength(team) { return 3; }
updateUAVModelVisibility() { self hide(); }
blank(arg1, arg2) {}
returnTrue(arg1, arg2, arg3, arg4) { return true; }
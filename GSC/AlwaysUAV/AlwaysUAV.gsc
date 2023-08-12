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

init()
{
	setDvarIfUninitialized("always_uav", 0);
	setDvarIfUninitialized("sweep_uav", 1);
	
	if(getDvarInt("always_uav"))
	{
		replacefunc(maps\mp\perks\_perkfunctions::setPainted, ::blank);
		replacefunc(maps\mp\killstreaks\_remoteuav::remoteUAV_unmarkRemovedPlayer, ::blank);
		replacefunc(maps\mp\killstreaks\_uav::damageTracker, ::blank);
		replacefunc(maps\mp\killstreaks\_uav::updateUAVModelVisibility, ::updateUAVModelVisibility);
		replacefunc(maps\mp\killstreaks\_uav::_getRadarStrength, ::getRadarStrength);
		
		level.killStreakFuncs["uav"] = ::blank;
		level.killStreakFuncs["uav_support"] = ::blank;
		level.killStreakFuncs["uav_2"] = ::blank;
		level.killStreakFuncs["double_uav"] = ::blank;
		level.killStreakFuncs["triple_uav"] = ::blank;
		level.killStreakFuncs["counter_uav"] = ::blank;
		level.killstreakFuncs["uav_strike"] = ::blank;
		level.killstreakSetupFuncs["uav_strike"] = ::blank;
		level.killstreakFuncs["directional_uav"] = ::blank;
		
		if(getDvarInt("sweep_uav"))
		{
			if (getDvarInt("always_uav") == 1) uav_type = "triple_uav";
			else
			{
				uav_type = "directional_uav";
				level thread onPlayerConnect();
			}
			
			level thread maps\mp\killstreaks\_uav::launchUAV(undefined, "axis", 99999, uav_type);
			level thread maps\mp\killstreaks\_uav::launchUAV(undefined, "allies", 99999, uav_type);
			return;
		}		
		level thread onPlayerConnect();
	}
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
	for(;;)
	{
		self waittill("spawned_player");		
		if(getDvarInt("sweep_uav")) self.radarShowEnemyDirection = true;
		else self setPerk(getDvarInt("always_uav") == 1 ? "specialty_radarblip" : "specialty_radararrow", true, false);
	}
}

getRadarStrength(team) { return 3; }
updateUAVModelVisibility() { self hide(); }
blank(arg1, arg2) {}
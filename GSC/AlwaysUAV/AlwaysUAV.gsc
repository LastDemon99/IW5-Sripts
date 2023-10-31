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
			level thread maps\mp\killstreaks\_uav::launchUAV(undefined, "allies", 99999, uav_type);
			level thread maps\mp\killstreaks\_uav::launchUAV(undefined, "axis", 99999, uav_type);
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
	level thread maps\mp\killstreaks\_uav::launchUAV(self, self.pers["team"], 99999, level.uav_type);
}

addCrateType(dropType, crateType, crateWeight, crateFunc)
{
	if (crateType == "uav" || crateType == "triple_uav") return;
	level.crateTypes[dropType][crateType] = crateWeight;
	level.crateFuncs[dropType][crateType] = crateFunc;
}

getRadarStrength(team) { return 3; }
updateUAVModelVisibility() { self hide(); }
blank(arg1, arg2) {}
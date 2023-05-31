#include common_scripts\utility;
#include maps\mp\_utility;

main()
{
	replacefunc(maps\mp\perks\_perkfunctions::setPainted, ::setPainted);
}

init()
{
	SetDvarIfUninitialized("allow_advanced_uav", 1);	
	if(getDvarInt("allow_advanced_uav")) level thread onPlayerConnect();
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
		self setPerk("specialty_radararrow", true, false);
	}
}

setPainted() {}

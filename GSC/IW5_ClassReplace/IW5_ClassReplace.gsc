/*
============================
|   Lethal Beats Team 	   |
============================
|Game : IW5				   |
|Script : IW5_ClassReplace |
|Creator : LastDemon99	   |
|Type : Addon			   |
============================
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_class;

init()
{
	loadDvars();
	level thread onPlayerConnect();
}

loadDvars()
{	
	level.cr_dvars = [ "cr_weapons", "cr_attachs", "cr_buffs", "cr_equipment", "cr_perks", "cr_streaks"];

	foreach(dvar in level.cr_dvars)
		SetDvarIfUninitialized(dvar, "");
	
	SetDvarIfUninitialized("cr_credits", "Developed by LastDemon99");
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
		
		self.pers["gamemodeLoadout"] = self cloneLoadout();		
		self.pers["gamemodeLoadout"]["loadoutJuggernaut"] = false;		
		
		self ReplaceRestrictedItems();
		
		self maps\mp\gametypes\_class::giveLoadout(self.team, "gamemode", false, true);	
		maps\mp\killstreaks\_killstreaks::clearKillstreaks();
	}
}

ReplaceRestrictedItems()
{
	foreach(dvar in level.cr_dvars)
	{
		if(getDvar(dvar) == "") continue;		
		data = StrTok(getDvar(dvar), ":");		
		switch(dvar)
		{
			case "cr_weapons":
				self replaceItem("loadoutPrimary", data);
				self replaceItem("loadoutSecondary", data);
				break;
			case "cr_attachs":
				self replaceItem("loadoutPrimaryAttachment", data);
				self replaceItem("loadoutPrimaryAttachment2", data);
				self replaceItem("loadoutSecondaryAttachment", data);
				self replaceItem("loadoutSecondaryAttachment2", data);
				self replaceItem("loadoutPrimaryCamo", data);
				self replaceItem("loadoutSecondaryCamo", data);
				self replaceItem("loadoutPrimaryReticle", data);
				self replaceItem("loadoutSecondaryReticle", data);
				break;
			case "cr_buffs":
				self replaceItem("loadoutPrimaryBuff", data);
				self replaceItem("loadoutSecondaryBuff", data);
				break;
			case "cr_equipment":
				self replaceItem("loadoutEquipment", data);
				self replaceItem("loadoutOffhand", data);
				break;
			case "cr_perks":
				self replaceItem("loadoutPerk1", data);
				self replaceItem("loadoutPerk2", data);
				self replaceItem("loadoutPerk3", data);
				break;
			case "cr_streaks":
				self replaceItem("loadoutKillstreak1", data);
				self replaceItem("loadoutKillstreak2", data);
				self replaceItem("loadoutKillstreak3", data);
				self replaceItem("loadoutDeathstreak", data);
				break;		
		}
	}
}

replaceItem(target, data)
{
	ignore = 1;
	for(i = 0; i < data.size; i++)
		if(i != ignore)
		{
			value = i + 1;				
			if(self.pers["gamemodeLoadout"][target] == data[i])
				self.pers["gamemodeLoadout"][target] = data[value];	
			ignore = value;
		}
}

/*
==================================
|   Lethal Beats Team 	  	     |
==================================
|Game : IW5				    	 |
|Script : IW5_BotClassRestricted |
|Creator : LastDemon99	         |
|Type : Addon			         |
==================================
*/

#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	loadData();
	replacefunc(maps\mp\bots\_bot_script::onGiveLoadout, ::onGiveLoadout);
	
	if(getDvar("g_gametype") == "infect" || getDvar("g_gametype") == "jugg")
		replacefunc(maps\mp\bots\_bot::teamBots_loop, ::teamBots_loop);

	if(getDvar("g_gametype") == "infect")
	{
		replacefunc(maps\mp\bots\_bot_internal::canAds, ::canAds);
		replacefunc(maps\mp\bots\_bot_internal::canFire, ::canFire);
	}
}

onGiveLoadout()
{
	self endon( "disconnect" );
	self thread setBotWantSprint();

	for (;;)
	{
		self.pers["gamemodeLoadout"]["loadoutJuggernaut"] = false;
		self waittill( "giveLoadout", team, class, allowCopycat, setPrimarySpawnWeapon );
		
		if(getDvar("g_gametype") == "infect")
		{
			if(self.team == "axis")
			{
				class = "axis_recipe1";
				
				self.pers["bots"]["skill"]["base"] = 5;
				self.pers["bots"]["behavior"]["strafe"] = 80; 
				self.pers["bots"]["behavior"]["nade"] = 50; 
				self.pers["bots"]["behavior"]["sprint"] = 100; 
				self.pers["bots"]["behavior"]["camp"] = 0; 
				self.pers["bots"]["behavior"]["follow"] = 100; 
				self.pers["bots"]["behavior"]["crouch"] = 0; 
			}
			else class = "allies_recipe1";
			
			if (isDefined(self.isInitialInfected) && self.isInitialInfected)
			{
				class = "gamemode";
				self.pers["gamemodeLoadout"]["loadoutJuggernaut"] = true;
				self.pers["bots"]["behavior"]["quickscope"] = true;
				self.pers["bots"]["behavior"]["initswitch"] = 100;
			}
		}
		else if(getDvar("g_gametype") == "jugg")
		{
			if(self.team == "allies")
			{
				class = "gamemode";
				self.pers["gamemodeLoadout"]["loadoutJuggernaut"] = true;
			}
			else class = "axis_recipe1";
		}
		else if(getDvar("g_gametype") == "gun" || getDvar("g_gametype") == "oic")
		{
			class = "gamemode";
		}
		else if(GetMatchRulesData("commonOption", "allowCustomClasses"))
		{
			self setLoadout(class);
			self replaceRestrictedItems();
			class = "gamemode";
		}
		else if(level.defaultRecipes[self.team].size == 0)
			class = "class" + randomInt(4);
		else class = level.defaultRecipes[self.team][randomInt(level.defaultRecipes[self.team].size)];
		
		self maps\mp\bots\_bot_utility::botGiveLoadout(self.team, class, false, true);
		
		if(self.pers["gamemodeLoadout"]["loadoutJuggernaut"])
		{
			self.health = self.maxHealth;
			self.moveSpeedScaler = .65;
			self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
			self setPerk( "specialty_radarjuggernaut", true, false );
		}
	}
}

replaceRestrictedItems()
{
	if(GetMatchRulesData("commonOption", "weaponRestricted", self.pers["gamemodeLoadout"]["loadoutPrimary"]))
	{
		self.pers["gamemodeLoadout"]["loadoutPrimary"] = "none";
		self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment"] = "none";
		self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment2"] = "none";
		self.pers["gamemodeLoadout"]["loadoutPrimaryBuff"] = "specialty_null";
		self.pers["gamemodeLoadout"]["loadoutPrimaryCamo"] = "none";
		self.pers["gamemodeLoadout"]["loadoutPrimaryReticle"] = "none";
	}
	
	if(GetMatchRulesData("commonOption", "weaponRestricted", self.pers["gamemodeLoadout"]["loadoutSecondary"]))
	{
		self.pers["gamemodeLoadout"]["loadoutSecondary"] = "none";
		self.pers["gamemodeLoadout"]["loadoutSecondaryAttachment"] = "none";
		self.pers["gamemodeLoadout"]["loadoutSecondaryAttachment2"] = "none";
		self.pers["gamemodeLoadout"]["loadoutSecondaryBuff"] = "specialty_null";
		self.pers["gamemodeLoadout"]["loadoutSecondaryCamo"] = "none";
		self.pers["gamemodeLoadout"]["loadoutSecondaryReticle"] = "none";
	}
	
	if(GetMatchRulesData("commonOption", "attachmentRestricted", self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment"]))
		self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment"] = "none";
	
	if(GetMatchRulesData("commonOption", "attachmentRestricted", self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment2"]))
		self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment2"] = "none";
	
	if(GetMatchRulesData("commonOption", "attachmentRestricted", self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment"]))
		self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment"] = "none";
	
	if(GetMatchRulesData("commonOption", "attachmentRestricted", self.pers["gamemodeLoadout"]["loadoutSecondaryAttachment"]))
		self.pers["gamemodeLoadout"]["loadoutSecondaryAttachment"] = "none";
	
	if(GetMatchRulesData("commonOption", "attachmentRestricted", self.pers["gamemodeLoadout"]["loadoutSecondaryAttachment2"]))
		self.pers["gamemodeLoadout"]["loadoutSecondaryAttachment2"] = "none";
	
	if(GetMatchRulesData("commonOption", "perkRestricted", self.pers["gamemodeLoadout"]["loadoutPrimaryBuff"]))
		self.pers["gamemodeLoadout"]["loadoutPrimaryBuff"] = "specialty_null";
	
	if(GetMatchRulesData("commonOption", "perkRestricted", self.pers["gamemodeLoadout"]["loadoutSecondaryBuff"]))
		self.pers["gamemodeLoadout"]["loadoutSecondaryBuff"] = "specialty_null";
	
	if(GetMatchRulesData("commonOption", "perkRestricted", self.pers["gamemodeLoadout"]["loadoutEquipment"]))
		self.pers["gamemodeLoadout"]["loadoutEquipment"] = "specialty_null";
	
	if(GetMatchRulesData("commonOption", "perkRestricted", self.pers["gamemodeLoadout"]["loadoutOffhand"]))
		self.pers["gamemodeLoadout"]["loadoutOffhand"] = "specialty_null";
	
	if(GetMatchRulesData("commonOption", "allowPerks"))
	{
		if(GetMatchRulesData("commonOption", "perkRestricted", self.pers["gamemodeLoadout"]["loadoutPerk1"]))
			self.pers["gamemodeLoadout"]["loadoutPerk1"] = "specialty_null";
		
		if(GetMatchRulesData("commonOption", "perkRestricted", self.pers["gamemodeLoadout"]["loadoutPerk2"]))
			self.pers["gamemodeLoadout"]["loadoutPerk2"] = "specialty_null";
		
		if(GetMatchRulesData("commonOption", "perkRestricted", self.pers["gamemodeLoadout"]["loadoutPerk3"]))
			self.pers["gamemodeLoadout"]["loadoutPerk3"] = "specialty_null";
	}
	else
	{
		self.pers["gamemodeLoadout"]["loadoutPerk1"] = "specialty_null";
		self.pers["gamemodeLoadout"]["loadoutPerk2"] = "specialty_null";
		self.pers["gamemodeLoadout"]["loadoutPerk3"] = "specialty_null";
	}
	
	if(GetMatchRulesData("commonOption", "allowKillstreaks") || GetMatchRulesData("commonOption", "killstreakClassRestricted", self.pers["gamemodeLoadout"]["loadoutStreakType"]))
	{
		self.pers["gamemodeLoadout"]["loadoutStreakType"] = "specialty_null";
		self.pers["gamemodeLoadout"]["loadoutKillstreak1"] = "none";
		self.pers["gamemodeLoadout"]["loadoutKillstreak2"] = "none";
		self.pers["gamemodeLoadout"]["loadoutKillstreak3"] = "none";
	}
	else
	{
		if(GetMatchRulesData("commonOption", "killstreakRestricted", self.pers["gamemodeLoadout"]["loadoutKillstreak1"]))
			self.pers["gamemodeLoadout"]["loadoutKillstreak1"] = "none";
		
		if(GetMatchRulesData("commonOption", "killstreakRestricted", self.pers["gamemodeLoadout"]["loadoutKillstreak2"]))
			self.pers["gamemodeLoadout"]["loadoutKillstreak2"] = "none";
		
		if(GetMatchRulesData("commonOption", "killstreakRestricted", self.pers["gamemodeLoadout"]["loadoutKillstreak3"]))
			self.pers["gamemodeLoadout"]["loadoutKillstreak3"] = "none";
	}
	
	if(GetMatchRulesData("commonOption", "perkRestricted", self.pers["gamemodeLoadout"]["loadoutDeathstreak"]))
		self.pers["gamemodeLoadout"]["loadoutDeathstreak"] = "specialty_null";
	
	if(self.pers["gamemodeLoadout"]["loadoutPrimary"] == "none" && self.pers["gamemodeLoadout"]["loadoutSecondary"] == "none")
		self.pers["gamemodeLoadout"]["loadoutPrimary"] = getRandomWep();
}

loadData()
{
	if(!GetMatchRulesData("commonOption", "allowCustomClasses"))
	{
		level.defaultRecipes["allies"] = [];
		level.defaultRecipes["axis"] = [];
		
		foreach(team in ["allies", "axis"])
		{
			maxIndex = getDvar("g_gametype") == "tjugg" || getDvar("g_gametype") == "sd" || getDvar("g_gametype") == "sab" || getDvar("g_gametype") == "ctf" || getDvar("g_gametype") == "tdef" ? 5 : 6;
			for(i = 0; i < maxIndex; i++)
			{
				if (GetMatchRulesData("defaultClasses", team, i, "class", "inUse"))
					level.defaultRecipes[team][level.defaultRecipes[team].size] = team + "_recipe" + (i + 1);
			}
		}
	}
	
	level.allPrimary = ["iw5_m4",
					   "iw5_ak47",
					   "iw5_m16",
					   "iw5_fad",
					   "iw5_acr",
					   "iw5_type95",
					   "iw5_mk14",
					   "iw5_scar",
					   "iw5_g36c",
					   "iw5_cm901",
					   "iw5_mp7",
					   "iw5_m9",
					   "iw5_p90",
					   "iw5_pp90m1",
					   "iw5_ump45",
					   "iw5_barrett",
					   "iw5_rsass",
					   "iw5_dragunov",
					   "iw5_msr",
					   "iw5_l96a1",
					   "iw5_as50",
					   "iw5_ksg",
					   "iw5_1887",
					   "iw5_striker",
					   "iw5_aa12",
					   "iw5_usas12",
					   "iw5_spas12",
					   "iw5_m60",
					   "iw5_mk46",
					   "iw5_pecheneg",
					   "iw5_sa80",
					   "iw5_mg36",
					   "riotshield"];
}

getRandomWep()
{
	weapon = "iw5_m4";
	while(true)
	{
		rndWep = level.allPrimary[randomInt(level.allPrimary.size)];
		if(!GetMatchRulesData("commonOption", "weaponRestricted", rndWep))
		{
			weapon = rndWep;
			break;
		}
	}
	return weapon;
}

setLoadout(class)
{
	class_num = maps\mp\gametypes\_class::getClassIndex( class );
	self.class_num = class_num;
	
	self.pers["gamemodeLoadout"]["loadoutPrimary"] = maps\mp\gametypes\_class::cac_getWeapon( class_num, 0 );
	self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment"] = maps\mp\gametypes\_class::cac_getWeaponAttachment( class_num, 0 );
	self.pers["gamemodeLoadout"]["loadoutPrimaryAttachment2"] = maps\mp\gametypes\_class::cac_getWeaponAttachmentTwo( class_num, 0 );
	self.pers["gamemodeLoadout"]["loadoutPrimaryBuff"] = maps\mp\gametypes\_class::cac_getWeaponBuff( class_num, 0 );
	self.pers["gamemodeLoadout"]["loadoutPrimaryCamo"] = maps\mp\gametypes\_class::cac_getWeaponCamo( class_num, 0 );
	self.pers["gamemodeLoadout"]["loadoutPrimaryReticle"] = maps\mp\gametypes\_class::cac_getWeaponReticle( class_num, 0 );
	self.pers["gamemodeLoadout"]["loadoutSecondary"] = maps\mp\gametypes\_class::cac_getWeapon( class_num, 1 );
	self.pers["gamemodeLoadout"]["loadoutSecondaryAttachment"] = maps\mp\gametypes\_class::cac_getWeaponAttachment( class_num, 1 );
	self.pers["gamemodeLoadout"]["loadoutSecondaryAttachment2"] = maps\mp\gametypes\_class::cac_getWeaponAttachmentTwo( class_num, 1 );
	self.pers["gamemodeLoadout"]["loadoutSecondaryBuff"] = maps\mp\gametypes\_class::cac_getWeaponBuff( class_num, 1 );
	self.pers["gamemodeLoadout"]["loadoutSecondaryCamo"] = maps\mp\gametypes\_class::cac_getWeaponCamo( class_num, 1 );
	self.pers["gamemodeLoadout"]["loadoutSecondaryReticle"] = maps\mp\gametypes\_class::cac_getWeaponReticle( class_num, 1 );
	self.pers["gamemodeLoadout"]["loadoutEquipment"] = maps\mp\gametypes\_class::cac_getPerk( class_num, 0 );
	self.pers["gamemodeLoadout"]["loadoutPerk1"] = maps\mp\gametypes\_class::cac_getPerk( class_num, 1 );
	self.pers["gamemodeLoadout"]["loadoutPerk2"] = maps\mp\gametypes\_class::cac_getPerk( class_num, 2 );
	self.pers["gamemodeLoadout"]["loadoutPerk3"] = maps\mp\gametypes\_class::cac_getPerk( class_num, 3 );
	self.pers["gamemodeLoadout"]["loadoutStreakType"] = maps\mp\gametypes\_class::cac_getPerk( class_num, 5 );
	self.pers["gamemodeLoadout"]["loadoutOffhand"] = maps\mp\gametypes\_class::cac_getOffhand( class_num );
	self.pers["gamemodeLoadout"]["loadoutDeathstreak"] = maps\mp\gametypes\_class::cac_getDeathstreak( class_num );
	self.pers["gamemodeLoadout"]["loadoutJuggernaut"] = false;
	
	if (self.pers["gamemodeLoadout"]["loadoutStreakType"] == "specialty_null" )
	{
		self.pers["gamemodeLoadout"]["loadoutKillstreak1"] = "none";
		self.pers["gamemodeLoadout"]["loadoutKillstreak2"] = "none";
		self.pers["gamemodeLoadout"]["loadoutKillstreak3"] = "none";
	}
	else
	{
		playerData = undefined;
		switch ( self.streakType )
		{
			case "support":
				playerData = "defenseStreaks";
				break;

			case "specialist":
				playerData = "specialistStreaks";
				break;

			default:
				playerData = "assaultStreaks";
				break;
		}
		
		customClassLoc = maps\mp\gametypes\_class::cac_getCustomClassLoc();
		self.pers["gamemodeLoadout"]["loadoutKillstreak1"] = self getplayerdata( customClassLoc, self.class_num, playerData, 0 );
		self.pers["gamemodeLoadout"]["loadoutKillstreak2"] = self getplayerdata( customClassLoc, self.class_num, playerData, 1 );
		self.pers["gamemodeLoadout"]["loadoutKillstreak3"] = self getplayerdata( customClassLoc, self.class_num, playerData, 2 );
	}
}

teamBots_loop()
{
	teamAmount = getDvarInt( "bots_team_amount" );

	alliesbots = 0;
	alliesplayers = 0;
	axisbots = 0;
	axisplayers = 0;

	playercount = level.players.size;

	for ( i = 0; i < playercount; i++ )
	{
		player = level.players[i];

		if ( !isDefined( player.pers["team"] ) )
			continue;

		if ( player maps\mp\bots\_bot_utility::is_bot() )
		{
			if ( player.pers["team"] == "allies" )
				alliesbots++;
			else if ( player.pers["team"] == "axis" )
				axisbots++;
		}
		else
		{
			if ( player.pers["team"] == "allies" )
				alliesplayers++;
			else if ( player.pers["team"] == "axis" )
				axisplayers++;
		}
	}

	allies = alliesbots;
	axis = axisbots;

	if ( !getDvarInt( "bots_team_mode" ) )
	{
		allies += alliesplayers;
		axis += axisplayers;
	}
	
	playercount = level.players.size;

	for ( i = 0; i < playercount; i++ )
	{
		player = level.players[i];

		if ( !player maps\mp\bots\_bot_utility::is_bot() )
			continue;
		
		if (!isDefined(player.pers["team"]))
		{
			if(getDvar("g_gametype") == "infect")
				player thread [[level.allies]]();
			if(getDvar("g_gametype") == "jugg")
				player thread [[level.axis]]();
		}
	}
}

canAds( dist, curweap )
{
	return self.team == "allies" || (isDefined(self.isInitialInfected) && self.isInitialInfected);
}

canFire( curweap )
{
	return self.team == "allies" || (isDefined(self.isInitialInfected) && self.isInitialInfected);
}

setBotWantSprint()
{
	for(;;)
	{
		if(getDvar("g_gametype") != "infect") break;
		
		if(isDefined(self.pers["team"]) && self.team == "axis")
			self thread maps\mp\bots\_bot_internal::setBotWantSprint();		
		wait .35;
	}
}

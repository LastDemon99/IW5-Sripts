#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\_mapedit_utility;

main()
{
	replacefunc(maps\mp\_utility::allowTeamChoice, ::teamChoice);
	replacefunc(maps\mp\_utility::allowClassChoice, ::classChoice);
}

init() 
{	
	loadData();
	
	level thread hook_callbacks();
	level thread onSay();
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
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self setWeapon();
		self setPerks();
		self openMenu("perk_hide");
		self setClientDvar("cg_drawFPS", 3);
		self thread refillAmmo();
		
		self.hasBuild = false;
		self.buildType = "none";
	}
}

loadData()
{
	setDvar("sv_cheats", 1);
	setDvar("scr_" + level.gametype + "_timelimit", 0);
	setDvar("scr_" + level.gametype + "_scoreLimit", 0);
	setDvar("scr_game_graceperiod", 0);
	setDvar("scr_game_playerwaittime", 0);
	setDvar("scr_game_matchstarttime", 0);
	
	level.killstreakRewards = false;	
	level.buildData = [];
	
	if(!isDefined(level.buildIndex)) level.buildIndex = 0;
}

onCommand(player, msg)
{
	args = [];
	foreach(i in msg)
		args[args.size] = tolower(i);
	
	switch(args[0])
	{
		case "!s": player suicide(); break;
		case "!fly": player fly(); break;
		case "!save": player thread logSave(); break;
		case "!undo":
			if(!level.buildData.size) break;		
			player.hasBuild = 0;
			foreach(ent in level.buildData[level.buildIndex]["ents"])
			{
				if(isDefined(ent.objID)) _objective_delete(ent.objID);
				if(isDefined(ent.hasTrigger)) ent notify("death");
				ent delete();
			}			
			level.buildData[level.buildIndex] = undefined;
			level.buildIndex -= 1;
			break;
		case "!model": player setBuild("model", args[1], player GetPlayerAngles()); break;
		case "!wall": player setBuild("wall"); break;
		case "!hwall": player setBuild("hwall"); break;
		case "!floor": player setBuild("floor"); break;
		case "!hfloor": player setBuild("hfloor"); break;
		case "!ramp": player setBuild("ramp"); break;
		case "!hramp": player setBuild("hramp"); break;
		case "!tp": player setBuild("tp", player GetPlayerAngles()); break;
		case "!tp2": player setBuild("tp2", player GetPlayerAngles()); break;
		case "!htp": player setBuild("htp", player GetPlayerAngles()); break;
		case "!platform": player setBuild("platform", (int(args[1]), int(args[2]), int(args[3])), player GetPlayerAngles()[1]); break;
	}
}

onSay()
{
	level endon("game_ended");
	
	for(;;) 
	{
		level waittill("say", message, player);
		
		level.args = [];	
		str = strTok(message, "");
		i = 0;
		
		if(!string_starts_with(str[0], "!")) break;
		
		foreach (s in str) 
		{
			level.args[i] = s;
			i++;
		}
		
		str = strTok( level.args[0], " ");
		i = 0;
		
		if(!string_starts_with(str[0], "!")) break;
		
		foreach(s in str) 
		{
			level.args[i] = s;
			i++;
		}
		
		onCommand(player, level.args);
	}
}

setBuild(type, arg1, arg2)
{
	if(!self.hasBuild)
	{
		self.hasBuild = true;
		level.buildIndex = level.buildData.size;
		level.buildData[level.buildIndex][0] = type;
		level.buildData[level.buildIndex][1] = self.origin;	
		self iPrintln("^7" + type + " start: ^3" + self.origin);
		
		if(type == "platform" || type == "model")
		{
			if(isDefined(arg1)) level.buildData[level.buildIndex][2] = arg1;
			if(isDefined(arg2)) level.buildData[level.buildIndex][3] = arg2;
			self.hasBuild = 0;
		}
		else return;
	}
	else
	{
		self.hasBuild = 0;
		level.buildData[level.buildIndex][2] = self.origin;
		if(isDefined(arg1)) level.buildData[level.buildIndex][3] = arg1;
		if(isDefined(arg2)) level.buildData[level.buildIndex][4] = arg2;
		self iPrintln("^7" + type + " end: ^3" + self.origin);
	}
	
	spawnBuild(type, level.buildIndex);
}

logSave()
{
	if(!level.buildData.size)
	{
		self iPrintln("^7The map has no build data");
		logprint("\n\n//*********** EasyMapEdit **************\n\nThe map has no build data\n\n//*********** EasyMapEdit **************\n\n");
		return;
	}
	
	data = "\n\n//*********** EasyMapEdit **************\n";
	data += "\n#include common_scripts\\utility;\n#include maps\\mp\\_utility;\n#include maps\\mp\\_mapedit_utility;";
	data += "\n\ninit()\n{\n	if(getDvar(\"mapname\") != \"" + getDvar("mapname") + "\") return;\n\n	level.buildData = [];";	
	
	for(i = 0; i < level.buildData.size; i++)
	{
		strData = "\n";
		buildData = level.buildData[i];		
		if (buildData.size == 5) strData += "	level.buildData[" + i + "] = [ \"" + buildData[0] + "\", " + buildData[1] + ", " + buildData[2] + ", " + buildData[3] + "];";
		else if (buildData.size == 4) strData += "	level.buildData[" + i + "] = [ \"" + buildData[0] + "\", " + buildData[1] + ", " + buildData[2] + "];";
		data += strData;
	}
	
	data += "\n	level.buildIndex = " + min(0, level.buildData.size - 1) + ";";
	
	data += "\n\n	for(i = 0; i < level.buildData.size; i++)\n		spawnBuild(level.buildData[i][0], i);";	
	data += "\n}\n\n//*********** EasyMapEdit **************\n\n";
	logprint(data);
	self iPrintln("^7Map has been saved in log file");
}

fly()
{
	if (self.sessionstate == "spectator")
	{
		self allowSpectateTeam("freelook", false);
		self.sessionstate = "playing";
		self setContents(100);
		return;
	}
	
	self allowSpectateTeam("freelook", true);
	self.sessionstate = "spectator";
	self setContents(0);
}

setWeapon()
{
	weapon = "iw5_usp45_mp_silencer02_xmags";
	self takeAllWeapons();			
	_giveWeapon(weapon);
	self.primaryWeapon = weapon;
	self.pers["primaryWeapon"] = weapon;
	self setSpawnWeapon(weapon);
	self giveMaxAmmo(weapon);
}

setPerks()
{
	self _clearPerks();
	foreach(perk in [ "specialty_longersprint", "specialty_fastreload", "specialty_quickdraw", "specialty_bulletaccuracy", "specialty_quieter", "specialty_stalker", "specialty_longerrange", "specialty_fastermelee", "specialty_reducedsway", "specialty_lightweight"])
	{
		if(maps\mp\gametypes\_class::isPerkUpgraded(perk))
		{
			self givePerk(tablelookup( "mp/perktable.csv", 1, perk, 8), false);
			continue;
		}
		self givePerk(perk, false);
	}
}

refillAmmo()
{
    level endon( "game_ended" );
    self endon( "disconnect" );

    for (;;)
    {
        self waittill("reload");	
		self giveMaxAmmo(self getCurrentWeapon());
    }
}

hook_callbacks()
{
	level waittill( "prematch_over" );
	wait 0.05;
	
	level.prevCallbackPlayerDamage = level.callbackPlayerDamage;
	level.callbackPlayerDamage = ::onPlayerDamage;
}

onPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime) {}
teamChoice() { return false; }
classChoice() { return false; }
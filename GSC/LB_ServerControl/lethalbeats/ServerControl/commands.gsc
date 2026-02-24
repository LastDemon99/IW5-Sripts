#include lethalbeats\array;
#include lethalbeats\string;
#include lethalbeats\servercontrol\groups;
#include lethalbeats\servercontrol\miscellaneous;

#define FUNC 0
#define POWER 1
#define ARGS_MIN 2
#define USAGE_MSG 3
#define VALID_MSG 4
#define INVALID_MSG 5
#define ARGS_IS_MSG 6

#define INSUFFICIENT_PRIVILEGES_MSG 12

init()
{
	// cmd, functionPointer, power, min_arguments, usage_message, valid_message, invalid_message, argsAsMessage
	setCommand("help", ::help);
	setCommand("map", ::changeMap, 70, 1, "Use !map <name> to change the map.", "Maps has been changed to <arg1>.", "<arg1> is not a valid map.");
	setCommand("dsr", ::changeDsr, 70, 1, "Use !dsr <name> to change the dsr.", "DSR has been changed to <arg1>.", "<arg1> is not a valid dsr.");
	setCommand("rotate", ::rotate, 70, 0, undefined, "Level has been rotated.");
	setCommand("restart", ::restart, 70, 0, undefined, "Map has been restarted.");
	setCommand("fastRestart", ::fastrestart, 70, 0, undefined, "Map has been restarted.");
	setCommand("kick", ::_kick, 70, 1, "Use !kick <name|#id> <reason> to kick the player.", "<arg1> has been kicked.", "<arg1> is not a valid <arg2>.");
	setCommand("ban", ::ban, 70, 1, "Use !ban <name|#id> <time> <reason> to ban the player.", "<arg1> has been banned for a period of <arg2>.", "<arg1> is not a valid <arg2>.");
	setCommand("pban", ::pban, 70, 1, "Use !pban <name|#id> <reason> to permanently ban the player.", "<arg1> has been banned permanently.", "Player not found.");
	setCommand("unban", ::unban, 70, 1, "Use !unban <name|#id> <reason> to unban the player.", "<arg1> has been unbanned permanently.", "Player not found.");
	setCommand("suicide", ::_suicide);
	setCommand("say", ::_say, 40, 1, "Use !say <message> to say the message.", undefined, undefined, true);
	setCommand("spam", ::spam, 40, 1, "Use !spam <message> to spam the message.", undefined, undefined, true);
	setCommand("pm", ::pm, 0, 2, "Use !pm <name|#id> <message> to send a private message to the player.", "The message has been sent to <arg1>.", "Player not found.", true);
	setCommand("admins", ::admins);
	setCommand("balance", ::balance, 40, 0, undefined, "Team has been balanced.");
	setCommand("players", ::players);
	setCommand("next", ::next, 0, 1, "Use !next <map|dsr> to know what you come next.");
	setCommand("setnext", ::setnext, 40, 1, "Use !setnext <map|dsr> | !setnext <map> <dsr> to set the next level.", "<arg1> in <arg2> has been set to next level.", "<arg1> is not valid.");
	setCommand("mute", ::mute, 40, 1, "Use !mute <name|#id> to mute the player.", undefined, "Player not found.");
	setCommand("dvar", ::dvar, 90, 2, "Use !dvar <dvar> <value> to set dvar.");
	setCommand("cdvar", ::cdvar, 90, 2, "Use !cdvar <dvar> <value> to set client dvar.");
	setCommand("setgroup", ::setgroup, 70, 2, "Use !setgroup <name|#id> <group> to set the player group.", "<arg1> is now <arg2>.", "<arg1> is not a valid <arg2>.");
	setCommand("groups", ::groups, 70);
	setCommand("vote", ::vote, 40, 1, "Use !vote <map|dsr|mode> to start the votation.", "Votation has been started.", "<arg1> is not a valid.");
	setCommand("social", ::social);
	setCommand("register", ::register);
	setCommand("stats", ::stats);
	setCommand("rules", ::rules);

	setCommandAlias("rotate", "rot");
	setCommandAlias("fastrestart", "res");
	setCommandAlias("suicide", "s");

	level thread onSay();
}

onSay()
{
	level endon("game_ended");

	for(;;)
	{
		level waittill("say", message, player);
		
		if (message[0] != "!" || message.size == 1) continue;
				
		message = StrTok(GetSubStr(message, 1), " ");
		cmd = ToLower(message[0]);

		cmd_data = getCommandData(cmd);
		if (!isDefined(cmd_data)) continue;
		
		args = array_slice(message, 1);
		
		if (player getGroupPower() < cmd_data[POWER])
		{
			player tell(getMisc(INSUFFICIENT_PRIVILEGES_MSG));
			continue;
		}
		
		if (args.size < cmd_data[ARGS_MIN])
		{
			if (isDefined(cmd_data[USAGE_MSG])) player tell(cmd_data[USAGE_MSG]);
			continue;
		}
		
		if (cmd_data[ARGS_IS_MSG])
		{
			player thread [[cmd_data[FUNC]]](cmd_data[VALID_MSG], cmd_data[INVALID_MSG], args);
			continue;
		}

		msgDefined = isDefined(cmd_data[VALID_MSG]) && isDefined(cmd_data[INVALID_MSG]);
		
		switch(args.size)
		{
			case 3:
				if (isDefined(cmd_data[INVALID_MSG]))
					player thread [[cmd_data[FUNC]]](cmd_data[VALID_MSG], cmd_data[INVALID_MSG], args[0], args[1], args[2]);
				else if (isDefined(cmd_data[VALID_MSG]))
					player thread [[cmd_data[FUNC]]](cmd_data[VALID_MSG], args[0], args[1], args[2]);
				else
					player thread [[cmd_data[FUNC]]](args[0], args[1], args[2]);
				continue;
			case 2: 
				if (isDefined(cmd_data[INVALID_MSG]))
					player thread [[cmd_data[FUNC]]](cmd_data[VALID_MSG], cmd_data[INVALID_MSG], args[0], args[1]);
				else if (isDefined(cmd_data[VALID_MSG]))
					player thread [[cmd_data[FUNC]]](cmd_data[VALID_MSG], args[0], args[1]);
				else
					player thread [[cmd_data[FUNC]]](args[0], args[1]);
				continue;
			case 1: 
				if (isDefined(cmd_data[INVALID_MSG]))
					player thread [[cmd_data[FUNC]]](cmd_data[VALID_MSG], cmd_data[INVALID_MSG], args[0]);
				else if (isDefined(cmd_data[VALID_MSG]))
					player thread [[cmd_data[FUNC]]](cmd_data[VALID_MSG], args[0]);
				else
					player thread [[cmd_data[FUNC]]](args[0]);
				continue;
			default: 
				if (isDefined(cmd_data[INVALID_MSG]))
					player thread [[cmd_data[FUNC]]](cmd_data[VALID_MSG], cmd_data[INVALID_MSG]);
				else if (isDefined(cmd_data[VALID_MSG]))
					player thread [[cmd_data[FUNC]]](cmd_data[VALID_MSG]);
				else
					player thread [[cmd_data[FUNC]]]();
				continue;
		}
	}
}

/*
///DocStringBegin
detail: setCommand(cmd: <String>, func: <Pointer>, power: <Int | undefined>, min_arguments: <Int | undefined>, usage_message: <String | undefined>, valid_message: <String | undefined>, invalid_message: <String | undefined>, argsIsMessage: <Boolean | undefined>): <Void>
summary: Adds a new command to the level's command list with the specified properties.
///DocStringEnd
*/
setCommand(cmd, function, power, min_arguments, usage_message, valid_message, invalid_message, argsIsMessage)
{
	if (!isDefined(level.commands)) level.commands = [];
	if (!isDefined(argsIsMessage)) argsIsMessage = false;
	if (!isDefined(min_arguments)) min_arguments = 0;
	if (!isDefined(power)) power = 0;
	if (!isDefined(function) || !isDefined(cmd)) return;
    level.commands[cmd] = [function, power, min_arguments, usage_message, valid_message, invalid_message, argsIsMessage];
}

setCommandAlias(cmd, alias)
{
	if (!isDefined(level.commandsAlias)) level.commandsAlias = [];
	level.commandsAlias[alias] = cmd;
}

getCommandData(cmd)
{
	if (array_contains_key(level.commands, cmd)) return level.commands[cmd];
	if (array_contains_key(level.commandsAlias, cmd)) return level.commands[level.commandsAlias[cmd]];
	return undefined;
}

addCmdArgsMessage(cmd)
{
	level.cmd_msg_format[level.cmd_msg_format.size] = cmd;
}

getComandPower(cmd)
{
	cmd_data = getCommandData(cmd);
	return isDefined(cmd_data) ? cmd_data[POWER] : 0;
}

help(valid_msg, invalid_msg)
{
	level endon("game_ended");	
	foreach(cmd in getarraykeys(level.commands))
	{
		if (getComandPower(cmd) > self getGroupPower()) continue;
		self tell("!" + cmd);
		wait 1;
	}
}

changeMap(valid_msg, invalid_msg, map)
{
	target = findMap(map);
	if (!isDefined(target))
	{
		self tell(format_message(invalid_msg, map));
		return;
	}

	say(format_message(valid_msg, target[1]));
	cmdexec("map " + target[0]);
}

changeDsr(valid_msg, invalid_msg, dsr)
{
	cmdexec("load_dsr " + dsr);
	wait(0.35);
	cmdexec("map_restart");
	say(format_message(valid_msg, dsr));
}

rotate(valid_msg)
{
	mapRotation = getDvar("sv_mapRotation");
	if (!isDefined(mapRotation)) return;

	mapRotation = string_replace(mapRotation, "map ", "");
	mapRotation = strTok(mapRotation, " ");	
	maps = array_slice(mapRotation, 2);

	cmdexec("load_dsr " + mapRotation[1]);
	wait(0.35);
	cmdexec("map " + array_random(maps));
	say(valid_msg);
}

restart(valid_msg)
{
	say(valid_msg);
	cmdexec("map_restart");
}

fastRestart(valid_msg)
{
	say(valid_msg);
	cmdexec("fast_restart");
}

_kick(valid_msg, invalid_msg, target, reason)
{
	if (!isDefined(reason)) reason = "You has been kicked.";
	target = findPlayer(target);
	say(format_message(valid_msg, target.name));
	if (isDefined(target)) kick(target GetEntityNumber());
}

ban(valid_msg, invalid_msg, target, time, reason) // not finished required plugin SDK write & read files
{
	//"Use !ban <name|#id> <time> <reason> to ban the player.", "<arg1> has been banned for a period of <arg2>.", "<arg1> is not a valid <arg2>.");
	//if (!isDefined(reason)) reason = "You has been banned.";
	//target = findPlayer(target);
	//say(format_message(valid_msg, target.name));
	//if (isDefined(target)) kick(target GetEntityNumber());
}

pban(valid_msg, invalid_msg) // not finished required plugin SDK write & read files
{
}

unban(valid_msg, invalid_msg) // not finished required plugin SDK write & read files
{
}

_suicide(valid_msg, invalid_msg)
{
	self suicide();
}

_say(valid_msg, invalid_msg, message)
{
	say(string_join(" ", message));
}

spam(valid_msg, invalid_msg, message)
{
	level endon("game_ended");
	for(i = 0; i < 7; i++)
	{
		say("^" + i + string_join(" ", message));
		wait 1;
	}
}

pm(valid_msg, invalid_msg, message)
{
	target = findPlayer(message[0]);
	
	if (!isDefined(target))
	{
		self tell(invalid_msg);
		return;
	}
	
	self tell(valid_msg);	
	target tell("^0[^1PM^0]^7" + self.name + ": " + string_join(" ", array_slice(message, 1)));
}

admins(valid_msg, invalid_msg) // not finished text from csv bug character | required plugin SDK write & read files
{
	level endon("game_ended");
	admin_min_power = getComandPower("ban");
	foreach(player in level.players)
	{
		if (admin_min_power > player getGroupPower()) continue;
		
		test = player getGroupAlias() + "";
		
		test2 = "";
		for(i = 0; i < test.size; i++)
			test2 += test[i];
		
		test2 = GetSubStr(test2, 1);		
		print(test2); // work
		print(player.name + test2 + player.name); // work
		print(test2 + test2 + player.name); // buged text
		
		say(test2 + "" + player.name);
		wait 1;
	}
}

balance(valid_msg)
{
	maps\mp\gametypes\_teams::balanceTeams();
	say(valid_msg);
}

players(valid_msg, invalid_msg)
{
	level endon("game_ended");
	for(i = 0; i < level.players.size; i++)
	{
		self tell("#" + i + " " + level.players[i].name);
		wait 1;
	}
}

next(valid_msg, invalid_msg, target) // not finished required map rotate
{
	
}

setNext(valid_msg, invalid_msg, target) // not finished required map rotate
{
	
}

mute(valid_msg, invalid_msg, target) // not finished required plugin SDK write & read files
{
	
}

dvar(valid_msg, invalid_msg, target) // not finished
{
	
}

cDvar(valid_msg, invalid_msg, target) // not finished
{
	
}

setgroup(valid_msg, invalid_msg, target) // not finished required plugin SDK write & read files
{
	
}

groups(valid_msg, invalid_msg, target) // not finished
{
	
}

vote(valid_msg, invalid_msg, target) // not finished
{
	
}

social(valid_msg, invalid_msg, target) // not finished
{
	
}

register(valid_msg, invalid_msg, target) // not finished required plugin SDK write & read files
{
	
}

stats(valid_msg, invalid_msg, target) // not finished required plugin SDK write & read files
{
	
}

rules(valid_msg, invalid_msg, target) // not finished
{
	
}

format_message(msg, arg1, arg2, arg3, arg4)
{
	if (isDefined(arg4)) msg = string_replace(msg, "<arg4>", arg4 + "");
	if (isDefined(arg3)) msg = string_replace(msg, "<arg3>", arg3 + "");
	if (isDefined(arg2)) msg = string_replace(msg, "<arg2>", arg2 + "");
	if (isDefined(arg1)) msg = string_replace(msg, "<arg1>", arg1 + "");
	return msg;
}

findMap(target)
{
	target = tolower(target);
	maps = getMaps();	
	foreach (map in maps)
		if(isSubStr(tolower(map), toLower(target)))
			return strTok(map, ";");
	return undefined;
}

findPlayer(target)
{
	if (target[0] == "#")
	{
		for(i = 0; i < level.players.size; i++)
			if (GetSubStr(target, 1) == "" + i)
				return level.players[i];
		return undefined;
	}
	
	foreach (Player in level.players)
		if(isSubStr(tolower(Player.name), tolower(target)))
			return Player;
		
	return undefined;
}

getMaps()
{
	return [ "mp_plaza2;Arkaden",
            "mp_mogadishu;Bakaara",
            "mp_bootleg;Bootleg",
            "mp_carbon;Carbon",
            "mp_dome;Dome",
            "mp_exchange;Downturn",
            "mp_lambeth;Fallen",
            "mp_hardhat;Hardhat",
            "mp_interchange;Interchange",
            "mp_alpha;Lockdown",
            "mp_bravo;Mission",
            "mp_radar;Outpost",
            "mp_paris;Resistance",
            "mp_seatown;Seatown",
            "mp_underground;Underground",
            "mp_village;Village",
			"mp_morningwood;Blackbox",
            "mp_park;Liberation",
            "mp_qadeem;Oasis",
            "mp_overwatch;Overwatch",
            "mp_italy;Piazza",
            "mp_meteora;Sanctuary",
            "mp_cement;Foundation",
            "mp_aground_ss;Aground",
            "mp_hillside_ss;Getaway",
            "mp_restrepo_ss;Lookout",
            "mp_courtyard_ss;Erosion",
            "mp_terminal_cls;Terminal" ];
}

getMap(map)
{
	return findMap(map)[0];
}

getMapAlias(map)
{
	return findMap(map)[1];
}

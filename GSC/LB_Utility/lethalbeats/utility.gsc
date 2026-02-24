/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : utility          |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

get_enemy_team(team)
{
	teams = [];
	teams["axis"] = "allies";
	teams["allies"] = "axis";
	return teams[team];
}

clear_score_info()
{
	maps\mp\gametypes\_rank::registerScoreInfo("kill", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("assist", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("suicide", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("teamkill", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("headshot", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("execution", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("avenger", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("defender", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("posthumous", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("revenge", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("double", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("triple", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("multi", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("buzzkill", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("firstblood", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("comeback", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("longshot", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("assistedsuicide", 0);
    maps\mp\gametypes\_rank::registerScoreInfo("knifethrow", 0);
}

is_string(value)
{
    return isString(value);
}

is_array(value)
{
    return isArray(value);
}

is_vector(value)
{
    if (isArray(value) || isString(value)) return false;
    
    value_str = value + "";

    if (!lethalbeats\string::string_starts_with(value_str, "(") || !lethalbeats\string::string_ends_with(value_str, ")") || !lethalbeats\string::string_contains(value_str, ", ")) return false;

    value_str = lethalbeats\string::string_slice(value_str, 1, value_str.size - 1);
    tokens = lethalbeats\string::string_split(value_str, ", ");

    if (tokens.size != 3) return false;

    return true;
}

is_number(value)
{
    return !isString(value) && !isArray(value) && !is_vector(value); // isObject | isEntity (◞ ‸ ◟ㆀ)??
}

is_int(value)
{
    return is_number(value) && int(value) == value;
}

is_float(value)
{
	return is_number(value) && int(value) != value;
}

is_trigger(value)
{
    if (!isDefined(value)) value = self;
    if (!isDefined(value.classname)) return false;

    switch(value.classname)
    {
        case "trigger_radius":
            return true;
        case "trigger_multiple":
            return true;
        case "trigger_once":
            return true;
        case "trigger_use":
            return true;
        case "trigger_lookat":
            return true;
        case "trigger_damage":
            return true;
        case "trigger_hurt":
            return true;
        default:
            return false;
    }
}

is_model(value)
{
    if (!isDefined(value)) value = self;
    if (!isDefined(value.classname)) return false;
    return value.classname == "script_model";
}

is_type_equal(x, y)
{
    return (isString(x) && isString(y)) || (isArray(x) && isArray(y)) || (is_vector(x) && is_vector(y)) || (is_float(x) && is_float(y)) || (is_int(x) && is_int(y));
}

waittill_any(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
{
	if (!isdefined(arg1)) return;
	self endon("time_end");

	if (isdefined(arg2))
	{
        if (isString(arg2)) self endon(arg2);
        else self thread _wait_time(arg2);
    }

    if (isdefined(arg3))
	{
        if (isString(arg3)) self endon(arg3);
        else self thread _wait_time(arg3);
    }

    if (isdefined(arg4))
	{
        if (isString(arg4)) self endon(arg4);
        else self thread _wait_time(arg4);
    }

    if (isdefined(arg5))
	{
        if (isString(arg5)) self endon(arg5);
        else self thread _wait_time(arg5);
    }

    if (isdefined(arg6))
	{
        if (isString(arg6)) self endon(arg6);
        else self thread _wait_time(arg6);
    }

    if (isdefined(arg7))
	{
        if (isString(arg7)) self endon(arg7);
        else self thread _wait_time(arg7);
    }

    if (isdefined(arg8))
	{
        if (isString(arg8)) self endon(arg8);
        else self thread _wait_time(arg8);
    }
	
    if (isString(arg1)) self waittill(arg1);
    else wait arg1;

	self notify("time_end"); 
}

_wait_time(time)
{
    self endon("time_end");
    wait time;
    self notify("time_end");
}

waittill_notify_or_timeout( msg, timer )
{
    self endon( msg );
    wait(timer);
}

/*
///DocStringBegin
detail: waittill_any_return(notify1, notify2, notify3, notify4, notify5, notify6, notify7, notify8): <String | Float>
summary: Wait and return any notification or time listing.
///DocStringEnd
*/
waittill_any_return(notify1, notify2, notify3, notify4, notify5, notify6, notify7, notify8)
{
    endon_msg = "" + getTime();
    endon_msg += randomInt(1000000);
	if (isdefined(notify1)) self thread _waittill_return(endon_msg, notify1);
	if (isdefined(notify2)) self thread _waittill_return(endon_msg, notify2);
    if (isdefined(notify3)) self thread _waittill_return(endon_msg, notify3);
    if (isdefined(notify4)) self thread _waittill_return(endon_msg, notify4);
    if (isdefined(notify5)) self thread _waittill_return(endon_msg, notify5);
    if (isdefined(notify6)) self thread _waittill_return(endon_msg, notify6);
    if (isdefined(notify7)) self thread _waittill_return(endon_msg, notify7);
    if (isdefined(notify8)) self thread _waittill_return(endon_msg, notify8);    
    self waittill(endon_msg, notify_msg);
	return notify_msg;
}

_waittill_return(endon_msg, notify_msg)
{
    self endon(endon_msg);

    if (isString(notify_msg))
    {
        self waittill(notify_msg);
        self notify(endon_msg, notify_msg);
    }
    else
    {
        wait notify_msg;
        self notify(endon_msg, notify_msg);
    }
}

wait_frame()
{
	wait(0.07);
}

get_map_center(rightful)
{
    if (isDefined(rightful) && rightful)
    {
        minimapCorner = getEntArray("minimap_corner", "targetname");
	    mapcenter = minimapCorner.size ? maps\mp\gametypes\_spawnlogic::findBoxCenter(minimapCorner[0].origin, minimapCorner[1].origin) : (0, 0, 0);
	    return (level.mapcenter[0], level.mapcenter[1], 0);
    }

	if (isDefined(level.mapCenter))
		return level.mapCenter;
	
	alliesStart = GetEntArray("mp_tdm_spawn_allies_start", "classname");
	axisStart = GetEntArray("mp_tdm_spawn_axis_start", "classname");		
	if (isDefined(alliesStart) && isDefined(alliesStart[0]) && isDefined(axisStart) && isDefined(axisStart[0]))
	{
		halfDist = Distance(alliesStart[0].origin, axisStart[0].origin) / 2;
		dir = vectorToAngles(alliesStart[0].origin - axisStart[0].origin);
		dir = vectorNormalize(dir);
		return alliesStart[0].origin + dir*halfDist;
	}
	return (0, 0, 0);	
}

fakeGravity(gravity)
{
    if (!isDefined(gravity)) gravity = 800;

    traceHeightOffset = (0, 0, 20);
    traceDepth = (0, 0, 2000);

	dropOrigin = playerPhysicsTrace(self.origin + traceHeightOffset, self.origin - traceDepth, 0, self);
	angleTrace = bulletTrace(self.origin + traceHeightOffset, self.origin - traceDepth, 0, self);

	if (angleTrace["fraction"] < 1 && distance(angleTrace["position"], dropOrigin) < 10)
	{
        yaw = self.angles[1];
		forward = (cos(yaw), sin(yaw), 0);
		forward = vectorNormalize(forward - angleTrace["normal"] * vectorDot(forward, angleTrace["normal"]));
		dropAngles = vectorToAngles(forward);
	}
	else dropAngles = (0, self.angles[1], 0);
    dropOrigin = (dropOrigin[0], dropOrigin[1], getGroundPosition(dropOrigin, 30)[2]);

    fallDistance = distance(self.origin, dropOrigin);
    fallTime = 0;

    if (gravity > 0 && fallDistance > 0.01)
    {
        fallTime = fallDistance / gravity;
        if (fallTime < 0.05) fallTime = 0.05;
    }
    else if (fallDistance <= 0.01) fallTime = 0;

    if (fallTime > 0)
    {
        self moveTo(dropOrigin, fallTime);
        wait fallTime;
    }
    else self.origin = dropOrigin;

    return fallTime;
}

spawn_model(origin, model)
{
    ent = spawn("script_model", origin);
	if (isDefined(model)) ent setModel(model);
    return ent;
}

get_current_dsr()
{
    mapRotation = getDvar("sv_mapRotation");
    if (mapRotation == "" || !lethalbeats\string::string_contains(mapRotation, "dsr")) return undefined;
    return strTok(mapRotation, " ")[1];
}

get_loadout_blank()
{
	NONE = "none";
	SPECIALTY_NULL = "specialty_null";
    loadout = [];
	loadout["loadoutPrimary"] = NONE;
	loadout["loadoutPrimaryAttachment"] = NONE;
	loadout["loadoutPrimaryAttachment2"] = NONE;
	loadout["loadoutPrimaryBuff"] = SPECIALTY_NULL;
	loadout["loadoutPrimaryCamo"] = NONE;
	loadout["loadoutPrimaryReticle"] = NONE;
	loadout["loadoutSecondary"] = NONE;
	loadout["loadoutSecondaryAttachment"] = NONE;
	loadout["loadoutSecondaryAttachment2"] = NONE;
	loadout["loadoutSecondaryBuff"] = SPECIALTY_NULL;
	loadout["loadoutSecondaryCamo"] = NONE;
	loadout["loadoutSecondaryReticle"] = NONE;
	loadout["loadoutEquipment"] = SPECIALTY_NULL;
	loadout["loadoutOffhand"] = SPECIALTY_NULL;
	loadout["loadoutPerk1"] = SPECIALTY_NULL;
	loadout["loadoutPerk2"] = SPECIALTY_NULL;
	loadout["loadoutPerk3"] = SPECIALTY_NULL;
	loadout["loadoutStreakType"] = SPECIALTY_NULL;
	loadout["loadoutKillstreak1"] = NONE;
	loadout["loadoutKillstreak2"] = NONE;
	loadout["loadoutKillstreak3"] = NONE;
	loadout["loadoutDeathstreak"] = SPECIALTY_NULL;
	loadout["loadoutJuggernaut"] = false;
	return loadout;
}

get_players(team, alives)
{
    return lethalbeats\player::players_get_list(team, alives);
}

get_players_by_string(target)
{
    return lethalbeats\player::players_by_string(target);
}

get_perks()
{
    return lethalbeats\perk::perk_get_list();
}

get_gametype_dvar(type)
{
    return getDvar("scr_" + level.gameType + "_" + type);
}

get_gametype_dvar_int(type)
{
    return getDvarInt("scr_" + level.gameType + "_" + type);
}

inOvertime()
{
    return isdefined(game["status"]) && game["status"] == "overtime";
}

getTimeLimit()
{
    if (inOvertime() && (!isdefined(game["inNukeOvertime"]) || !game["inNukeOvertime"]))
    {
        timeLimit = int(getdvar("overtimeTimeLimit"));

        if (isdefined(timeLimit))
        {
            return timeLimit;
            return;
        }

        return 1;
        return;
    }
    else if (isdefined(level.dd) && level.dd && isdefined(level.bombexploded) && level.bombexploded > 0)
        return getWatchedDvar("timelimit") + level.bombexploded * level.ddtimetoadd;
    else
        return getWatchedDvar("timelimit");
}

getHalfTime()
{
    if (inOvertime())
        return 0;
    else if (isdefined(game["inNukeOvertime"]) && game["inNukeOvertime"])
        return 0;
    else
        return getWatchedDvar("halftime");
}

getWatchedDvar(dvarString)
{
    dvarString = "scr_" + level.gametype + "_" + dvarString;

    if (isdefined(level.overridewatchdvars) && isdefined(level.overridewatchdvars[dvarString]))
        return level.overridewatchdvars[dvarString];

    return level.watchdvars[dvarString].value;
}

setObjectiveText(team, text)
{
    game["strings"]["objective_" + team] = text;
    precachestring(text);
}

setObjectiveScoreText(team, text)
{
    game["strings"]["objective_score_" + team] = text;
    precachestring(text);
}

setObjectiveHintText(team, text)
{
    game["strings"]["objective_hint_" + team] = text;
    precachestring(text);
}

registerWatchDvarInt(nameString, defaultValue)
{
    dvarString = "scr_" + level.gametype + "_" + nameString;
    level.watchdvars[dvarString] = spawnstruct();
    level.watchdvars[dvarString].value = getdvarint(dvarString, defaultValue);
    level.watchdvars[dvarString].type = "int";
    level.watchdvars[dvarString].notifystring = "update_" + nameString;
}

registerWatchDvarFloat(nameString, defaultValue)
{
    dvarString = "scr_" + level.gametype + "_" + nameString;
    level.watchdvars[dvarString] = spawnstruct();
    level.watchdvars[dvarString].value = getdvarfloat(dvarString, defaultValue);
    level.watchdvars[dvarString].type = "float";
    level.watchdvars[dvarString].notifystring = "update_" + nameString;
}

registerRoundLimitDvar(dvarString, defaultValue)
{
    registerWatchDvarInt("roundlimit", defaultValue);
}

registerWinLimitDvar(dvarString, defaultValue)
{
    registerWatchDvarInt("winlimit", defaultValue);
}

registerScoreLimitDvar(dvarString, defaultValue)
{
    registerWatchDvarInt("scorelimit", defaultValue);
}

registerTimeLimitDvar(dvarString, defaultValue)
{
    registerWatchDvarFloat("timelimit", defaultValue);
    makedvarserverinfo("ui_timelimit", getTimeLimit());
}

registerHalfTimeDvar(dvarString, defaultValue)
{
    registerWatchDvarInt("halftime", defaultValue);
    makedvarserverinfo("ui_halftime", getHalfTime());
}

registerNumLivesDvar(dvarString, defaultValue)
{ registerWatchDvarInt("numlives", defaultValue);
}

registerRoundSwitchDvar(dvarString, defaultValue, minValue, maxValue)
{
    registerWatchDvarInt("roundswitch", defaultValue);
    dvarString = "scr_" + dvarString + "_roundswitch";
    level.roundswitchdvar = dvarString;
    level.roundswitchmin = minValue;
    level.roundswitchmax = maxValue;
    level.roundswitch = getDvarInt(dvarString, defaultValue);

    if (level.roundswitch < minValue)
        level.roundswitch = minValue;
    else if (level.roundswitch > maxValue)
        level.roundswitch = maxValue;
}

setOverTimeLimitDvar(value)
{
    makedvarserverinfo("overtimeTimeLimit", value);
}

reInitializeMatchRulesOnMigration()
{
    for (;;)
    {
        level waittill("host_migration_begin");
        [[level.initializematchrules]]();
    }
}

streak_is_specialist(streakName)
{
    return maps\mp\killstreaks\_killstreaks::isSpecialistKillstreak(streakName); 
}

generate_id(prefix)
{
    if (!isDefined(level.id_counter)) level.id_counter = 0;
    level.id_counter++;
    time  = getTime();
    rand  = randomInt(1000000);
    id = int_to_base36((time * 100000000) + (level.id_counter * 1000) + rand);
    return isDefined(prefix) ? prefix + id : id;
}

int_to_base36(num)
{
    chars = "0123456789abcdefghijklmnopqrstuvwxyz";
    if (num <= 0) return "0";
    out = "";
    while (num > 0)
    {
        rem = num % 36;
        out = getSubStr(chars, rem, 1) + out;
        num = floor(num / 36);
    }
    return out;
}

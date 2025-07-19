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

waittill_any_return(notify1, notify2, notify3, notify4, notify5, notify6, notify7, notify8)
{
    if (!isDefined(level.waitills)) level.waitills = 0;

    level.waitills++;
    id = level.waitills;

    endon_msg = "endon" + id;
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
    self waittill(notify_msg);
    self notify(endon_msg, notify_msg);
}

wait_frame()
{
	wait(0.07);
}

get_map_center()
{
	if ( isDefined( level.mapCenter ) )
		return level.mapCenter;
	
	alliesStart = GetEntArray( "mp_tdm_spawn_allies_start", "classname" );
	axisStart = GetEntArray( "mp_tdm_spawn_axis_start", "classname" );		
	if ( isDefined( alliesStart ) && isDefined( alliesStart[0] ) && isDefined( axisStart ) && isDefined( axisStart[0] ) )
	{
		halfDist = Distance( alliesStart[0].origin, axisStart[0].origin ) / 2;
		dir = vectorToAngles( alliesStart[0].origin - axisStart[0].origin );
		dir = vectorNormalize( dir );
		return alliesStart[0].origin + dir*halfDist;
	}
	return (0,0,0);	
}

predictFallTime(origin, velDir, gravity, maxTime, timeStep)
{
    if (!isDefined(velDir)) velDir = (0, 0, 0);
    if (!isDefined(maxTime)) maxTime = 5;
    if (!isDefined(timeStep)) timeStep = 0.05;

    velDir = velDir;
    time = 0;
    maxLoops = int(maxTime / timeStep);

    for (i = 0; i < maxLoops; i++)
    {
        startPos = origin;
        origin += velDir * timeStep;
        velDir = (velDir[0], velDir[1], velDir[2] - gravity * timeStep);
        endPos = origin;

        trace = bulletTrace(startPos, endPos, false, self);
        if (trace["fraction"] < 1.0)
        {
            impactTime = time + (trace["fraction"] * timeStep);
            return impactTime;
        }
        time += timeStep;
    }

    return 0; 
}

fallTime(gravity)
{
    if (!isDefined(gravity)) gravity = 800;

    traceHeightOffset = (0, 0, 20);
    traceDepth = (0, 0, 2000);

    dropOrigin = playerPhysicsTrace(self.origin + traceHeightOffset, self.origin - traceDepth, 0, self);
    fallDistance = distance(self.origin, dropOrigin);
    fallTime = 0;

    if (gravity > 0 && fallDistance > 0.01) fallTime = sqrt(2 * fallDistance / gravity);
    return fallTime;
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

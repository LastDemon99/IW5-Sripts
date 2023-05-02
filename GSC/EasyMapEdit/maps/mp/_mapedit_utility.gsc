#include common_scripts\utility;
#include maps\mp\_utility;

spawnBuild(type, index)
{
	switch(level.buildData[index][0])
	{
		case "model": level.buildData[index]["ents"] = [spawnEnt(level.buildData[index][1], level.buildData[index][2], level.buildData[index][3])]; break;
		case "wall": level.buildData[index]["ents"] = createWall(level.buildData[index][1], level.buildData[index][2], 0); break;
		case "floor": level.buildData[index]["ents"] = createFloor(level.buildData[index][1], level.buildData[index][2], 0); break;
		case "ramp": level.buildData[index]["ents"] = createRamp(level.buildData[index][1], level.buildData[index][2], 0); break;
		case "hwall": level.buildData[index]["ents"] = createWall(level.buildData[index][1], level.buildData[index][2], 1); break;
		case "hfloor": level.buildData[index]["ents"] = createFloor(level.buildData[index][1], level.buildData[index][2], 1); break;
		case "hramp": level.buildData[index]["ents"] = createRamp(level.buildData[index][1], level.buildData[index][2], 1); break;
		case "tp": level.buildData[index]["ents"] = createTeleport(level.buildData[index][1], level.buildData[index][2], 0, level.buildData[index][3]); break;
		case "tp2": level.buildData[index]["ents"] = createTeleport(level.buildData[index][1], level.buildData[index][2], 1, level.buildData[index][3]); break;
		case "htp": level.buildData[index]["ents"] = createTeleport(level.buildData[index][1], level.buildData[index][2], 2, level.buildData[index][3]); break;
		case "platform": level.buildData[index]["ents"] = createPlatform(level.buildData[index][1], level.buildData[index][2], level.buildData[index][3]); break;
	}
}

createWall(start, end, invisible)
{
	crates = [];
	
	D = distance2D(start, end);
	H = distance((0, 0, start[2]), (0, 0, end[2]));
	
	blocks = ceil(D / 55);
	height = ceil(H / 30);

	C = end - start;
	A = (C[0] / blocks, C[1] / blocks, C[2] / height);
	
	TXA = A[0] / 4;
	TYA = A[1] / 4;
	
	angle = (0, VectorToAngles(C)[1], 90);	
	for (h = 0; h < height; h++)
	{
		crates[crates.size] = spawnCrate((start + (TXA, TYA, 10) + ((0, 0, A[2]) * h)), angle, invisible);
		for (i = 0; i < blocks; i++) crates[crates.size] = spawnCrate(start + ((A[0], A[1], 0) * i) + (0, 0, 10) + ((0, 0, A[2]) * h), angle, invisible);
		crates[crates.size] = spawnCrate((end[0], end[1], start[2]) + (TXA * -1, TYA * -1, 10) + ((0, 0, A[2]) * h), angle, invisible);
	}	
	
	return crates;
}

createFloor(corner1, corner2, invisible)
{
	crates = [];
	
    width = abs(corner1[0] - corner2[0]);
    length = abs(corner1[1] - corner2[1]);
            
    bwide = floor(width / 50);
    blength = floor(length / 30);
	
	if (bwide == 0) bwide = 1;
    if (blength == 0) blength = 1;
	
    C = corner2 - corner1;
	A = (ceil(C[0]) / bwide, ceil(C[1]) / blength, 0);
		
    A = (C[0] / bwide, C[1] / blength, 0);
 
    for (i = 0; i < bwide; ++i)
		for (j = 0; j < blength; ++j) crates[crates.size] = spawnCrate((corner1[0] + A[0] * i, corner1[1] + A[1] * j, corner1[2]), (0, 0, 0), invisible);
	
	return crates;
}

createRamp(top, bottom, invisible)
{
	crates = [];	
	distance = distance(top, bottom);
	blocks = ceil(distance / 30);
	A = ((top[0] - bottom[0]) / blocks, (top[1] - bottom[1]) / blocks, (top[2] - bottom[2]) / blocks);
	temp = vectorToAngles(top - bottom);
	BA = (temp[2], temp[1] + 90, temp[0]);
	for (b = 0; b <= blocks; b++) crates[crates.size] = spawnCrate(bottom + (A * b), BA, invisible);	
	return crates;
}

createTeleport(start, end, type, angles)
{
	ents = [];
	
	tpEnter = undefined;
	tpExit = undefined;
	
	if(type == 0)
	{
		startIndex = ents.size;
		ents[startIndex] = spawnEnt(start, getTeamFlagModel("allieschar"));
		ents[ents.size] = spawnEnt(end, getTeamFlagModel("axischar"));
	
		curObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
		ents[startIndex].objID = curObjID;
		objective_add(curObjID, "active");
		objective_position(curObjID, start);
		objective_icon(curObjID, "compass_waypoint_bomb");
	}
	else if (type == 1) ents[ents.size] = spawnEnt(start, "weapon_scavenger_grenadebag");
	
	trigger = spawn("trigger_radius", start, 0, 50, 50);
	trigger thread watchTeleport(end, angles);
	ents[ents.size] = trigger;	
	return ents;
}

watchTeleport(end, angles)
{
	level endon("game_ended");
	self endon("death");
	self.hasTrigger = 1;
	
	for (;;)
	{
		self waittill("trigger", player);
		
		player setOrigin(end);
		player setVelocity((0, 0, 0));
		player setPlayerAngles(angles);
	}
}

createPlatform(start, endOffset, rotY)
{
	crates = [];	
	crates[0] = spawn("script_origin", start + (0, 0, 45));	
	foreach(offset in [(28, 0, 0), (-28, 0, 0), (28, 30, 0), (-28, 30, 0), (28, -30, 0), (-28, -30, 0)])
	{
		index = crates.size;
		crates[index] = spawnCrate(start + offset, (0, 0, 0), 0);
		crates[index] linkTo(crates[0]);
	}	
	crates[0] rotateYaw(rotY, 0.05);
	crates[0] thread watchPlatform(endOffset);
	return crates;
}

watchPlatform(endOffset)
{
	level endon("game_ended");
	self endon("death");
	self.hasTrigger = 1;
	
	for (;;)
	{
		wait(10);
		self movePlatform(self.origin + endOffset, 5);
		wait(10);
		self movePlatform(self.origin - endOffset, 5);
	}
}

spawnCrate(origin, angles, invisible)
{
	crate = spawnEnt(origin, "com_plasticcase_friendly", angles);
	crate CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	if(invisible) crate hide();
	return crate;
}

spawnEnt(origin, model, angles)
{
	ent = undefined;	
	if (isDefined(model))
	{
		ent = spawn("script_model", origin);
		ent setModel(model);
	}
	else ent = spawn("script_origin", origin);
	if(isDefined(angles)) ent.angles = angles;
	return ent;
}

getTeamFlagModel(teamChar)
{
	return tableLookup("mp/factionTable.csv", 0, getMapCustom(teamChar), 10);
}

movePlatform(pos, speed)
{
	self moveTo(pos, speed);
	
	targets = [];
	foreach (player in level.players)
	{
		dist = distance(player.origin, self.origin);
		if (dist < 80)
		{
			traceData = bulletTrace(player.origin + (0, 0, 5), player.origin - (0, 0, 10), true, player);		
			if (isDefined(traceData["entity"]) && traceData["entity"].model == "com_plasticcase_friendly")
			{
				targets[targets.size] = player;
				player playerLinkTo(self);
				player playerLinkedOffsetEnable();
			}
		}
	}
	
	wait(speed);
	
	foreach (player in targets)
	{
		player setOrigin(player.origin + (0, 0, 20));
		player unLink();
	}
}
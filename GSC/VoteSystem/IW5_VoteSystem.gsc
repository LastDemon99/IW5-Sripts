/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : IW5_VoteSystem   |
|Creator : LastDemon99	   |
|Type : Addon              |
============================
*/

#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	loadData();
	
	level thread voteInit();	
	level thread credits();
	
	replacefunc(maps\mp\gametypes\_gamelogic::waittillFinalKillcamDone, ::onEndGame);	
}

voteInit()
{
	level endon( "end_game" );
	level waittill("vote_start");	
	
	level.votation = createVote();
	if(level.votation["hasEnabled"])
	{
		level.voteTime = level.votation["time"];
		level.voteMaps = level.votation["maps"];		
		level.voteDsr = level.votation["dsr"];
		level.voteMapsEnabled = level.votation["mapsEnabled"];
		level.voteDsrEnabled = level.votation["dsrEnabled"];
	}
	else
	{
		level notify("vote_end");
		return;
	}
	
	createVoteHud();	
	
	foreach(player in level.players)
		player thread playerVoteInit();
	
	level waittill("vote_end");
	
	winMap = [level.voteMaps[randomIntRange(0, level.voteMaps.size)], getDvar("g_gametype"), 0];
	MapRepeats = [];
	
	winDSR = [level.voteDsr[randomIntRange(0, level.voteDsr.size)], getDvar("g_gametype"), 0];
	DSRRepeats = [];
	
	if(level.voteMapsEnabled)
	{
		for (i = 0; i < level.voteMaps.size; i++)
			if(winMap[2] < level.voteMaps[i][2])
				winMap = level.voteMaps[i];
			
		for (i = 0; i < level.voteMaps.size; i++)
			if(winMap[2] == level.voteMaps[i][2])
				MapRepeats[MapRepeats.size] = level.voteMaps[i];
		
		if(MapRepeats.size > 0) winMap = MapRepeats[randomIntRange(0, MapRepeats.size)];
	}
	
	if(level.voteDsrEnabled)
	{
		for (i = 0; i < level.voteDsr.size; i++)
			if(winDSR[2] < level.voteDsr[i][2])
				winDSR = level.voteDsr[i];
			
		for (i = 0; i < level.voteDsr.size; i++)
			if(winDSR[2] == level.voteDsr[i][2])
				DSRRepeats[DSRRepeats.size] = level.voteDsr[i];
			
		if(DSRRepeats.size > 0) winDSR = DSRRepeats[randomIntRange(0, DSRRepeats.size)];
	}
		
	cmdexec("load_dsr " + winDSR[0]);
	wait(3);
	cmdexec("map " + winMap[0]);
}

playerVoteInit()
{
	if(self is_bot()) return;
		
	self endon( "disconnect" );
	level endon( "end_game" );
	level endon("vote_end");

	if(self.sessionteam == "spectator") return;
	
	self playlocalsound("elev_bell_ding");		
	
	self notifyonplayercommand("up", "+forward");
	self notifyonplayercommand("down", "+back");
	self notifyonplayercommand("select", "+activate");
	self notifyonplayercommand("melee", "+melee_zoom");		
	
	default_y = -155;
	
	index = 0;
	hasVoted = false;
	selected = [];
	
	if(level.voteMapsEnabled) 
	{
		voteType = "maps";
		default_y = -155;
		max_index = level.voteMaps.size - 1;
	}
	else 
	{
		voteType = "dsr";
		if(level.voteMapsEnabled) default_y = 5;
		max_index = level.voteDsr.size - 1;
	}
	
	for(;;) 
	{
		key = self waittill_any_return("up", "down", "select", "melee");	
		if(!hasVoted)
		{
			if(key == "up")
			{
				if(index > 0) index --;
				else index = max_index;
				
				self selectedSwitchFX(voteType, index, (0.5, 1, 0));
				self playlocalsound("mouse_over");					
			}
			else if(key == "down")
			{
				if(index < max_index) index++;
				else index = 0;
				
				self selectedSwitchFX(voteType, index, (0.5, 1, 0));
				self playlocalsound("mouse_over");	
			}
			else if (key == "select")
			{
				if(voteType == "maps")
				{
					selected["maps"] = index;
					level.voteMaps[index][2]++;					
					
					self selectedSwitchFX(voteType, index, (1, 0, 0));
					
					if(level.voteDsrEnabled) 
					{
						voteType = "dsr";
						index = 0;
					}
					else hasVoted = true;
				}
				else
				{
					selected["dsr"] = index;
					level.voteDsr[index][2]++;
					hasVoted = true;
					
					self selectedSwitchFX(voteType, index, (1, 0, 0));
				}
				self playlocalsound("recondrone_lockon");
			}
		}
		else self playlocalsound("elev_door_interupt");	
		
		if (key == "melee")
		{
			if((voteType == "maps" && hasVoted) || (level.voteDsrEnabled && voteType == "dsr" && !hasVoted))
			{
				level.voteMaps[selected["maps"]][2]--;	
				
				if(!level.voteDsrEnabled)
				{
					hasVoted = false;
					self selectedSwitchFX(voteType, index, (0.5, 1, 0));
				}
				else 
				{
					self selectedSwitchFX(voteType, index, (255, 255, 255));
					voteType = "maps";
					index = selected["maps"];
					selected["maps"] = undefined;
					self selectedSwitchFX(voteType, index, (0.5, 1, 0));		
				}
				self playlocalsound("mine_betty_click");
			}
			else if(voteType == "dsr" && hasVoted)
			{
				level.voteDsr[selected["dsr"]][2]--;
				index = selected["dsr"];
				selected["dsr"] = undefined;
				hasVoted = false;
				
				self selectedSwitchFX(voteType, index, (0.5, 1, 0));
				self playlocalsound("mine_betty_click");				
			}
		}
		
		if(voteType == "maps") 
		{
			default_y = -155;
			max_index = level.voteMaps.size - 1;
		}
		else 
		{
			if(level.voteMapsEnabled) default_y = 5;
			max_index = level.voteDsr.size - 1;
		}

		self.voteHud["navbar"].y = default_y + index * 20;
		self.voteHud["navbarShadow"].y = (default_y - 10) + index * 20;
	}
}

loadData()
{
	setDvarIfNotInizialized("vote_enable", 1);
	setDvarIfNotInizialized("vote_maps_count", 0);
	setDvarIfNotInizialized("vote_dsr_count", 0);
	setDvarIfNotInizialized("vote_time", 20);
	
	shaders = StrTok("background_image;gradient;gradient_fadein;gradient_top", ";");
    foreach(shader in shaders)
        PreCacheShader(shader);
		
	setDvarIfNotInizialized("vote_maps", "mp_plaza2;Arkaden:mp_mogadishu;Bakaara:mp_bootleg;Bootleg:mp_carbon;Carbon:mp_dome;Dome:mp_exchange;Downturn:mp_lambeth;Fallen:mp_hardhat;Hardhat:mp_interchange;Interchange:mp_alpha;Lockdown:mp_bravo;Mission:mp_radar;Outpost:mp_paris;Resistance:mp_seatown;Seatown:mp_underground;Underground:mp_village;Village");
	setDvarIfNotInizialized("vote_dsr", "");
}

onEndGame() 
{
    if (!IsDefined(level.finalkillcam_winner))
	{
	    if (isRoundBased() && !wasLastRound())
			return false;	
		wait 3;
		
		level notify("vote_start");
		level waittill("vote_end");		
        return false;
    }
	
    level waittill("final_killcam_done");
	if (isRoundBased() && !wasLastRound())
		return true;
	wait 3;

	level notify("vote_start");
	level waittill("vote_end");	
    return true;
}

createVote()
{
	voteItems = [];
	
	voteItems["hasEnabled"] = true;
	voteItems["mapsEnabled"] = true;
	voteItems["dsrEnabled"] = true;	
	voteItems["time"] = getDvarInt("vote_time");
	
	mapsCount = getDvarInt("vote_maps_count");
	dsrCount = getDvarInt("vote_dsr_count");
	
	if((mapsCount <= 1 && dsrCount <= 1) || (getDvar("vote_maps") == "" && getDvar("vote_dsr") == ""))
	{
		voteItems["hasEnabled"] = false;
		return voteItems;
	}
	
	voteData = dvarVoteDataToArray();
	
	if(getDvar("vote_maps") == "" || mapsCount <= 1) voteItems["mapsEnabled"] = false;
	if(getDvar("vote_dsr") == "" || dsrCount <= 1) voteItems["dsrEnabled"] = false;
	
	if(voteItems["mapsEnabled"]) 
	{
		if(mapsCount > 16) mapsCount = 16;		
		if(mapsCount > voteData["maps"].size) mapsCount = voteData["maps"].size;	
		if(mapsCount > 6 && voteItems["dsrEnabled"]) mapsCount = 6;
		
		voteItems["maps"] = []; //name, alias, votes
		mapsIndex = randomNum(mapsCount, 0, voteData["maps"].size);
		for(i = 0; i < mapsIndex.size; i++)
		{
			data = voteData["maps"][mapsIndex[i]];
			voteItems["maps"][i] = [data[0], data[1], 0];
		}
	}	
	
	if(voteItems["dsrEnabled"]) 
	{
		if(dsrCount > 16) dsrCount = 16;
		if (dsrCount > voteData["dsr"].size) dsrCount = voteData["dsr"].size;
		if(dsrCount > 6 && voteItems["mapsEnabled"]) dsrCount = 6;
		
		voteItems["dsr"] = []; //name, alias, votes
		dsrIndex = randomNum(dsrCount, 0, voteData["dsr"].size);
		for(i = 0; i < dsrIndex.size; i++)
		{
			data = voteData["dsr"][dsrIndex[i]];
			voteItems["dsr"][i] = [data[0], data[1], 0];
		}
	}
	
	return voteItems;
}

selectedSwitchFX(voteType, index, color)
{
	foreach(hud in self.voteHud[voteType])
	{
		hud.fontScale = 1.2;
		hud.color = (255, 255, 255);
	}
	
	self.voteHud[voteType][index].color = color;
	self.voteHud[voteType][index].fontScale += 0.2;
}

createVoteHud()
{
	level thread createVoteTimer();
	
	//create BG hud
	createHudText("^7Press [{+forward}] top up - Press [{+back}] to down - Press [{+activate}] to select option - Press [{+melee_zoom}] to undo select", "hudsmall", 0.8, "CENTER", "CENTER", 0, 210, false); 
	
	bg = createIconHud("background_image", "CENTER", "CENTER", 0, 0, 860, 480, (1,1,1), 1, 1, false); 
	bg.hideWhenInMenu = false;
	
	createIconHud("gradient_fadein", "CENTER", "CENTER", -125, 0, 1, 480, (0.48,0.51,0.46), 1, 3, false); 
	createIconHud("white", "RIGHT", "CENTER", -125, 0, 860, 480, (0,0,0), 0.4, 2, false); 
	createIconHud("gradient", "CENTER", "CENTER", -119, 0, 12, 480, (1,1,1), 0.5, 2, false); 
	
	createIconHud("gradient_fadein", "RIGHT", "CENTER", -125, -172, 220, 1, (0.48,0.51,0.46), 1, 3, false); 
	
	if(level.voteMapsEnabled && level.voteDsrEnabled)
		createIconHud("gradient_fadein", "RIGHT", "CENTER", -125, -12, 220, 1, (0.48,0.51,0.46), 1, 3, false); 	
	
	hudLastPosY =  -155;
	if(level.voteMapsEnabled) createHudText("^7VOTE MAP", "hudsmall", 1.4, "RIGHT", "CENTER", -151, -190, false); 	
	if(level.voteDsrEnabled && !level.voteMapsEnabled) createHudText("^7VOTE MODE", "hudsmall", 1.4, "RIGHT", "CENTER", -151, -190, false); 
	else if (level.voteDsrEnabled) createHudText("^7VOTE MODE", "hudsmall", 1.4, "RIGHT", "CENTER", -151, -30, false); 
	
	foreach(player in level.players)
		player thread createPlayerVoteHud();
}

createVoteTimer()
{
	soundFX = spawn("script_origin", (0,0,0));
	soundFX hide();
	
	timerhud = createTimer(level.voteTime, &"Vote end in: ", "hudsmall", 1.4, "RIGHT", "RIGHT", -50, 170);		
	for (i = getDvarInt("vote_time"); i > 0; i--)
	{
		timerhud.Color = (1, 1, 0);		
		if(i < 5) 
		{
			timerhud.Color = (1, 0, 0);
			soundFX playSound( "ui_mp_timer_countdown" );
		}
		wait(1);
	}	
	level notify("vote_end");
}

createPlayerVoteHud()
{
	hudLastPosY =  -155;
	self.voteHud = [];
	self.voteHud["navbar"] = self createIconHud("gradient_fadein", "RIGHT", "CENTER", -125, -155, 340, 20, (0,1,0), 0.3, 3, true);
	self.voteHud["navbarShadow"] = self createIconHud("gradient_top", "RIGHT", "CENTER", -125, -145, 340, 4, (0,0,0), 1, 2, true);	
	
	if(level.voteMapsEnabled)
	{
		for (i = 0; i < level.voteMaps.size; i++)
		{
			self.voteHud["maps"][i] = self createHudText(level.voteMaps[i][1], "objective", 1.2, "RIGHT", "CENTER", -151, hudLastPosY, true); 
			self.voteHud["mapsVote"][i] = self createHudText("[0/" + playersCount() + "]", "objective", 1.2, "RIGHT", "CENTER", -85, hudLastPosY, true); 
			hudLastPosY += 20;
		}
		hudLastPosY = 5;
	}
	
	if(level.voteDsrEnabled)
	{
		self.hudDsr = [];
		for (i = 0; i < level.voteDsr.size; i++)
		{
			self.voteHud["dsr"][i] = self createHudText(level.voteDsr[i][1], "objective", 1.2, "RIGHT", "CENTER", -151, hudLastPosY, true); 
			self.voteHud["dsrVote"][i] = self createHudText("[0/" + playersCount() + "]", "objective", 1.2, "RIGHT", "CENTER", -85, hudLastPosY, true);
			hudLastPosY += 20;
		}
	}
	
	self thread updateVotesHud();
}

updateVotesHud()
{
	self endon( "disconnect" );
	level endon( "end_game" );
	
	for(;;)
	{
		if(level.voteMapsEnabled)
		{
			for (i = 0; i < level.voteMaps.size; i++)
		self.voteHud["mapsVote"][i] setText("[" + level.voteMaps[i][2] + "/" + playersCount() + "]");
		}
		
		if(level.voteDsrEnabled)
		{
			for (i = 0; i < level.voteDsr.size; i++)
				self.voteHud["dsrVote"][i] setText("[" + level.voteDsr[i][2] + "/" + playersCount() + "]");
		}
		wait(0.1);
	}
}

randomNum(size, min, max)
{
	uniqueArray = [size];
	random = 0;

	for (i = 0; i < size; i++)
	{
		random = randomIntRange(min, max);
		for (j = i; j >= 0; j--)
			if (isDefined(uniqueArray[j]) && uniqueArray[j] == random)
			{
				random = randomIntRange(min, max);
				j = i;
			}
		uniqueArray[i] = random;
	}
	return uniqueArray;
}

createHudText(text, font, size, align, relative, x, y, isClient)
{
	if(isClient) hudText = self createFontString(font, size);
	else hudText = createServerFontString(font, size);
	
	hudText setpoint(align, relative, x, y);
	hudText setText(text); 
	hudText.alpha = 1;
	hudText.hideWhenInMenu = true;
	hudText.foreground = true;
	return hudText;
}

createIconHud(shader, align, relative, x, y, width, height, color, alpha, sort, isClient)
{
	if(isClient) hudIcon = self createIcon(shader, width, height);
	else hudIcon = createServerIcon(shader, width, height);
	
	hudIcon.align = align;
    hudIcon.relative = relative;
    hudIcon.width = width;
    hudIcon.height = height;    
	hudIcon.alpha = alpha;
	hudIcon.color = color;	
    hudIcon.hideWhenInMenu = true;
	hudIcon.hidden = false;
    hudIcon.archived = false;	
    hudIcon.sort = sort;    
    hudIcon setPoint(align, relative, x, y);
	hudIcon setParent(level.uiParent);
    return hudIcon;
}

createTimer(time, label, font, size, align, relative, x, y)
{
	timer = createServerTimer(font, size);	
	timer setpoint(align, relative, x, y);
	timer.label = label; 
	timer.alpha = 1;
	timer.hideWhenInMenu = true;
	timer.foreground = true;
	timer setTimer(time);
	
	return timer;
}

setDvarIfNotInizialized(dvar, value)
{
	result = getDvar(dvar);	
	if(!isDefined(result) || result == "")
		setDvar(dvar, value);
}

dvarVoteDataToArray()
{
	voteData = [];		
	
	if(getDvar("vote_maps") != "")
	{
		dataItems = StrTok(getDvar("vote_maps"), ":");	
		
		voteData["maps"] = [];		
		for(i = 0; i < dataItems.size; i++)
			voteData["maps"][i] = [StrTok(dataItems[i], ";")[0], StrTok(dataItems[i], ";")[1]];
	}
	
	if(getDvar("vote_dsr") != "")
	{
		dataItems = StrTok(getDvar("vote_dsr"), ":");	
		
		voteData["dsr"] = [];
		for(i = 0; i < dataItems.size; i++)
			voteData["dsr"][i] = [StrTok(dataItems[i], ";")[0], StrTok(dataItems[i], ";")[1]];				
	}
	
	return voteData;
}

playersCount()
{
	count = 0;
	foreach(player in level.players)
		if(!(player is_bot()))
			count++;
	return count;
}

is_bot()
{
	assert( isDefined( self ) );
	assert( isPlayer( self ) );

	return ( ( isDefined( self.pers["isBot"] ) && self.pers["isBot"] ) || ( isDefined( self.pers["isBotWarfare"] ) && self.pers["isBotWarfare"] ) || isSubStr( self getguid() + "", "bot" ) );
}

credits()
{
	for(;;) 
    {
		if(getDvar("vote_credits") != "Developed by LastDemon99")
			setDvar("vote_credits", "Developed by LastDemon99");		
		wait(0.35);
	}
}

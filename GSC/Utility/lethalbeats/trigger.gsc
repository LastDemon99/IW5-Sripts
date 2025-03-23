#include lethalbeats\array;
#include lethalbeats\hud;

#define PREFIX "trigger_"
#define TRIGGERS ["enter", "leave", "radius", "radius_hold", "use", "use_hold", "hold_complete"]

#define TRIGGER_ENTER 0
#define TRIGGER_LEAVE 1
#define TRIGGER_RADIUS 2
#define TRIGGER_RADIUS_HOLD 3
#define TRIGGER_USE 4
#define TRIGGER_USE_HOLD 5
#define TRIGGER_HOLD_COMPLETE 6

//////////////////////////////////////////
//	           PUBLIC UTILITY           //
//////////////////////////////////////////

/*
///DocStringBegin
detail: trigger_create(origin: <Vector>, radius: <Float | Undefined>, height: <Float | Undefined>, spawnflag: <Int | Undefined>): <Trigger>
summary: Creates a trigger at a specified origin with a given radius and initializes its properties.
///DocStringEnd
*/
trigger_create(origin, radius, height, spawnflag)
{
	if (!isDefined(radius)) radius = 35;
	if (!isDefined(height)) height = 35;
	if (!isDefined(spawnflag)) spawnflag = 0;

	trigger = spawn("trigger_radius", origin, spawnflag, radius, height);
	trigger.type = TRIGGER_RADIUS;
	trigger.tag = "none";
	trigger.showTo = level.players;
	trigger.showFilter = ::_filter_players_array;
	trigger.hasEntered = [];
	trigger thread _onPlayerEnter();

	return trigger;
}

trigger_set_hint_string(hintString)
{
	self.hintString = hintString;
}

/*
///DocStringBegin
detail: <Trigger> trigger_set_radius_hold(useTime: <Int>, hintString: <String>): <Void>
summary: Replace This.
///DocStringEnd
*/
trigger_set_radius_hold(useTime, hintString)
{
	self.hintString = hintString;
	self.type = TRIGGER_RADIUS_HOLD;
	self.useTime = useTime;
	self.pbarX = 0;
	self.pbarY = 25;
	self.curProgress = 0;
    self.inUse = true;
    self.useRate = 0;
}

trigger_set_use(hintString)
{
	self.hintString = hintString;
	self.type = TRIGGER_USE;
}

trigger_set_use_hold(useTime, hintString)
{
	self trigger_set_radius_hold(useTime, hintString);
	self.type = TRIGGER_USE_HOLD;
}

trigger_showTo(showTo)
{
	self.showTo = showTo;
	if (isString(self.showTo)) self.showFilter = ::_filter_team;
	else if (isPlayer(self.showTo)) self.showFilter = ::_filter_player;
	else if (isArray(self.showTo)) self.showFilter = ::_filter_players_array;
	else self.showFilter = ::_filter_blank;
}

/*
///DocStringBegin
detail: <Player> trigger_player_monitor(): <Void>
summary: Monitors a player's interaction with a trigger zone, handling enter, hold, and leave events.
///DocStringEnd
*/
trigger_player_monitor()
{
	level endon("game_ended");
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("trigger_enter", trigger);
		self _onPlayerTouching(trigger);
		trigger.hasEntered = array_remove(trigger.hasEntered, self);
		if (trigger [[trigger.showFilter]](self)) self _notifyTrigger(TRIGGER_LEAVE, trigger);
		if(isDefined(trigger.hintString))  self _playerClearHintString();
	}
}

trigger_delete()
{
	level endon("game_ended");
	self waittill("delete");
	
	foreach(player in level.players) 
		if (isDefined(player.onTrigger) && player.onTrigger == self)
		{
			player _playerClearHintString();
			player.onTrigger = undefined;
		}
	
	if (isDefined(self.icon3D)) 
		foreach(showTo in getarraykeys(self.icon3D)) self.icon3D[showTo] destroy();
	
	if (isDefined(self.icon2D)) 
		foreach(showTo in getarraykeys(self.icon2D)) maps\mp\_utility::_objective_delete(self.icon2D[showTo]);
	
	self delete();
}

//////////////////////////////////////////
//	            LOGIC   		        //
//////////////////////////////////////////s

_onPlayerEnter()
{
	level endon("game_ended");
	self endon("delete");
	self endon("is_look_at");

	for(;;)
	{
		self waittill("trigger", player);
		if (!self [[self.showFilter]](player) || array_contains(self.hasEntered, player)) continue;
		self.hasEntered[self.hasEntered.size] = player;
		player _notifyTrigger(TRIGGER_ENTER, self);
		if(isDefined(self.hintString)) player _playerShowHintString(self.hintString);
	}
}

_onPlayerTouching(trigger)
{
	while (self isTouching(trigger))
	{	
		if (trigger.type == TRIGGER_RADIUS)
		{
			if (!trigger [[trigger.showFilter]](self)) break;
			self _notifyTrigger(TRIGGER_RADIUS, self);
		}
		else if (trigger.type == TRIGGER_RADIUS_HOLD)
		{
			if (!(self _playerHoldThink(trigger)))
				return;
		}
		else if (trigger.type == TRIGGER_USE_HOLD)
		{
			if (self useButtonPressed() && !(self _playerHoldThink(trigger)))
				return;
		}
		else if (trigger.type == TRIGGER_USE)
		{
			if (self useButtonPressed())
			{
				while (self useButtonPressed())
					wait 0.05;
				self _notifyTrigger(TRIGGER_USE, trigger);
			}
		}
		wait 0.06;
	}
}

_playerShowHintString(text)
{
	hintString = hud_create_string(self, text, "hudbig", 0.6);
	hintString hud_set_point("center", "center", 0, 115);
	self.hintString = hintString;
}

_playerClearHintString()
{
	self.hintString hud_destroy_elem();
	self.hintString = undefined;
}

_playerHoldThink(trigger)
{    
	level endon("game_ended");
	self endon("disconnect");
	self endon("death");
	trigger endon("death");

	if (trigger.type == TRIGGER_USE_HOLD)
    {
		self playerLinkTo(trigger);
		self playerLinkedOffsetEnable();
    	self disableweapons();
		result = trigger _holdThink(trigger.type, self, ::_isButtonPressed);
	}
	else result = trigger _holdThink(trigger.type, self, ::_isTouching);

	if (result) wait 0.3;
	if (trigger.type == TRIGGER_USE_HOLD)
    {
		self enableWeapons();
		self unlink();
	}

	trigger.inUse = false;
    trigger.curProgress = 0; // make slow to 0 no just 0

	return result;
}

_holdThink(hold_type, player, condition)
{
	self endon("disconnect");

	self.useRate = 1; // speed handler
	useBar = hud_create_bar(self, 130, 12);
	useBar hud_set_point("center", "center", 0, 100);
	startTime = getTime();

	while(self [[condition]](player) && self.curProgress < self.useTime)
    {
		if (!self [[self.showFilter]](player))
		{
			useBar hud_destroy_elem();
			return false;
		}

		self _notifyTrigger(hold_type, self);
        self.curProgress += (50 * self.useRate);
		player _notifyTrigger(TRIGGER_RADIUS_HOLD, self);

		if (self.curProgress >= self.useTime)
		{
			self.curProgress = self.useTime;
			useBar hud_update_bar(self.curProgress / self.useTime, 1000 / self.useTime * self.useRate);
			player _notifyTrigger(TRIGGER_HOLD_COMPLETE, self);
		}
		else useBar hud_update_bar(self.curProgress / self.useTime, 1000 / self.useTime * self.useRate);
        wait 0.05;
    }

	useBar hud_destroy_elem();
    return self.curProgress == self.useTime;
}

//////////////////////////////////////////
//	         INTERNAL UTILITY           //
//////////////////////////////////////////

_isButtonPressed(player) { return player useButtonPressed(); }
_isTouching(player) { return player isTouching(self); }

_notifyTrigger(type, trigger)
{
	_triggers = TRIGGERS;
	type = PREFIX + _triggers[type];
	self notify(type, trigger);
	trigger notify(type, self);
}

trigger_set_2d_icon(showTo, shader)
{
	if (showTo == "all")
	{
		trigger_set_2d_icon("allies", shader);
		trigger_set_2d_icon("axis", shader);
		return;
	}
	
	objId = maps\mp\gametypes\_gameobjects::getNextObjID();
	objective_add(objId, "active", (0, 0, 0));
	objective_state(objId, "active");
	objective_position(objId, self.origin);
	objective_icon(objId, shader);
	
	if (isPlayer(showTo)) objective_player(objId, showTo);
	else objective_team(objId, showTo);
	
	if(!isDefined(self.icon2D)) self.icon2D = [];
	self.icon2D[showTo] = objId;
}

trigger_update_2d_icon(showTo, shader)
{
	if(!isDefined(self.icon2D[showTo])) return;
	objective_icon(self.icon2D[showTo], shader);
}

trigger_set_3d_icon(showTo, shader, height, width, targetEnt, offset)
{	
	if (isPlayer(showTo)) icon = newClientHudElem(showTo);
	else if (showTo == "all") icon = newHudElem();
	else icon = newTeamHudElem(showTo);
	
	icon setShader(shader, height, width);
	icon setWaypoint(true, true);
	
	if(!isDefined(targetEnt)) targetEnt = isDefined(offset) ? spawn("script_model", self.origin + offset) : self;	
	icon setTargetEnt(targetEnt);	
	
	if(!isDefined(self.icon3D)) self.icon3D = [];
	self.icon3D[showTo] = icon;
}

trigger_update_3d_icon(showTo, shader)
{
	if(!isDefined(self.icon3D[showTo])) return;
	icon = self.icon3D[showTo];
	icon setShader(shader, icon.height, icon.width);
}

_filter_blank(player) { return false; }
_filter_team(player) { return self.showTo == player.team; }
_filter_player(player) { return self.showTo == player; }
_filter_players_array(player) { return lethalbeats\array::array_contains(self.showTo, player); }

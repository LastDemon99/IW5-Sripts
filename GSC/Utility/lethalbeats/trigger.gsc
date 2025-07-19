#include lethalbeats\array;
#include lethalbeats\hud;
#include lethalbeats\player;

#define PREFIX "trigger_"
#define TRIGGERS ["enter", "leave", "radius", "radius_hold", "use", "use_hold", "hold_complete", "hold_interrump"]

#define TRIGGER_ENTER 0
#define TRIGGER_LEAVE 1
#define TRIGGER_RADIUS 2
#define TRIGGER_RADIUS_HOLD 3
#define TRIGGER_USE 4
#define TRIGGER_USE_HOLD 5
#define TRIGGER_HOLD_COMPLETE 6
#define TRIGGER_HOLD_INTERRUMP 7

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
	trigger.disabled = false;
	trigger.hasEntered = [];
	trigger.shareUse = true;
	trigger.onUseBehavior = 0; // 0: none, 1: disable, 2: remove
	trigger.inUseBy = undefined;
	trigger.showFilter = ::_filter_blank;
	trigger.tag = "";
	trigger.hintStringY = 130;
	trigger.hintStringAlpha = 1;
	trigger.collOrigin = origin;
	trigger thread _onTriggerPlayer();
	return trigger;
}

trigger_set_hint_string(hintString)
{
	self.hintString = hintString;
}

trigger_set_share_use(shareUse)
{
	self.shareUse = shareUse;
}

trigger_set_on_use_behavior(onUseBehavior)
{
	self.onUseBehavior = onUseBehavior;
}

/*
///DocStringBegin
detail: <Trigger> trigger_set_radius_hold(useTime: <Int>, hintString: <String>): <Void>
summary: Replace This.
///DocStringEnd
*/
trigger_set_radius_hold(useTime, hintString, shareUse)
{
	self.hintString = hintString;
	self.type = TRIGGER_RADIUS_HOLD;
	self.useTime = useTime;
	self.hintStringX = 0;
	self.hintStringY = 115;
	if (isDefined(shareUse)) self.shareUse = shareUse;
}

/*
///DocStringBegin
detail: trigger_set_use(hintString: <String>, shareUse?: <Bool | Undefined>, onUseBehavior?: <Int | Undefined>): <Void>
summary: Sets up a use trigger with a hint, shared access, and post-use behavior (0:none, 1:disable, or 2:remove).
///DocStringEnd
*/
trigger_set_use(hintString, shareUse, onUseBehavior)
{
	self.hintString = hintString;
	self.type = TRIGGER_USE;
	if (isDefined(shareUse)) self.shareUse = shareUse;
	if (isDefined(onUseBehavior)) self.onUseBehavior = onUseBehavior;
}

/*
///DocStringBegin
detail: trigger_set_use_hold(useTime: <Int>, hintString: <String>, shareUse?: <Bool | Undefined>, onUseBehavior?: <Int | Undefined>): <Void>
summary: Sets up a hold use trigger with a hint, shared access, and post-use behavior (0:none, 1:disable, or 2:remove).
///DocStringEnd
*/
trigger_set_use_hold(useTime, hintString, shareUse, onUseBehavior)
{
	self trigger_set_radius_hold(useTime, hintString);
	self.type = TRIGGER_USE_HOLD;
	if (isDefined(shareUse)) self.shareUse = shareUse;
	if (isDefined(onUseBehavior)) self.onUseBehavior = onUseBehavior;
}

trigger_player_waittill(type, tag)
{
	level endon("game_ended");
	self endon("disable");
	self endon("death");

	for(;;)
	{
		self waittill(type, trigger);
		if (isDefined(trigger) && isDefined(trigger.tag) && trigger.tag == tag) return trigger;
	}
}

trigger_disable()
{
	if(self.disabled) return;
	self.disabled = true;
	foreach(player in self.hasEntered)
	{
		if (!isDefined(player)) continue;
		player _playerTriggerDisable(self);
	}
	self.hasEntered = [];
	self notify("disable");
}

trigger_enable()
{
	self.disabled = false;
	self notify("enable");
}

_onTriggerPlayer()
{
	level endon("game_ended");
	self endon("death");

	for(;;)
	{
		if(self.disabled) self waittill("enable");

		self waittill("trigger", player);

		if (self.disabled || !isPlayer(player)) continue;
        if (!self [[self.showFilter]](player)) continue;
		
		if (!isDefined(player.touchingTriggers))
        {
            player thread _playerTriggerInit();
            wait 0.05;
        }

		self _triggerNotify(TRIGGER_RADIUS, player);
		if (array_contains(self.hasEntered, player)) continue;
		else self _triggerNotify(TRIGGER_ENTER, player);
	}
}

_playerTriggerInit()
{
	if (isDefined(self.touchingTriggers)) return;
	self.touchingTriggers = [];
	self thread _playerTriggerManager();
	self thread _playerLeaveMonitor();
}

_playerLeaveMonitor()
{
	self endon("disconnect");
	
	for(;;)
	{
		wait 0.2;
		triggersToCheck = self.touchingTriggers;
		foreach(trigger in triggersToCheck)
		{
			if(!isDefined(trigger) || !self isTouching(trigger))
			{
				if(isDefined(trigger)) trigger _triggerNotify(TRIGGER_LEAVE, self);
				else self _playerTriggerDisable(trigger);
			}
		}
	}
}

_playerTriggerDisable(trigger)
{
	if (isDefined(self.touchingTriggers)) self.touchingTriggers = array_remove(self.touchingTriggers, trigger);
	self _playerClearHintString();
	self _playerClearUseBar();
}

_playerTriggerManager()
{
	self endon("disconnect");
	self.isUsingTrigger = false;

    for (;;)
    {
        wait 0.1;
		
		if(self.isUsingTrigger) continue;
		
        closestTrigger = undefined;
        closestDistSq = 99999999;
		enablePickup = true;
		
		triggersToCheck = self.touchingTriggers; 

        foreach (trigger in triggersToCheck)
        {
			if (!isDefined(trigger))
			{
				self _playerTriggerDisable(trigger); 
				continue;
			}
			if(trigger.disabled) continue;
			
			if (!trigger [[trigger.showFilter]](self)) continue;
			if (!trigger.shareUse && isDefined(trigger.inUseBy) && trigger.inUseBy != self) continue;

			if (trigger.type == TRIGGER_USE || trigger.type == TRIGGER_USE_HOLD)
			{
				if(isDefined(trigger.hintString))
				{
					self disableweaponPickup();
					enablePickup = false;
				}
			}

            if (!isDefined(trigger.hintString)) continue;
			
            distSq = distanceSquared(self.origin, trigger.origin);
            if (distSq < closestDistSq)
            {
                closestDistSq = distSq;
                closestTrigger = trigger;
            }
        }
		if (enablePickup) self enableWeaponPickup();
		
		if (isDefined(closestTrigger))
		{
			self _playerShowHintString(closestTrigger);
			
			if (self useButtonPressed())
			{
				if (closestTrigger.type == TRIGGER_USE_HOLD)
				{
					self.isUsingTrigger = true;
					self _playerHoldThink(closestTrigger);
					self.isUsingTrigger = false;
				}
				else if (closestTrigger.type == TRIGGER_USE)
				{
					while(self useButtonPressed())
						wait 0.05;
					closestTrigger _triggerNotify(TRIGGER_USE, self);
				}
			}
		}
		else self _playerClearHintString();
    }
}

_playerShowHintString(trigger)
{
	if(isDefined(self.hintString) && isDefined(self.hintString.trigger) && self.hintString.trigger == trigger) return;
	self _playerClearHintString();
	hintString = hud_create_string(self, trigger.hintString, "hudbig", 0.6);
	hintString hud_set_point("center", "center", trigger.hintStringX, trigger.hintStringY);
	hintString.trigger = trigger;
	self.hintString = hintString;
	self.hintString.alpha = trigger.hintStringAlpha;
}

_playerClearHintString()
{
	if (!isDefined(self.hintString)) return;
	self.hintString hud_destroy();
	self.hintString = undefined;
}

_playerShowUseBar(trigger)
{
	if(isDefined(self.useBar) && isDefined(self.useBar.trigger) && self.useBar.trigger == trigger) return;
	self _playerClearUseBar();
	useBar = hud_create_bar(self, 130, 12);
	useBar hud_set_point("center", "center", 0, 100);
	useBar.trigger = trigger;
	self.useBar = useBar;
	self player_disable_weapons();
	self player_disable_usability();

	self.useBar.spot = spawn("script_origin", self.origin);
	self.useBar.spot.angles = self.angles;
	self.useBar.spot hide();
	self playerLinkTo(self.useBar.spot);
}

_playerClearUseBar()
{
	if (!isDefined(self.useBar)) return;

	self unlink();
	self.useBar.spot delete();
	self.useBar hud_destroy();
	self.useBar = undefined;
	self player_enable_weapons();
	self player_enable_usability();
}

_playerHoldThink(trigger)
{
	self endon("disconnect");
	trigger endon("death");
	trigger endon("disable");

	if (trigger.type == TRIGGER_USE_HOLD)
    {
		self playerLinkTo(trigger);
		self playerLinkedOffsetEnable();
    	self player_disable_weapons();
	}

	result = trigger _holdThink(self, (trigger.type == TRIGGER_USE_HOLD) ? ::_isButtonPressed : ::_isTouching);

	self player_enable_weapons();
	self player_enable_usability();
	self unlink();

	return result;
}

_holdThink(player, condition)
{
	if (!self.shareUse)
	{
		if (isDefined(self.inUseBy)) return false;
		else self.inUseBy = player;
	}

	player _playerShowUseBar(self);
	self _triggerNotify(TRIGGER_USE_HOLD, player);

    startTime = getTime();
    endTime = startTime + (self.useTime * 1000);

	while (getTime() < endTime)
    {
		if (!self [[condition]](player) || !self [[self.showFilter]](player))
		{
			player _playerClearUseBar();
			self _triggerNotify(TRIGGER_HOLD_INTERRUMP, player);
			if(!self.shareUse) self.inUseBy = undefined;
			return false;
		}
		
		elapsedTime = getTime() - startTime;
		barFrac = elapsedTime / (elapsedTime + (endTime - getTime()));	
		if(isDefined(player.useBar)) player.useBar hud_update_bar(barFrac, 0);
		
		wait 0.05;
    }

	player _playerClearUseBar();
	self _triggerNotify(TRIGGER_HOLD_COMPLETE, player);
	if(!self.shareUse) self.inUseBy = undefined;
    return true;
}

_triggerNotify(type, player)
{
	if (!isDefined(self)) return;

	switch(type)
	{
		case TRIGGER_ENTER:
			self.hasEntered = array_append(self.hasEntered, player);
            if(isDefined(player.touchingTriggers)) player.touchingTriggers = array_append(player.touchingTriggers, self);
			break;
		case TRIGGER_LEAVE:
			self.hasEntered = array_remove(self.hasEntered, player);
			player _playerTriggerDisable(self);
			break;
		case TRIGGER_USE:
		case TRIGGER_HOLD_COMPLETE:
			if (self.onUseBehavior == 1) self trigger_disable();
			else if (self.onUseBehavior == 2) self delete();
			break;
		case TRIGGER_USE_HOLD:
        case TRIGGER_HOLD_INTERRUMP:
			break;
	}

	_triggers = TRIGGERS;
	typeString = PREFIX + _triggers[type];

	self notify(typeString, player);
	player notify(typeString, self);
}

_isButtonPressed(player) { return player useButtonPressed(); }
_isTouching(player) { return player isTouching(self); }
_filter_blank(player) { return true; }
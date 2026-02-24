#include lethalbeats\array;
#include lethalbeats\hud;
#include lethalbeats\player;
#include lethalbeats\collider;

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
detail: trigger_create(origin: <Vector>, radius: <Float | Undefined>, height: <Float | Undefined>): <Trigger>
summary: Creates a virtual trigger `spawnstruct`, non spawn entity.
///DocStringEnd
*/
trigger_create(origin, radius, height)
{
	if (!isDefined(radius)) radius = 35;

	trigger = spawnstruct();
	trigger.origin = origin;
	trigger.radius = radius;
	trigger.height = height;
	trigger.tag = "";
	trigger.type = TRIGGER_RADIUS;
	trigger.shareUse = true;
	trigger.hasEntered = [];
	trigger.inUseBy = [];
	trigger.hintStringY = 130;
	trigger.hintStringAlpha = 1;
	trigger.customEnableCondition = undefined;
	trigger.customUseEnableCondition = undefined;
	trigger.disabled = false;
	trigger _triggerInit();

	return trigger;
}

/*
///DocStringBegin
detail: trigger_set_use(hintString?: <String> | <Undefined>): <Void>
summary: 
///DocStringEnd
*/
trigger_set_use(hintString)
{
	self.hintString = hintString;
	self.type = TRIGGER_USE;
	if (isDefined(hintString)) self.hintString = hintString;
}

/*
///DocStringBegin
detail: trigger_set_use_hold(useTime: <Int>, hintString?: <String> | <Undefined>, useBar?: <Bool | Undefined>, shareUse?: <Bool | Undefined = true>): <Void>
summary: Sets up a hold-to-use trigger with an optional hint, use bar, shared use.
///DocStringEnd
*/
trigger_set_use_hold(useTime, hintString, useBar, shareUse)
{
	self trigger_set_radius_hold(useTime, hintString, useBar, shareUse);
	self.type = TRIGGER_USE_HOLD;
}

/*
///DocStringBegin
detail: trigger_set_radius_hold(useTime: <Int>, hintString?: <String> | <Undefined>, useBar?: <Bool | Undefined>, shareUse?: <Bool | Undefined = true>): <Void>
summary: Sets up a radius_hold trigger, allowing timed interaction within the radius, with options for hint, use bar, shared use, and activation only by the closest trigger.
///DocStringEnd
*/
trigger_set_radius_hold(useTime, hintString, useBar, shareUse)
{
	if (!isDefined(useBar)) useBar = true;
	if (!isDefined(shareUse)) shareUse = true;

	self.type = TRIGGER_RADIUS_HOLD;
	self.useTime = useTime;
	self.hintStringX = 0;
	self.hintStringY = 115;
	self.hintString = hintString;
	self.useBar = useBar;
	self.shareUse = shareUse;
}

trigger_set_hint_string(hintString)
{
	self.hintString = hintString;
}

trigger_set_enable_condition(condition)
{
	self.customEnableCondition = condition;
}

trigger_set_enable_use_condition(condition)
{
	self.customUseEnableCondition = condition;
}

trigger_enable_share(share)
{
    self.shareUse = share;
}

trigger_disable()
{
	self.disabled = true;
	foreach(player in self.hasEntered)
		if (isDefined(player.closestTrigger) && player.closestTrigger == self)
			player _playerClearClosestTrigger();
	self.hasEntered = [];
	self notify("disable");
}

trigger_enable()
{
	self.disabled = false;
	self notify("trigger_enable");
}

trigger_delete()
{
	self trigger_disable();
	if (isDefined(level.triggers)) level.triggers = lethalbeats\array::array_remove(level.triggers, self);
	self notify("death");
}

trigger_link_to(entity, offset) { self thread _trigger_link_to(entity, offset); }
_trigger_link_to(entity, offset)
{
	self endon("unlink");
	self endon("death");

	for(;;)
	{
		self.origin = isDefined(offset) ? entity.origin + offset : entity.origin;
		wait 0.02;
	}
}

trigger_unlink()
{
	self notify("unlink");
}

trigger_is_touching(player)
{
	if (isDefined(self.height)) return lethalbeats\collider::pointInCylinder(player maps\mp\_utility::getStanceCenter(), self.origin, self.radius, self.height);
	else return lethalbeats\collider::pointInSphere(player maps\mp\_utility::getStanceCenter(), self.origin, self.radius);
}

_triggerInit()
{
	if (!isDefined(level.triggers))
	{
		level.triggers = [];
		foreach(player in level.players) player thread _onPlayerTriggerUse();
		waittillframeend;
		
		level thread _onPlayerConnect();
		level thread _triggerMainLoop();
	}
	level.triggers[level.triggers.size] = self;
}

_triggerMainLoop()
{
	level endon("game_ended");

	for(;;)
	{
		foreach(trigger in level.triggers)
		{
			if (!isDefined(trigger) || trigger.disabled) continue;

			foreach(player in level.players)
			{
				if (!isDefined(player) || !isAlive(player)) continue;

				hasEntered = lethalbeats\array::array_contains(trigger.hasEntered, player);
				isTouching = trigger trigger_is_touching(player);

				if (!isTouching && !hasEntered) continue;
				
				if (!trigger _isEnableTo(player))
				{
					if (hasEntered)
					{
						trigger.hasEntered = lethalbeats\array::array_remove(trigger.hasEntered, player);
						trigger _triggerNotify(TRIGGER_LEAVE, player);
						if (isDefined(player.closestTrigger) && player.closestTrigger == trigger) player _playerClearClosestTrigger();
					}
					continue;
				}

				if (isTouching)
				{
					if (trigger _isUseEnableTo(player))
					{
						if (!isDefined(player.closestTrigger))
						{
							player.closestTrigger = trigger;
							if (isDefined(trigger.hintString)) player _playerShowHintString(trigger.hintString, trigger.hintStringAlpha, trigger.hintStringX, trigger.hintStringY);
						}
						else if (player.closestTrigger != trigger && distanceSquared(player.origin, player.closestTrigger.origin) > distanceSquared(player.origin, trigger.origin))
						{
							player.closestTrigger = trigger;
							if (isDefined(trigger.hintString)) player _playerShowHintString(trigger.hintString, trigger.hintStringAlpha, trigger.hintStringX, trigger.hintStringY);
						}
					}
					else if (isDefined(player.closestTrigger) && player.closestTrigger == trigger)
					{
						player _playerClearClosestTrigger();
					}

					trigger _triggerNotify(TRIGGER_RADIUS, player);

					if (!hasEntered)
					{
						trigger.hasEntered[trigger.hasEntered.size] = player;
						trigger _triggerNotify(TRIGGER_ENTER, player);
						if (trigger.type == TRIGGER_RADIUS_HOLD) player thread _playerHoldMonitor(trigger, ::trigger_is_touching);
					}
				}
				else if (hasEntered)
				{
					trigger.hasEntered = lethalbeats\array::array_remove(trigger.hasEntered, player);
					trigger _triggerNotify(TRIGGER_LEAVE, player);
					if (isDefined(player.closestTrigger) && player.closestTrigger == trigger) player _playerClearClosestTrigger();
				}
			}
		}
		wait 0.05;
	}
}

_onPlayerConnect()
{
    level endon("game_ended");

    for (;;)
    {
        level waittill("connected", player);
        player thread _onPlayerTriggerUse();
    }
}

_onPlayerTriggerUse()
{
	self endon("disconnect");

	self notifyOnPlayerCommand("key_down", "+activate");
	self notifyOnPlayerCommand("key_down2", "+usereload");
	self notifyOnPlayerCommand("key_up", "-activate");
	self notifyOnPlayerCommand("key_up2", "-activate");

	for(;;)
	{
		self lethalbeats\utility::waittill_any("key_down", "key_down2");
		if (!self useButtonPressed()) continue;
		if (!isDefined(self.closestTrigger)) continue;

		trigger = self.closestTrigger;
		if (!trigger _isUseEnableTo(self)) continue;
		if (!trigger.shareUse && trigger.inUseBy.size) continue;
		if (!array_contains(trigger.inUseBy, self)) trigger.inUseBy[trigger.inUseBy.size] = self;

		if (trigger.type == TRIGGER_USE)
		{
			trigger _triggerNotify(TRIGGER_USE, self);
			trigger.inUseBy = array_remove(trigger.inUseBy, self);
			self lethalbeats\utility::waittill_any("key_up", "key_up2");
		}
		else if (trigger.type == TRIGGER_USE_HOLD)
			self _playerHoldMonitor(trigger, ::_isButtonPressed);
	}
}

_playerHoldMonitor(trigger, condition)
{
	self.isHoldingTrigger = true;
	if (isDefined(trigger.useBar)) self _playerShowUseBar(trigger);

	trigger _triggerNotify(TRIGGER_USE_HOLD, self);

	holdElapsed = 0;
	holdStep = 0.05;
	while (holdElapsed < trigger.useTime)
	{
		if (!trigger [[condition]](self))
		{
			trigger _triggerNotify(TRIGGER_HOLD_INTERRUMP, self);
			if (isDefined(trigger.useBar)) self _playerClearUseBar();
			trigger.inUseBy = array_remove(trigger.inUseBy, self);
			self.isHoldingTrigger = undefined;
			return;
		}

		/* pause bar
		if (!trigger _isUseTimeEnabled(player))
		{
			barFrac = holdElapsed / trigger.useTime;
			if(isDefined(player.useBar)) player.useBar hud_update_bar(barFrac, 0);
			wait holdStep;
			continue;
		}*/

		holdElapsed += holdStep;
		barFrac = holdElapsed / trigger.useTime;
		if(isDefined(self.useBar)) self.useBar hud_update_bar(barFrac, 0);
		wait holdStep;
	}

	trigger _triggerNotify(TRIGGER_HOLD_COMPLETE, self);
	if (isDefined(trigger.useBar)) self _playerClearUseBar();
	trigger.inUseBy = array_remove(trigger.inUseBy, self);
	self.isHoldingTrigger = undefined;
}

_triggerNotify(type, player)
{
	if (!isDefined(self)) return;
	_triggers = TRIGGERS;
	typeString = PREFIX + _triggers[type];
	self notify(typeString, player);
	player notify(typeString, self);
}

_playerClearClosestTrigger(trigger)
{
	self.closestTrigger = undefined;
	self _playerClearHintString();
	self _playerClearUseBar();
}

_playerShowHintString(hintString, hintStringAlpha, hintStringX, hintStringY)
{
	if (!isDefined(hintStringAlpha)) hintStringAlpha = 1;
	if (!isDefined(hintStringX)) hintStringX = 0;
	if (!isDefined(hintStringY)) hintStringY = 130;

	self _playerClearHintString();
	self.hintString = hud_create_string(self, hintString, "hudbig", 0.6);
	self.hintString hud_set_point("center", "center", hintStringX, hintStringY);
	self.hintString.alpha = hintStringAlpha;
}

_playerClearHintString()
{
	if (!isDefined(self.hintString)) return;
	self.hintString hud_destroy();
	self.hintString = undefined;
}

_playerShowUseBar(trigger)
{
	self _playerClearUseBar();
	self.useBar = hud_create_bar(self, 130, 12);
	self.useBar hud_set_point("center", "center", 0, 100);

	if (trigger.type == TRIGGER_USE_HOLD)
	{
		self.useBar.spot = spawn("script_origin", self.origin);
		self.useBar.spot.angles = self.angles;
		self.useBar.spot hide();
		self playerLinkTo(self.useBar.spot);
		self playerLinkedOffsetEnable();
		self player_disable_weapons();
		self player_disable_usability();
	}
}

_playerClearUseBar()
{
	if (!isDefined(self.useBar)) return;

	if (isDefined(self.useBar.spot))
	{
		self unlink();
		self.useBar.spot delete();
		self player_enable_weapons();
		self player_enable_usability();
	}

	self.useBar hud_destroy();
	self.useBar = undefined;
}

_isEnableTo(player) 
{ 
	if (!isAlive(player)) return false;
	if (!isDefined(self.customEnableCondition)) return true;
	return self [[self.customEnableCondition]](player);
}

_isUseEnableTo(player) 
{ 
	if (!isAlive(player)) return false;
	if (isDefined(player.disabledusability) && !isDefined(player.isHoldingTrigger) && player.disabledusability) return false;
	if (!isDefined(self.customUseEnableCondition)) return true;
	return self [[self.customUseEnableCondition]](player);
}

_isButtonPressed(player) { return player useButtonPressed(); }

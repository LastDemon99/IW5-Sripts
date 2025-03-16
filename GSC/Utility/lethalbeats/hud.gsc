/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : hud              |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

#define IN_FRAMES 0.132
#define OUT_FRAMES 0.264

/*
///DocStringBegin
detail: hud_create_elem(target: <Player> | <String>, elemType: <String>, align: <String>, relative: <String>, x: <Float>, y: <Float>): <HudElement>
summary: Create and returns hud element based on level, player or team. Initializes HUD element with common properties and returns it. Specific properties can be set in the calling functions.
///DocStringEnd
*/
hud_create_elem(target, elemType, align, relative, x, y) 
{    
    if (isPlayer(target)) hudElem = newClientHudElem(target);
	else if (isString(target)) hudElem = newTeamHudElem(target);
	else hudElem = newhudelem();
	
    hudElem.target = target;
    if (isDefined(elemType)) hudElem.elemType = elemType;
    hudElem.x = 0;
    hudElem.y = 0;
    hudElem.width = 0;
    hudElem.height = 0;
    hudElem.xOffset = 0;
    hudElem.yOffset = 0;
    hudElem.children = [];
    hudElem hud_set_parent(level.uiParent);
    hudElem.hidden = false;
    hudElem.alpha = 1;
    hudElem.hideWhenInMenu = true;
    hudElem.foreground = true;
    if (isDefined(align) && isDefined(relative) && isDefined(x) && isDefined(y)) hudElem hud_set_point(align, relative, x, y);
    return hudElem;
}

/*
///DocStringBegin
detail: hud_create_timer(target: <Player> | <String>, time: <Int>, font: <String>, size: <Float>, align: <String>, relative: <String>, x: <Float>, y: <Float>): <HudElement>
summary: Creates a HUD timer element with specified properties and returns it. The timer is displayed on the screen with the given font, size, alignment, and position.
///DocStringEnd
*/
hud_create_timer(target, time, font, size, align, relative, x, y) 
{
    timer = hud_create_elem(target, "timer", align, relative, x, y);
    timer.font = font;
    timer.fontscale = size;
    timer.basefontscale = size;
    timer.height = int(level.fontheight * size);
    timer setTimer(time);
    return timer;
}

/*
///DocStringBegin
detail: hud_create_string(target: <Player> | <String>, text: <String>, font: <String>, size: <Float>, align: <String>, relative: <String>, x: <Float>, y: <Float>): <HudElement>
summary: Creates a player HUD string element with specified properties and returns it. The string is displayed on the screen with the given text, font, size, alignment, and position.
///DocStringEnd
*/
hud_create_string(target, text, font, size, align, relative, x, y) 
{
    hudText = hud_create_elem(target, "font", align, relative, x, y);
    hudText.font = font;
    hudText.fontscale = size;
    hudText.baseFontScale = size;
    hudText.height = int(level.fontHeight * size);
    hudText setText(text);
    return hudText;
}

/*
///DocStringBegin
detail: hud_create_icon(target: <Player> | <String>, shader: <String>, align: <String>, relative: <String>, x: <Float>, y: <Float>, width: <Float>, height: <Float>): <HudElement>
summary: Creates a HUD icon element with specified properties and returns it. The icon is displayed on the screen with the given shader, alignment, position, size, color, and other properties.
///DocStringEnd
*/
hud_create_icon(target, shader, align, relative, x, y, width, height) 
{
    hudIcon = hud_create_elem(target, "icon", align, relative, x, y);
    hudIcon.width = width;
    hudIcon.height = height;
    hudIcon.baseWidth = width;
    hudIcon.baseHeight = height;

    if (isDefined(shader)) 
    {
        hudIcon setShader(shader, width, height);
        hudIcon.shader = shader;
    }
    return hudIcon;
}

hud_create_bar(target, color, width, height, flashFrac, selected)
{
    bar = hud_create_elem(target);
    bar.frac = 0;
    bar.color = color;
    bar.sort = -2;
    bar.shader = "progress_bar_fill";
    bar setshader("progress_bar_fill", width, height);

    if (isdefined(flashFrac)) bar.flashfrac = flashFrac;

    barBg = hud_create_elem(target, "bar");
    barBg.width = width;
    barBg.height = height;
    barBg.bar = bar;
    barBg.sort = -3;
    barBg.color = (0, 0, 0);
    barBg.alpha = 0.5;
    barBg setshader("progress_bar_bg", width, height);
    return barBg;
}

/*
///DocStringBegin
detail: hud_create_countdown_center(countTime: <Int>, endNotify?: <String>): <Void>
summary: Creates a countdown timer from the specified time in the center of the screen. When the countdown ends, a notify is sent. Blocks execution flow, you should consider using a thread.
///DocStringEnd
*/
hud_create_countdown_center(target, countTime, endNotify)
{
	countdown = hud_create_string(target, "", "hudbig", 1, "CENTER", "CENTER", 0, 0);
	countdown hud_set_countdown(countTime, "ui_mp_timer_countdown", endNotify, true);
}

/*
///DocStringBegin
detail: hud_create_countdown(target: <Player> | <String>, countTime: <Int>, sound?: <String>, endNotify?: <String>, pulseEffect?: <Bool>): <Void>
summary: Start a countdown timer from the specified time. When the countdown ends, a notify is sent. Blocks execution flow, you should consider using a thread.
///DocStringEnd
*/
hud_set_countdown(countTime, sound, endNotify, pulseEffect)
{
	if (!isDefined(endNotify)) endNotify = "countdown_end";
	if (!isDefined(pulseEffect)) pulseEffect = false;
	else if (pulseEffect) self hud_init_pulse_effect();

	self setValue(countTime);

	while (countTime > 0)
	{
		if (isDefined(sound))
		{
			if (isPlayer(self.target)) self.target playLocalSound(sound);
			else lethalbeats\player::players_play_sound(sound, self.target);
		}
		
		if (pulseEffect) self thread hud_effect_font_Pulse(level);
		wait IN_FRAMES;
		self setValue(countTime);
		countTime--;
		wait (1 - IN_FRAMES);
	}
	self destroy();
	level notify(endNotify, self.target);
}

hud_set_parent(element)
{
    if (isdefined(self.parent) && self.parent == element) return;
    if (isdefined(self.parent)) self.parent hud_remove_child(self);

    self.parent = element;
    self.parent hud_add_child(self);

    if (isdefined(self.point)) hud_set_point(self.point, self.relativepoint, self.xoffset, self.yoffset);
    else hud_set_point("TOPLEFT");
}

hud_add_child(element)
{
	element.index = self.children.size;
	self.children[self.children.size] = element;
}

hud_remove_child(element)
{
    element.parent = undefined;

    if (self.children[self.children.size - 1] != element)
    {
        self.children[element.index] = self.children[self.children.size - 1];
        self.children[element.index].index = element.index;
    }

    self.children[self.children.size - 1] = undefined;
    element.index = undefined;
}

hud_update_child()
{
    for (i = 0; i < self.children.size; i++)
    {
        child = self.children[i];
        child hud_set_point(child.point, child.relativepoint, child.xoffset, child.yoffset);
    }
}

hud_set_point(point, relativePoint, xOffset, yOffset, moveTime)
{
    if (!isdefined(moveTime))
        moveTime = 0;

    element = self.parent;

    if (moveTime)
        self moveovertime(moveTime);

    if (!isdefined(xOffset))
        xOffset = 0;

    self.xoffset = xOffset;

    if (!isdefined(yOffset))
        yOffset = 0;

    self.yoffset = yOffset;
    self.point = point;
    self.alignx = "center";
    self.aligny = "middle";

    if (issubstr(point, "TOP"))
        self.aligny = "top";

    if (issubstr(point, "BOTTOM"))
        self.aligny = "bottom";

    if (issubstr(point, "LEFT"))
        self.alignx = "left";

    if (issubstr(point, "RIGHT"))
        self.alignx = "right";

    if (!isdefined(relativePoint))
        relativePoint = point;

    self.relativepoint = relativePoint;
    relativeX = "center_adjustable";
    relativeY = "middle";

    if (issubstr(relativePoint, "TOP"))
        relativeY = "top_adjustable";

    if (issubstr(relativePoint, "BOTTOM"))
        relativeY = "bottom_adjustable";

    if (issubstr(relativePoint, "LEFT"))
        relativeX = "left_adjustable";

    if (issubstr(relativePoint, "RIGHT"))
        relativeX = "right_adjustable";

    if (element == level.uiparent)
    {
        self.horzalign = relativeX;
        self.vertalign = relativeY;
    }
    else
    {
        self.horzalign = element.horzalign;
        self.vertalign = element.vertalign;
    }

    if (strTok(relativeX, "_")[0] == element.alignx)
    {
        offsetX = 0;
        xFactor = 0;
    }
    else if (relativeX == "center" || element.alignx == "center")
    {
        offsetX = int(element.width / 2);

        if (relativeX == "left_adjustable" || element.alignx == "right")
            xFactor = -1;
        else
            xFactor = 1;
    }
    else
    {
        offsetX = element.width;

        if (relativeX == "left_adjustable")
            xFactor = -1;
        else
            xFactor = 1;
    }

    self.x = element.x + offsetX * xFactor;

    if (strTok(relativeY, "_")[0] == element.aligny)
    {
        offsetY = 0;
        yFactor = 0;
    }
    else if (relativeY == "middle" || element.aligny == "middle")
    {
        offsetY = int(element.height / 2);

        if (relativeY == "top_adjustable" || element.aligny == "bottom")
            yFactor = -1;
        else
            yFactor = 1;
    }
    else
    {
        offsetY = element.height;

        if (relativeY == "top_adjustable")
            yFactor = -1;
        else
            yFactor = 1;
    }

    self.y = element.y + offsetY * yFactor;
    self.x += self.xoffset;
    self.y += self.yoffset;

    switch (self.elemtype)
    {
        case "bar":
            hud_set_point_bar(point, relativePoint, xOffset, yOffset);
            break;
    }

    hud_update_child();
}

hud_set_point_bar(point, relativePoint, xOffset, yOffset)
{
    self.bar.horzalign = self.horzalign;
    self.bar.vertalign = self.vertalign;
    self.bar.alignx = "left";
    self.bar.aligny = self.aligny;
    self.bar.y = self.y;

    if (self.alignx == "left")
        self.bar.x = self.x;
    else if (self.alignx == "right")
        self.bar.x = self.x - self.width;
    else
        self.bar.x = self.x - int(self.width / 2);

    if (self.aligny == "top")
        self.bar.y = self.y;
    else if (self.aligny == "bottom")
        self.bar.y = self.y;

    hud_update_bar(self.bar.frac);
}

hud_set_shader(shader, width, height)
{
	self setshader(shader, width, height);
}

hud_update_bar(barFrac, rateOfChange)
{
	if (self.elemType == "bar") hud_update_bar_scale(barFrac, rateOfChange);
}

hud_update_bar_scale(barFrac, rateOfChange)
{
    barWidth = int(self.width * barFrac + 0.5);

    if (!barWidth)
        barWidth = 1;

    self.bar.frac = barFrac;
    self.bar setshader(self.bar.shader, barWidth, self.height);

    if (isdefined(rateOfChange) && barWidth < self.width)
    {
        if (rateOfChange > 0)
            self.bar scaleovertime((1 - barFrac) / rateOfChange, self.width, self.height);
        else if (rateOfChange < 0)
            self.bar scaleovertime(barFrac / -1 * rateOfChange, 1, self.height);
    }

    self.bar.rateofchange = rateOfChange;
    self.bar.lastupdatetime = gettime();
}

hud_hide_elem()
{
    if (self.hidden)
        return;

    self.hidden = 1;

    if (self.alpha != 0)
        self.alpha = 0;

    if (self.elemtype == "bar" || self.elemtype == "bar_shader")
    {
        self.bar.hidden = 1;

        if (self.bar.alpha != 0)
            self.bar.alpha = 0;
    }
}

hud_show_elem()
{
    if (!self.hidden)
        return;

    self.hidden = 0;

    if (self.elemtype == "bar" || self.elemtype == "bar_shader")
    {
        if (self.alpha != 0.5)
            self.alpha = 0.5;

        self.bar.hidden = 0;

        if (self.bar.alpha != 1)
            self.bar.alpha = 1;
    }
    else if (self.alpha != 1)
        self.alpha = 1;
}

/*
///DocStringBegin
detail: <HudElement> hud_destroy_elem(): <Void>
summary: Destroy parents of the current element and destroy the element itself.
///DocStringEnd
*/
hud_destroy_elem()
{
	tempChildren = [];

	for (index = 0; index < self.children.size; index++)
	{
		if (isDefined(self.children[index]))
			tempChildren[tempChildren.size] = self.children[index];
	}

	for (index = 0; index < tempChildren.size; index++)
		tempChildren[index] hud_set_parent(self.parent);
		
	if (self.elemType == "bar" || self.elemType == "bar_shader")
		self.bar destroy();

	self destroy();
}

hud_init_pulse_effect(maxFontScale)
{
	if (!isDefined(maxFontScale)) maxFontScale = self.fontScale * 2;
	self.baseFontScale = self.fontScale;
	self.maxFontScale = min(maxFontScale, 6.3);
	self.inFrames = 2;
	self.outFrames = 4;
}

hud_effect_font_pulse(player)
{
	self notify("fontPulse");
	self endon("fontPulse");
	self endon("death");
	
	player endon("disconnect");
	player endon("joined_team");
	player endon("joined_spectators");
	
	self ChangeFontScaleOverTime(IN_FRAMES);
	self.fontScale = self.maxFontScale;	
	wait 2 * 0.05;
	
	self ChangeFontScaleOverTime(OUT_FRAMES);
	self.fontScale = self.baseFontScale;
}

hud_effect_fade_on_show(fadeOverTime)
{
	self.alpha = 0;
	self fadeOverTime(fadeOverTime);
	self.alpha = 1;
}

hud_fullscreen_overlay(shader)
{
	overlay = newClientHudElem(self);
	overlay.x = 0;
	overlay.y = 0;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay setshader(shader, 640, 480);
	overlay.sort = -10;
	overlay.archived = true;
	return overlay;
}

hud_set_lower_message(name, text, time, priority, showTimer, shouldFade, fadeToAlpha, fadeToAlphaTime, hideWhenInDemo)
{
    if (lethalbeats\array::array_any(self.lowerMessages, ::_hasLowerMessage, name)) self hud_clear_lower_message(name);
	self maps\mp\_utility::setLowerMessage(name, text, time, priority, showTimer, shouldFade, fadeToAlpha, fadeToAlphaTime, hideWhenInDemo);
}

hud_clear_lower_message(name)
{
	self maps\mp\_utility::removeLowerMessage(name);
	self maps\mp\_utility::updateLowerMessage();
}

hud_clear_lower_messages()
{
	for (i = 0; i < self.lowerMessages.size; i++)
		self.lowerMessages[i] = undefined;
	if (!isDefined(self.lowerMessage)) return;
	self maps\mp\_utility::updateLowerMessage();
}

_hasLowerMessage(i, name)
{
    return i.name == name;
}

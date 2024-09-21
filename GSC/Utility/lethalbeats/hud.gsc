#include common_scripts\utility;
#include maps\mp\_utility;

/*
///DocStringBegin
detail: createHudTimer(time: <Int>, font: <String>, size: <Float>, align: <String>, relative: <String>, x: <Float>, y: <Float>): <HudElement>
summary: Creates a HUD timer element with specified properties and returns it. The timer is displayed on the screen with the given font, size, alignment, and position.
///DocStringEnd
*/
createHudTimer(time, font, size, align, relative, x, y)
{
	timer = createServerTimer(font, size);	
	timer setpoint(align, relative, x, y);
	timer.alpha = 1;
	timer.hideWhenInMenu = true;
	timer.foreground = true;
	timer setTimer(time);
	
	return timer;
}

/*
///DocStringBegin
detail: createHudString(text: <String>, font: <String>, size: <Float>, align: <String>, relative: <String>, x: <Float>, y: <Float>): <HudElement>
summary: Creates a HUD string element with specified properties and returns it. The string is displayed on the screen with the given text, font, size, alignment, and position.
///DocStringEnd
*/
createHudString(text, font, size, align, relative, x, y)
{
	hudText = createServerFontString(font, size);
	hudText setpoint(align, relative, x, y);
	hudText setText(text); 
	hudText.alpha = 1;
	hudText.hideWhenInMenu = true;
	hudText.foreground = true;
	return hudText;
}

/*
///DocStringBegin
detail: createHudIcon(shader: <String>, align: <String>, relative: <String>, x: <Float>, y: <Float>, width: <Float>, height: <Float>, color: <Vector>, alpha: <Float>, sort: <Int>, isClient: <Bool>): <HudElement>
summary: Creates a HUD icon element with specified properties and returns it. The icon is displayed on the screen with the given shader, alignment, position, size, color, and other properties.
///DocStringEnd
*/
createHudIcon(shader, align, relative, x, y, width, height, color, alpha, sort, isClient)
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

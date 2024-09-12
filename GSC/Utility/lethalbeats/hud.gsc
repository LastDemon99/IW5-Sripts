#include common_scripts\utility;
#include maps\mp\_utility;

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

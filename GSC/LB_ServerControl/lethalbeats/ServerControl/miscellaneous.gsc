#define CONSOLE_ALIAS 0
#define CHAT_PREFIX 1
#define PM_PREFIX 2
#define TEAM_NAME_ALLIES 3
#define TEAM_NAME_AXIS 4
#define CARDICON_ALLIES 5
#define CARDICON_AXIS 6
#define COLOR_ALLIES 7
#define COLOR_AXIS 8
#define COLOR_SPECTATOR 9
#define COLOR_DEATH 10
#define DAMAGE_DISPLAY 11
#define INSUFFICIENT_PRIVILEGES_MSG 12

init()
{
    // key, value
	setMisc(CONSOLE_ALIAS, "Console:");
	setMisc(CHAT_PREFIX, "^0[^4LB^0]^7");
	setMisc(PM_PREFIX, "^0[^1PM^0]^7");
	setMisc(TEAM_NAME_ALLIES, "^4Lethal ^7Beats ^4Team");
	setMisc(TEAM_NAME_AXIS, "^4Lethal ^7Beats ^Guests");
	setMisc(CARDICON_ALLIES, "iw5_cardicon_burningrunner");
	setMisc(CARDICON_AXIS, "iw5_cardicon_rampage");
	setMisc(COLOR_ALLIES, "white");
	setMisc(COLOR_AXIS, "blue");
	setMisc(COLOR_SPECTATOR, "default");
	setMisc(COLOR_DEATH, "default");
	setMisc(DAMAGE_DISPLAY, false);
	setMisc(INSUFFICIENT_PRIVILEGES_MSG, "You has insufficient privileges.");
}

setMisc(key, value)
{
	if (!isDefined(level.miscellaneous)) level.miscellaneous = [];
    level.miscellaneous[key] = value;
}

getMisc(key)
{
    /*
    switch(key)
    {
        case COLOR_AXIS: textToColor()...
    }
    */

    return level.miscellaneous[key];
}

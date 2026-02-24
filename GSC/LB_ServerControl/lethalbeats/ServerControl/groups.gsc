// groups
#define GUEST 0
#define DEVELOPER 1
#define OWNER 2
#define ADMIN 3
#define MODERATOR 4
#define VIP 5

// groups data
#define POWER 0
#define CHAT_ALIAS 1

init()
{
	// group, power, chatAlias
	setGroup(GUEST, 0, "^0[^7Guest^0]^7:");
	setGroup(DEVELOPER, 100, "^0[^6Developer^0]^7:");
	setGroup(OWNER, 100, "^0[^1Owner^0]^7:");
	setGroup(ADMIN, 70, "^0[^2Admin^0]^7:");
	setGroup(MODERATOR, 40, "^0[^5Mod^0]^7:");
	setGroup(VIP, "vip", "^0[^3VIP^0]^7:");
}

/*
///DocStringBegin
detail: <Player> giveGroup(guid: <Int>, groupIndex: <Int>): <Array>
summary: Via index a group is assigned to the player.
///DocStringEnd
*/
giveGroup(guid, groupIndex)
{
	if (!isDefined(level.players_data[guid])) level.players_data[guid] = [groupIndex, ""];
	level.players_data[guid][0] = groupIndex;
}

setGroup(group, power, alias)
{
	if (!isDefined(level.groups)) level.groups = [];
	level.groups[group] = [power, alias];
}

getGroupAlias()
{
	return level.groups[self getGroup()][POWER];
}

getGroupPower()
{
	return level.groups[self getGroup()][POWER];
}

getGroup()
{
	if (!isDefined(level.players_data[self.guid])) return undefined;
	return level.players_data[self.guid][0];
}

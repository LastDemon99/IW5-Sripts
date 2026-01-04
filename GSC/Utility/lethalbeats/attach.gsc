/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : attach           |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

#include lethalbeats\weapon;

#define ATTACH_TABLE "mp/attachmentTable.csv"
#define ATTACH_COMBO_TABLE "mp/attachmentCombos.csv"
#define CAMO_TABLE "mp/camoTable.csv"

#define SILENCER "silencer"
#define SILENCER02 "silencer02"
#define SILENCER03 "silencer03"
#define SHOTGUN "shotgun"
#define GL "gl"
#define M320 "m320"
#define GP25 "gp25"
#define RAIL "rail"
#define SCOPEVZ "scopevz"
#define VZSCOPE "vzscope"
#define CAMO "camo"

attach_is_silencer(attach)
{
	return attach == SILENCER || attach == SILENCER02 || attach == SILENCER03;
}

/*
///DocStringBegin
detail: attach_is_alt(attach: <String>): <Bool>
summary: Returns true if attachment is alternative weapon, (Grenade Launcher or a shotgun).
///DocStringEnd
*/
attach_is_alt(attach)
{
	return attach_is_gl(attach) || attach_is_shotgun(attach);
}

/*
///DocStringBegin
detail: attach_is_shotgun(attach: <String>): <Bool>
summary: Return true if attachment is a shotgun. 
///DocStringEnd
*/
attach_is_shotgun(attach)
{
	return attach == SHOTGUN;
}

/*
///DocStringBegin
detail: attach_is_sight(attach: <String>): <Bool>
summary: Returns true if the attachment is sight.
///DocStringEnd
*/
attach_is_sight(attach)
{
	return attach_get_type(attach) == RAIL || attach == "zoomscope" || isEndStr(attach, "scopevz");
}

/*
///DocStringBegin
detail: attach_is_gl(attach: <String>): <Bool>
summary: Returns true if the attachment is Grenade Launcher.
///DocStringEnd
*/
attach_is_gl(attach)
{
	return attach == GL || attach == M320 || attach == GP25;
}

/*
///DocStringBegin
detail: attach_is_akimbo(attach: <String>): <Bool>
summary: Returns true if the attachment is dual weapon.
///DocStringEnd
*/
attach_is_akimbo(attach)
{
	return attach == "akimbo";
}

/*
///DocStringBegin
detail: attach_is_camo(attach: <String>): <Bool>
summary: Returns true if the attachment is a camouflage.
///DocStringEnd
*/
attach_is_camo(attach)
{
	return lethalbeats\string::string_starts_with(attach, CAMO);
}

/*
///DocStringBegin
detail: attach_is_combo(attach: <String>, attachs: <StringArray>): <Bool>
summary: Returns true if attachment has a valid combination with attachs array.
///DocStringEnd
*/
attach_is_combo(attach, attachs)
{
	colIndex = tableLookupRowNum(ATTACH_COMBO_TABLE, 0, attach);
	for (i = 0; i < attachs.size; i++)
	{
		if (tableLookup(ATTACH_COMBO_TABLE, 0, attachs[i], colIndex) == "no")
			return false;
	}
	return true;
}

/*
///DocStringBegin
detail: attach_get_basename(attach: <String>): <String>
summary: Returns the base name of the attachment used for build weapon.
///DocStringEnd
*/
attach_get_basename(attach)
{
	switch(attach)
	{
		case SILENCER02:
		case SILENCER03:
			return SILENCER;
		case GP25:
		case M320:
			return GL;
		case "eotechsmg":
		case "eotechlmg":
			return "eotech";
		case "acogsmg":
			return "acog";
		case "thermalsmg":
			return "thermal";
		case "reflexsmg":
		case "reflexlmg":
			return "reflex";
	}
	if (isEndStr(attach, SCOPEVZ)) return VZSCOPE;
	return attach;
}

/*
///DocStringBegin
detail: attach_get_camo_index(camo: <String>): <Int>
summary: Returns the index of the camouflage based on its name.
///DocStringEnd
*/
attach_get_camo_index(camo)
{
	if (!isString(camo)) return camo;
	if (lethalbeats\string::string_starts_with(camo, CAMO)) return int(getSubStr(camo, 4, camo.size));
	return int(tablelookup(CAMO_TABLE, 1, camo, 0));
}

/*
///DocStringBegin
detail: attach_get_camos(): <StringArray>
summary: Returns an array of camo names formatted to build weapon.
///DocStringEnd
*/
attach_get_camos()
{
	camos = [];
	for(i = 1; i < 14; i++)
		camos[camos.size] = i < 10 ? "camo0" + i : CAMO + i;
	return camos;
}

attach_get_random_camo()
{
	return lethalbeats\array::array_random(attach_get_camos());
}

/*
///DocStringBegin
detail: attach_get_combos(attach: <String>, attachs: <Array>): <StringArray>
summary: Returns an array of valid attachments combinations with the specified attach.
///DocStringEnd
*/
attach_get_combos(attach, attachs)
{
	attachmentCombos = [];
	colIndex = tableLookupRowNum(ATTACH_COMBO_TABLE, 0, attach);	
	for (i = 0; i < attachs.size; i++)
	{
		if (tableLookup(ATTACH_COMBO_TABLE, 0, attachs[i], colIndex) == "no")
			continue;
		attachmentCombos[attachmentCombos.size] = attachs[i];
	}
	return attachmentCombos;
}

/*
///DocStringBegin
detail: attach_get_random(weapon_basename: <String>, attachs_count?: <Integer> = 2, return_builded?: <Bool> = true, include_none?: <Bool> = false): <String[]>
summary: Returns an array of random attachments for a specified weapon. The number of attachments can be specified. If include_none is true, some slots may be left empty. If return_builded is true, the result will be a built attachment.
///DocStringEnd
*/
attach_get_random(weapon_basename, attachs_count, return_builded, include_none)
{
	if (!isDefined(attachs_count)) attachs_count = 2;
	if (!isDefined(return_builded)) return_builded = true;
	if (!isDefined(include_none)) include_none = false;

    max_attachs = weapon_get_max_attachs(weapon_basename);
    if (attachs_count > max_attachs) attachs_count = max_attachs;
	
	allowed_attachs = weapon_get_attachs(weapon_basename, false);
	if (allowed_attachs.size < attachs_count) attachs_count = allowed_attachs.size;
	attachs = [];
	
	while(attachs_count != 0 && allowed_attachs.size != 0)
	{
		if (allowed_attachs.size == 0) break;
		if (include_none && randomInt(100) >= 50)
		{
			attachs_count--;
			continue;
		}
		
		attach = lethalbeats\array::array_random(allowed_attachs);
		attachs[attachs.size] = attach;
		allowed_attachs = attach_get_combos(attach, allowed_attachs);
		attachs_count--;
	}
	
	if (return_builded)
	{
		for(i = 0; i < attachs.size; i++)
			if (attach_get_type(attachs[i]) == RAIL)
				attachs[i] = attach_build(attachs[i], weapon_basename);
	}
	
	return attachs;
}

/*
///DocStringBegin
detail: attach_get_type(attach: <String>): <String>
summary: Returns the type of the attachment.
///DocStringEnd
*/
attach_get_type(attach)
{
	return tableLookup(ATTACH_TABLE, 4, attach, 2);		
}

/*
///DocStringBegin
detail: attach_build_rail(attach: <String>, weapon_basename: <String>, weapon_class: <String>): <String>
summary: Returns built weapon sight.
///DocStringEnd
*/
attach_build_rail(attach, weapon_basename, weapon_class)
{
	switch(weapon_class)
	{
		case "smg":
		case "lmg":
		case "machine_pistol":
			return maps\mp\_utility::attachmentMap(attach, weapon_basename);
		default:
			return attach;
	}
}

/*
///DocStringBegin
detail: attach_build_vzscope(weapon_basename: <String>): <String>
summary: Returns built sniper scope.
///DocStringEnd
*/
attach_build_vzscope(weapon_basename)
{
	return getSubStr(weapon_basename, 4, weapon_basename.size) + SCOPEVZ;
}

/*
///DocStringBegin
detail: attach_build_gl(weapon_basename: <String>): <String>
summary: Returns built grenade launcher attachment.
///DocStringEnd
*/
attach_build_gl(weapon_basename)
{
	switch(weapon_basename)
	{
		case "iw5_ak47":
			return GP25;
		case "iw5_m4":
		case "iw5_m16":
			return GL;
		default:
			return M320;
	}
}

/*
///DocStringBegin
detail: attach_build_silencer(weapon_class: <String>): <String>
summary: Returns built silencer.
///DocStringEnd
*/
attach_build_silencer(weapon_class)
{
	switch(weapon_class)
	{
		case "pistol":
		case "machine_pistol":
			return SILENCER02;
		case SHOTGUN:
		case "sniper":
			return SILENCER03;
		default:
			return SILENCER;
	}
}

/*
///DocStringBegin
detail: attach_build_camo(index: <Integer>): <String>
summary: Returns a built camouflage.
///DocStringEnd
*/
attach_build_camo(index)
{
	if (index == 0) return "";
	return index < 10 ? "camo0" + index : CAMO + index;
}

/*
///DocStringBegin
detail: attach_build(attach: <String>, weapon_basename: <String>): <String>
summary: Returns built any attachment.
///DocStringEnd
*/
attach_build(attach, weapon_basename)
{
	if (attach == VZSCOPE) return attach_build_vzscope(weapon_basename);	
	if (attach == GL) return attach_build_gl(weapon_basename);
	wep_class = weapon_get_class(weapon_basename);
	if (attach == SILENCER) return attach_build_silencer(wep_class);
	return attach_build_rail(attach, weapon_basename, wep_class);
}

attach_get_display_name(attach)
{
    switch(attach)
    {
        case "acog":
            return "ACOG Scope";
        case "reflex":
            return "Red Dot Sight";
        case "eotech":
            return "Holographic Sight";
        case "thermal":
            return "Thermal Scope";
        case "vzscope":
            return "Variable Zoom";
        case "hamrhybrid":
        case "hybrid":
            return "Hybrid Sight";
        case "silencer":
        case "silencer02":
        case "silencer03":
            return "Suppressed";
        case "grip":
            return "Foregrip";
        case "akimbo":
            return "Akimbo";
        case "tactical":
            return "Tactical Knife";
        case "shotgun":
            return "Shotgun";
        case "gl":
        case "gp25":
        case "m320":
            return "Grenade Launcher";
        case "rof":
            return "Rapid Fire";
        case "xmags":
            return "Extended Mags";
        case "heartbeat":
            return "Heartbeat Sensor";
        case "fmj":
            return "FMJ";
        case "lockair":
            return "Air Lock-on";
        default:
            return undefined;
    }
}

attach_get_tag(attach)
{
    switch (attach)
	{
        case "acog": return "tag_acog_2";
        case "reflex": return "tag_red_dot";
        case "eotech": return "tag_eotech";
        case "thermal": return "tag_thermal_scope";
        case "vzscope":
        case "hamrhybrid":
        case "hybrid":
            return "tag_magnifier";
        case "silencer":
        case "silencer02":
        case "silencer03":
            return "tag_silencer";
        case "grip": return "tag_foregrip";
        case "heartbeat": return "tag_heartbeat";
        case "xmags": return "tag_clip";
        default: return undefined;
    }
}

attach_get_model(attach)
{
    switch (attach)
	{
        case "acog": return "weapon_acog";
        case "reflex": return "weapon_reflex_iw5";
        case "eotech": return "weapon_eotech";
        case "thermal": return "weapon_thermal_scope";
        //case "vzscope":
        case "hamrhybrid": return "weapon_hamr_hybrid";
        case "hybrid": return "weapon_magnifier";
        case "silencer": return "weapon_silencer_01";
        case "silencer02": return "weapon_silencer_02";
        case "silencer03": return "weapon_silencer_03";
        case "grip": return "weapon_mp5k_foregrip";
        case "heartbeat": return "weapon_heartbeat_iw5";
        //case "xmags": return "tag_clip";
        default: return undefined;
    }
}

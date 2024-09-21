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

#include scripts\lethalbeats\string;
#include scripts\lethalbeats\weapon;

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
	return attach == "shotgun";
}

/*
///DocStringBegin
detail: attach_is_sight(attach: <String>): <Bool>
summary: Returns true if the attachment is sight.
///DocStringEnd
*/
attach_is_sight(attach)
{
	return attach_get_type(attach) == "rail" || attach == "zoomscope";
}

/*
///DocStringBegin
detail: attach_is_gl(attach: <String>): <Bool>
summary: Returns true if the attachment is Grenade Launcher.
///DocStringEnd
*/
attach_is_gl(attach)
{
	return attach == "gl" || attach == "m320" || attach == "gp25";
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
	return string_starts_with(attach, "camo");
}

/*
///DocStringBegin
detail: attach_is_combo(attach: <String>, attachs: <StringArray>): <Bool>
summary: Returns true if attachment has a valid combination with attachs array.
///DocStringEnd
*/
attach_is_combo(attach, attachs)
{
	colIndex = tableLookupRowNum("mp/attachmentCombos.csv", 0, attach);
	for (i = 0; i < attachs.size; i++)
	{
		if (tableLookup("mp/attachmentCombos.csv", 0, attachs[i], colIndex) == "no")
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
		case "silencer02":
		case "silencer03":
			return "silencer";
		case "gp25":
		case "m320":
			return "gl";
		case "eotechsmg":
		case "eotechlmg":
			return "eotech";
		case "acogsmg":
			return "acog";
		case "thermalsmg":
			return "thermal";
		case "reflexsmg":
		case "reflexlmg":
		case "reflexsmg":
			return "reflex";
	}
	if (string_ends_with(attach, "scopevz")) return "vzscope";
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
	if (string_starts_with(camo, "camo")) return int(string_get_substring(camo, 4, camo.size));
	return int(tablelookup("mp/camoTable.csv", 1, camo, 0));
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
		camos[camos.size] = i < 10 ? "camo0" + i : "camo" + i;
	return camos;
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
	colIndex = tableLookupRowNum("mp/attachmentCombos.csv", 0, attach);	
	for (i = 0; i < attachs.size; i++)
	{
		if (tableLookup("mp/attachmentCombos.csv", 0, attachs[i], colIndex) == "no")
			continue;
		attachmentCombos[attachmentCombos.size] = attachs[i];
	}
	return attachmentCombos;
}

/*
///DocStringBegin
detail: attach_get_random(weapon_basename: <String>, attachs_count?: <Integer> = 2, return_builded?: <Bool> = true, include_none?: <Bool> = false): <StringArray>
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
	
	allowed_attachs = weapon_get_attachs(weapon_basename, return_builded);
	
	if (allowed_attachs.size < attachs_count) attachs_count = allowed_attachs.size;
	attachs = [];
	
	while(attachs_count != 0)
	{
		if (include_none && randomint(100) >= 50)
		{
			attachs_count--;
			continue;
		}
		
		attach = scripts\lethalbeats\array::array_random_item(allowed_attachs);
		attachs[attachs.size] = attach;
		allowed_attachs = attach_get_combos(attach, allowed_attachs);
		attachs_count--;
	}
	
	if (return_builded)
	{
		for(i = 0; i < attachs.size; i++)
			if (attach_get_type(attachs[i]) == "rail")
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
	return tableLookup("mp/attachmentTable.csv", 4, attach, 2);		
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
	return getSubStr(weapon_basename, 4, weapon_basename.size) + "scopevz";
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
			return "gp25";
		case "iw5_m4":
		case "iw5_m16":
			return "gl";
		default:
			return "m320";
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
			return "silencer02";
		case "shotgun":
		case "sniper":
			return "silencer03";
		default:
			return "silencer";
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
	return index < 10 ? "camo0" + index : "camo" + index;
}

/*
///DocStringBegin
detail: attach_build(attach: <String>, weapon_basename: <String>): <String>
summary: Returns built any attachment.
///DocStringEnd
*/
attach_build(attach, weapon_basename)
{
	if (attach == "vzscope") return attach_build_vzscope(weapon_basename);	
	if (attach == "gl") return attach_build_gl(weapon_basename);
	wep_class = weapon_get_class(weapon_basename);
	if (attach == "silencer") return attach_build_silencer(wep_class);
	return attach_build_rail(attach, weapon_basename, wep_class);
}

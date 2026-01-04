/*
============================
|   Lethal Beats Team	   |
============================
|Game : IW5                |
|Script : perk             |
|Creator : LastDemon99	   |
|Type : Utility            |
============================
*/

perk_is_weapon_buff(buff, weaponClass)
{
	if (isDefined(weaponClass))
	{
		if (weaponClass == "assault")
		{
			switch (buff)
			{
				case "specialty_reducedsway":
				case "specialty_holdbreathwhileads":
				case "specialty_sharp_focus":
				case "specialty_marksman":
				case "specialty_bulletpenetration":
				case "specialty_bling":
					return true;
				default:
					return false;
			}
		}
		else if (weaponClass == "smg")
		{
			switch (buff)
			{
				case "specialty_fastermelee":
				case "specialty_longerrange":
				case "specialty_reducedsway":
				case "specialty_sharp_focus":
				case "specialty_marksman":
				case "specialty_bling":
					return true;
				default:
					return false;
			}
		}
		else if (weaponClass == "lmg")
		{
			switch (buff)
			{
				case "specialty_lightweight":
				case "specialty_reducedsway":
				case "specialty_sharp_focus":
				case "specialty_marksman":
				case "specialty_bulletpenetration":
				case "specialty_bling":
					return true;
				default:
					return false;
			}
		}
		else if (weaponClass == "sniper")
		{
			switch (buff)
			{
				case "specialty_lightweight":
				case "specialty_reducedsway":
				case "specialty_sharp_focus":
				case "specialty_marksman":
				case "specialty_bulletpenetration":
				case "specialty_bling":
					return true;
				default:
					return false;
			}
		}
		else if (weaponClass == "shotgun")
		{
			switch (buff)
			{
				case "specialty_moredamage":
				case "specialty_fastermelee":
				case "specialty_longerrange":
				case "specialty_sharp_focus":
				case "specialty_marksman":
				case "specialty_bling":
					return true;
				default:
					return false;
			}
		}
		else if (weaponClass == "riot")
		{
			switch (buff)
			{
				case "specialty_lightweight":
				case "specialty_fastermelee":
					return true;
				default:
					return false;
			}
		}
		else return false;
	}

    switch(buff)
	{
        case "specialty_bulletpenetration":
        case "specialty_marksman":
        case "specialty_bling":
        case "specialty_sharp_focus":
        case "specialty_armorpiercing":
        case "specialty_holdbreathwhileads":
        case "specialty_longerrange":
        case "specialty_fastermelee":
        case "specialty_reducedsway":
        case "specialty_lightweight":
        case "specialty_moredamage":
            return true;
        default:
            return false;
	}
}

perk_get_list()
{
    return [ 
		"specialty_paint",
		"specialty_fastreload",
		"specialty_blindeye",
		"specialty_longersprint",
		"specialty_scavenger",
		"specialty_quickdraw",
		"_specialty_blastshield",
		"specialty_hardline",
		"specialty_assassin",
		"specialty_overkill",
		"specialty_autospot",
		"specialty_stalker",
		"specialty_detectexplosive",
		"specialty_bulletaccuracy",
		"specialty_quieter"
	];
}

perk_get_display_name(perk)
{
	switch(perk)
	{
		case "specialty_paint": return "Recon";
		case "specialty_fastreload": return "Sleight of Hand";
		case "specialty_blindeye": return "Blind Eye";
		case "specialty_longersprint": return "Extreme Conditioning";
		case "specialty_scavenger": return "Scavenger";
		case "specialty_quickdraw": return "Quickdraw";
		case "_specialty_blastshield": return "Blast Shield";
		case "specialty_hardline": return "Hardline";
		case "specialty_assassin": return "Assassin";
		case "specialty_overkill": return "Overkill";
		case "specialty_autospot": return "Marksman";
		case "specialty_stalker": return "Stalker";
		case "specialty_detectexplosive": return "Sitrep";
		case "specialty_bulletaccuracy": return "Steady Aim";
		case "specialty_quieter": return "Dead Silence";
		default: return perk;
	}
}

perk_get_random()
{
	return lethalbeats\array::array_random(perk_get_list());
}

/*
///DocStringBegin
detail: perk_get_by_killstreak(killstreak_perk: <String>): <String>
summary: Return a killstreak perk format from a perk format. `specialty_quickdraw` -> `specialty_quickdraw_ks`
///DocStringEnd
*/
perk_get_killstreak(perk)
{
	return perk + "_ks";
}

/*
///DocStringBegin
detail: perk_get_by_killstreak(killstreak_perk: <String>): <String>
summary: Return a perk format from a killstreak perk format. `specialty_quickdraw_ks` -> `specialty_quickdraw`
///DocStringEnd
*/
perk_get_by_killstreak(killstreak_perk)
{
	return lethalbeats\string::string_remove_suffix(killstreak_perk, "_ks");
}

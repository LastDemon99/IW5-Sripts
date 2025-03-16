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

perk_is_weapon_buff(buff)
{
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

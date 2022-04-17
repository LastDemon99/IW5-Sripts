#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	loadDvar();
	
	if(getDvar("lb_customMode") != "OldSchool") 
	{
		setDvar("ui_gametype", getDvar("g_gametype"));	
		setDvar("jump_slowdownEnable", getDvarInt("lb_defaultJumpSlowValue"));
		setDvar("jump_disableFallDamage", getDvarInt("lb_defaultFallDamageValue"));
		return;
	}
	
	setDvar("ui_gametype", "Old School");		
	loadData();	
	
	level thread spawnTargets();	
	level thread onPlayerConnect();
	
	setDvar( "jump_slowdownEnable", false );
	setDvar("jump_disableFallDamage", 1);	
	
	level waittill("game_ended");
	setDvar("jump_slowdownEnable", getDvarInt("lb_defaultJumpSlowValue"));
	setDvar("jump_disableFallDamage", getDvarInt("lb_defaultFallDamageValue"));
}

loadDvar()
{
	SetDvarIfUninitialized("os_perks_enable", 1);
	SetDvarIfUninitialized("os_equipment_enable", 1);
	SetDvarIfUninitialized("os_camos_enable", 0);
	
	SetDvarIfUninitialized("lb_customMode", "");
	SetDvarIfUninitialized("lb_defaultJumpSlowValue", getDvarInt("jump_slowdownEnable"));
	SetDvarIfUninitialized("lb_defaultFallDamageValue", getDvarInt("jump_disableFallDamage"));
}

loadData()
{
	loadDvar();
	
	level.os_fx["neutral"] = loadFx("misc/ui_flagbase_gold");
	level.os_fx["enemy"] = loadFx("misc/ui_flagbase_red");
	
	upangles = vectorToAngles((0, 0, 1000));
	level.forward_fx = anglesToForward(upangles);
	level.right_fx = anglesToRight(upangles);
	
	level.os_primary = "iw5_skorpion_mp";
	level.os_secondary = "iw5_usp45_mp";
	
	loadZones();
	loadWeapons();
	loadEquipment();
	loadPerks();
}

loadZones()
{
	//check zones remove & add new zones
	
	zonesData = [];
	zonesData["mp_seatown"][1]  = (-1226, -1399, 204);
	zonesData["mp_seatown"][2]  = (1048, 886, 228);
	zonesData["mp_seatown"][3]  = (-1982, 1494, 229);
	zonesData["mp_seatown"][4]  = (-2297, -855, 210);
	zonesData["mp_seatown"][5]  = (-2261, -334, 248);
	zonesData["mp_seatown"][6]  = (-2048, 512, 248);
	zonesData["mp_seatown"][7]  = (-1439, 1065, 72);
	zonesData["mp_seatown"][8]  = (-410, 982, 127);
	zonesData["mp_seatown"][9]  = (-666, -217, 226);
	zonesData["mp_seatown"][10]  = (-523, -875, 260);
	zonesData["mp_seatown"][11]  = (-345, -1449, 254);
	zonesData["mp_seatown"][12]  = (1167, -533, 294);
	zonesData["mp_seatown"][13]  = (367, 991, 179);
	zonesData["mp_seatown"][14]  = (1106, 219, 292);
	
	zonesData["mp_dome"][0] = (97, 898, -240);
	zonesData["mp_dome"][1] = (-226, 1464, -231);
	zonesData["mp_dome"][2] = (-603, 194, -358);
	zonesData["mp_dome"][3] = (814, -406, -335);
	zonesData["mp_dome"][4] = (5, 1975, -231);
	zonesData["mp_dome"][5] = (-673, 1100, -284);
	zonesData["mp_dome"][6] = (669, 1028, -255);
	zonesData["mp_dome"][7] = (1231, 807, -267);
	zonesData["mp_dome"][8] = (709, 210, -342);
	zonesData["mp_dome"][9] = (1223, 10, -336);
	zonesData["mp_dome"][10] = (-222, 418, -333);
	zonesData["mp_dome"][11] = (501, -183, -330);
	
	zonesData["mp_plaza2"][0] = (221, 440, 754);
	zonesData["mp_plaza2"][1] = (155, 1763, 668);
	zonesData["mp_plaza2"][2] = (-430, 1871, 691);
	zonesData["mp_plaza2"][3] = (-1190, 1759, 668);
	zonesData["mp_plaza2"][4] = (-1273, 1279, 829);
	zonesData["mp_plaza2"][5] = (-593, 1274, 676);
	zonesData["mp_plaza2"][6] = (-251, 1006, 722);
	zonesData["mp_plaza2"][7] = (80, 1343, 676);
	zonesData["mp_plaza2"][8] = (397, -99, 708);
	zonesData["mp_plaza2"][9] = (-1109, 92, 741);
	zonesData["mp_plaza2"][10] = (-280, -195, 700);
	zonesData["mp_plaza2"][11] = (28, -1600, 668);
	zonesData["mp_plaza2"][12] = (764, -1752, 669);
	
	zonesData["mp_mogadishu"][0] = (1448, 1945, 39);
	zonesData["mp_mogadishu"][1] = (1499, -1193, 15);
	zonesData["mp_mogadishu"][2] = (791, -880, 16);
	zonesData["mp_mogadishu"][3] = (38, -1007, 16);
	zonesData["mp_mogadishu"][4] = (-691, -260, 22);
	zonesData["mp_mogadishu"][5] = (2, 52, 2);
	zonesData["mp_mogadishu"][6] = (664, 69, 12);
	zonesData["mp_mogadishu"][7] = (1676, 251, -1);
	zonesData["mp_mogadishu"][8] = (2314, 1860, 63);
	zonesData["mp_mogadishu"][9] = (73, 858, 3);
	zonesData["mp_mogadishu"][10] = (710, 837, 16);
	zonesData["mp_mogadishu"][11] = (-549, 829, 2);
	zonesData["mp_mogadishu"][12] = (34, 1850, 84);
	zonesData["mp_mogadishu"][13] = (-778, 2614, 157);
	zonesData["mp_mogadishu"][14] = (-204, 3206, 152);
	zonesData["mp_mogadishu"][15] = (752, 3189, 148);
	zonesData["mp_mogadishu"][16] = (692, 2354, 95);
	
	zonesData["mp_paris"][0] = (-931, -921, 110);
	zonesData["mp_paris"][1] = (1597, 1768, 47);
	zonesData["mp_paris"][2] = (716, 1809, 33);
	zonesData["mp_paris"][3] = (258, 2074, 36);
	zonesData["mp_paris"][4] = (459, 1067, 37);
	zonesData["mp_paris"][5] = (852, 1350, 118);
	zonesData["mp_paris"][6] = (1601, 897, 45);
	zonesData["mp_paris"][7] = (1286, 420, 41);
	zonesData["mp_paris"][8] = (1613, 181, 172);
	zonesData["mp_paris"][9] = (466, -752, 67);
	zonesData["mp_paris"][10] = (994, -625, 50);
	zonesData["mp_paris"][11] = (-211, -60, 63);
	zonesData["mp_paris"][12] = (-742, 177, 133);	
	zonesData["mp_paris"][13] = (-1532, 100, 250);
	zonesData["mp_paris"][14] = (-343, 1922, 121);
	zonesData["mp_paris"][15] = (-1127, 1555, 284);
	zonesData["mp_paris"][16] = (-2025, 1327, 316);
	zonesData["mp_paris"][17] = (-1039, 841, 187);			
	
	zonesData["mp_exchange"][0] = (-614, 1286, 113);
	zonesData["mp_exchange"][1] = (182, 1155, 148);
	zonesData["mp_exchange"][2] = (1018, 1254, 120);
	zonesData["mp_exchange"][3] = (2182, 1322, 145);
	zonesData["mp_exchange"][4] = (655, 815, 13);
	zonesData["mp_exchange"][5] = (761, -312, -18);
	zonesData["mp_exchange"][6] = (761, -771, 112);
	zonesData["mp_exchange"][7] = (635, -1450, 110);
	zonesData["mp_exchange"][8] = (152, -1538, 96);
	zonesData["mp_exchange"][9] = (303, -824, 88);
	zonesData["mp_exchange"][10] = (-953, -768, 45);
	zonesData["mp_exchange"][11] = (2392, 1305, 144);
	zonesData["mp_exchange"][12] = (1634, 1329, 151);
	zonesData["mp_exchange"][13] = (1315, 743, 159);
	
	zonesData["mp_bootleg"][0] = (-1432, 1404, 8);
	zonesData["mp_bootleg"][1] = (-1017, 1787, -39);
	zonesData["mp_bootleg"][2] = (-590, 1514, -43);
	zonesData["mp_bootleg"][3] = (-588, 614, -12);
	zonesData["mp_bootleg"][4] = (-1732, 84, 11);
	zonesData["mp_bootleg"][5] = (-1809, -302, 140);
	zonesData["mp_bootleg"][6] = (-1649, -1147, 92);
	zonesData["mp_bootleg"][7] = (-884, -1035, -4);
	zonesData["mp_bootleg"][8] = (-719, -1673, 60);
	zonesData["mp_bootleg"][9] = (-335, -2111, 60);
	zonesData["mp_bootleg"][10] = (208, -1955, 68);
	zonesData["mp_bootleg"][11] = (-198, -1726, 60);
	zonesData["mp_bootleg"][12] = (100, -1101, -9);
	zonesData["mp_bootleg"][13] = (-427, -100, -8);
	zonesData["mp_bootleg"][14] = (949, -1132, -10);
	zonesData["mp_bootleg"][15] = (884, 1182, -28);
	zonesData["mp_bootleg"][16] = (242, 1194, -45);		
	
	zonesData["mp_carbon"][0] = (-3330, -3392, 3630);
	zonesData["mp_carbon"][1] = (-3635, -3735, 3630);
	zonesData["mp_carbon"][2] = (-3625, -4189, 3633);
	zonesData["mp_carbon"][3] = (-2992, -4339, 3627);
	zonesData["mp_carbon"][4] = (-2925, -4999, 3673);
	zonesData["mp_carbon"][5] = (-2573, -4771, 3784);
	zonesData["mp_carbon"][6] = (-1705, -4643, 3813);
	zonesData["mp_carbon"][7] = (-1799, -3957, 3813);
	zonesData["mp_carbon"][8] = (-2141, -3647, 3815);
	zonesData["mp_carbon"][9] = (-3212, -2879, 3807);
	zonesData["mp_carbon"][10] = (-1623, -3339, 3808);
	zonesData["mp_carbon"][11] = (-1223, -4234, 3834);
	zonesData["mp_carbon"][12] = (-896, -4888, 3944);
	zonesData["mp_carbon"][13] = (-228, -4535, 3975);
	zonesData["mp_carbon"][14] = (-257, -3865, 3956);
	zonesData["mp_carbon"][15] = (-215, -3260, 3967);
	zonesData["mp_carbon"][16] = (-535, -3798, 3966);
	
	zonesData["mp_hardhat"][0] = (2035, -229, 246);
	zonesData["mp_hardhat"][1] = (1959, -772, 352);
	zonesData["mp_hardhat"][2] = (1883, -1384, 351);
	zonesData["mp_hardhat"][3] = (848, -1520, 334);
	zonesData["mp_hardhat"][4] = (1326, -1380, 342);
	zonesData["mp_hardhat"][5] = (-338, -1273, 348);
	zonesData["mp_hardhat"][6] = (-821, -884, 348);
	zonesData["mp_hardhat"][7] = (-920, -290, 230);
	zonesData["mp_hardhat"][8] = (-463, -250, 333);
	zonesData["mp_hardhat"][9] = (-741, 208, 245);
	zonesData["mp_hardhat"][10] = (-201, 806, 437);
	zonesData["mp_hardhat"][11] = (224, 980, 436);
	zonesData["mp_hardhat"][12] = (1125, 656, 255);
	zonesData["mp_hardhat"][13] = (1531, 1241, 364);
	zonesData["mp_hardhat"][14] = (1522, 542, 244);	
	
	zonesData["mp_alpha"][0] = (-1979, 1653, 148);
	zonesData["mp_alpha"][1] = (-1392, 1623, 60);
	zonesData["mp_alpha"][2] = (-1697, 1205, 52);
	zonesData["mp_alpha"][3] = (-1671, 692, 54);
	zonesData["mp_alpha"][4] = (-572, -272, 55);
	zonesData["mp_alpha"][5] = (634, -345, 52);
	zonesData["mp_alpha"][6] = (391, 121, 60);
	zonesData["mp_alpha"][7] = (291, 1271, 60);
	zonesData["mp_alpha"][8] = (-459, 868, 52);
	zonesData["mp_alpha"][9] = (-353, 1334, 52);
	zonesData["mp_alpha"][10] = (-37, 1637, 52);
	zonesData["mp_alpha"][11] = (-5, 2226, 52);
	zonesData["mp_alpha"][12] = (-407, 2198, 196);
	
	zonesData["mp_village"][0] = (647, 1891, 332);
	zonesData["mp_village"][1] = (-26, 1749, 334);
	zonesData["mp_village"][2] = (104, 1292, 323);
	zonesData["mp_village"][3] = (-1064, 1552, 322);
	zonesData["mp_village"][4] = (-599, 886, 378);
	zonesData["mp_village"][5] = (-1038, 569, 317);
	zonesData["mp_village"][6] = (-1899, 1217, 336);
	zonesData["mp_village"][7] = (-1540, 289, 304);
	zonesData["mp_village"][8] = (-454, -277, 270);
	zonesData["mp_village"][9] = (-1734, -790, 365);
	zonesData["mp_village"][10] = (-1418, -1371, 431);
	zonesData["mp_village"][11] = (-928, -749, 417);
	zonesData["mp_village"][12] = (-861, -2105, 408);
	zonesData["mp_village"][13] = (-191, -1550, 400);
	zonesData["mp_village"][14] = (357, -678, 245);
	zonesData["mp_village"][15] = (-216, 295, 223);
	zonesData["mp_village"][16] = (162, -199, 229);
	zonesData["mp_village"][17] = (179, -3052, 447);
	zonesData["mp_village"][18] = (510, -1790, 375);
	zonesData["mp_village"][19] = (1089, -615, 398);
	zonesData["mp_village"][20] = (1631, 394, 297);
	zonesData["mp_village"][21] = (1007, 1385, 337);
	zonesData["mp_village"][22] = (992, 248, 330);
	zonesData["mp_village"][23] = (551, 732, 386);		
	
	zonesData["mp_lambeth"][0] = (-293, -1286, -180);
	zonesData["mp_lambeth"][1] = (-938, -785, -130);
	zonesData["mp_lambeth"][2] = (-375, -250, -187);
	zonesData["mp_lambeth"][3] = (-355, 409, -196);
	zonesData["mp_lambeth"][4] = (161, -5, -181);
	zonesData["mp_lambeth"][5] = (682, -407, -197);
	zonesData["mp_lambeth"][6] = (694, 263, -196);
	zonesData["mp_lambeth"][7] = (690, 1158, -243);
	zonesData["mp_lambeth"][8] = (1181, 801, -67);
	zonesData["mp_lambeth"][9] = (1281, 1248, -257);
	zonesData["mp_lambeth"][10] = (2057, 757, -249);
	zonesData["mp_lambeth"][11] = (1470, -1040, -109);
	zonesData["mp_lambeth"][12] = (1761, -258, -210);
	zonesData["mp_lambeth"][13] = (2800, -652, -186);
	zonesData["mp_lambeth"][14] = (2785, 445, -244);
	zonesData["mp_lambeth"][15] = (2751, 1090, -263);
	zonesData["mp_lambeth"][16] = (1535, 1980, -214);
	zonesData["mp_lambeth"][17] = (1262, 2602, -213);
	zonesData["mp_lambeth"][18] = (419, 2218, -183);
	zonesData["mp_lambeth"][19] = (170, 1631, -182);
	zonesData["mp_lambeth"][20] = (-606, 1549, -201);
	zonesData["mp_lambeth"][21] = (-1199, 1030, -196);
	
	zonesData["mp_radar"][0] = (-3482, -498, 1222);
	zonesData["mp_radar"][1] = (-4263, -124, 1229);
	zonesData["mp_radar"][2] = (-4006, 827, 1238);
	zonesData["mp_radar"][3] = (-3375, 342, 1222);
	zonesData["mp_radar"][4] = (-4623, 531, 1298);
	zonesData["mp_radar"][5] = (-5157, 877, 1200);
	zonesData["mp_radar"][6] = (-5950, 1071, 1305);
	zonesData["mp_radar"][7] = (-6509, 1660, 1299);
	zonesData["mp_radar"][8] = (-7013, 2955, 1359);
	zonesData["mp_radar"][9] = (-6333, 3473, 1421);
	zonesData["mp_radar"][10] = (-5675, 2923, 1388);
	zonesData["mp_radar"][11] = (-7119, 4357, 1380);
	zonesData["mp_radar"][12] = (-5487, 4077, 1356);
	zonesData["mp_radar"][13] = (-5736, 2960, 1407);
	zonesData["mp_radar"][14] = (-4908, 3281, 1225);
	zonesData["mp_radar"][15] = (-4421, 4071, 1268);
	zonesData["mp_radar"][16] = (-4979, 1816, 1205);
	zonesData["mp_radar"][17] = (-4874, 2306, 1223);		
	
	zonesData["mp_interchange"][0] = (2465, -402, 149);
	zonesData["mp_interchange"][1] = (2128, 199, 68);
	zonesData["mp_interchange"][2] = (1280, 1263, 126);
	zonesData["mp_interchange"][3] = (762, 1747, 114);
	zonesData["mp_interchange"][4] = (-9, 1836, 38);
	zonesData["mp_interchange"][5] = (-284, 1171, 159);
	zonesData["mp_interchange"][6] = (-1028, 944, 31);
	zonesData["mp_interchange"][7] = (-256, 264, 126);
	zonesData["mp_interchange"][8] = (462, -463, 158);
	zonesData["mp_interchange"][9] = (1029, -1045, 179);
	zonesData["mp_interchange"][10] = (1760, -1434, 142);
	zonesData["mp_interchange"][11] = (1538, -361, 142);
	zonesData["mp_interchange"][12] = (1150, -2977, 171);
	zonesData["mp_interchange"][13] = (371, -2883, 209);
	zonesData["mp_interchange"][14] = (399, -2149, 220);		
	
	zonesData["mp_underground"][0] = (-602, 3072, -68);
	zonesData["mp_underground"][1] = (-285, 2551, -215);
	zonesData["mp_underground"][2] = (574, 2656, -40);
	zonesData["mp_underground"][3] = (-627, 1579, -196);
	zonesData["mp_underground"][4] = (28, 1556, -196);
	zonesData["mp_underground"][5] = (727, 1615, -196);
	zonesData["mp_underground"][6] = (-1491, 1268, -196);
	zonesData["mp_underground"][7] = (-1370, 1757, -196);
	zonesData["mp_underground"][8] = (-1259, 599, -156);
	zonesData["mp_underground"][9] = (-959, -26, 60);
	zonesData["mp_underground"][10] = (-303, -562, 60);
	zonesData["mp_underground"][11] = (193, -922, 60);
	zonesData["mp_underground"][12] = (305, 817, -68);
	zonesData["mp_underground"][13] = (-276, 370, -68);
	
	zonesData["mp_bravo"][0] = (-1359, 608, 975);
	zonesData["mp_bravo"][1] = (-1686, 313, 991);
	zonesData["mp_bravo"][2] = (-1228, 41, 976);
	zonesData["mp_bravo"][3] = (-732, -715, 1032);
	zonesData["mp_bravo"][4] = (31, -771, 1038);
	zonesData["mp_bravo"][5] = (986, -833, 1116);
	zonesData["mp_bravo"][6] = (1800, -577, 1229);
	zonesData["mp_bravo"][7] = (1588, -55, 1181);
	zonesData["mp_bravo"][8] = (619, 916, 1175);
	zonesData["mp_bravo"][9] = (-129, 1310, 1228);
	zonesData["mp_bravo"][10] = (-726, 1272, 1268);
	zonesData["mp_bravo"][11] = (-741, 752, 1053);
	zonesData["mp_bravo"][12] = (6, -136, 1282);
	
	level.os_zones = zonesData[getdvar("mapname")];
}

loadWeapons()
{
	weaponsData = [];
	weaponsData[0] = ["iw5_m4_mp", "viewmodel_m4_iw5"];
	weaponsData[1] = ["iw5_ak47_mp", "viewmodel_ak47_iw5"];
	weaponsData[2] = ["iw5_m16_mp", "viewmodel_m16_iw5"];
	weaponsData[3] = ["iw5_fad_mp", "viewmodel_fad_iw5"];
	weaponsData[4] = ["iw5_acr_mp", "viewmodel_remington_acr_iw5"];
	weaponsData[5] = ["iw5_type95_mp", "viewmodel_type95_iw5"];
	weaponsData[6] = ["iw5_mk14_mp", "viewmodel_m14_iw5"];
	weaponsData[7] = ["iw5_scar_mp", "viewmodel_scar_iw5"];
	weaponsData[8] = ["iw5_g36c_mp", "viewmodel_g36_iw5"];
	weaponsData[9] = ["iw5_cm901_mp", "viewmodel_cm901"];
	weaponsData[10] = ["iw5_mp5_mp", "viewmodel_mp5_iw5"];
	weaponsData[11] = ["iw5_mp7_mp", "viewmodel_mp7_iw5"];
	weaponsData[12] = ["iw5_m9_mp", "viewmodel_uzi_m9_iw5"];
	weaponsData[13] = ["iw5_p90_mp", "viewmodel_p90_iw5"];
	weaponsData[14] = ["iw5_pp90m1_mp", "viewmodel_pp90m1_iw5"];
	weaponsData[15] = ["iw5_ump45_mp", "viewmodel_ump45_iw5"];
	weaponsData[16] = ["iw5_barrett_mp_barrettscopevz", "viewmodel_m82_iw5"];
	weaponsData[17] = ["iw5_rsass_mp_rsassscopevz", "viewmodel_rsass_iw5"];
	weaponsData[18] = ["iw5_dragunov_mp_dragunovscopevz", "viewmodel_dragunov_iw5"];
	weaponsData[19] = ["iw5_msr_mp_msrscopevz", "viewmodel_remington_msr_iw5"];
	weaponsData[20] = ["iw5_l96a1_mp_l96a1scopevz", "viewmodel_l96a1_iw5"];
	weaponsData[21] = ["iw5_as50_mp_as50scopevz", "viewmodel_as50_iw5"];
	weaponsData[22] = ["iw5_ksg_mp", "viewmodel_ksg_iw5"];
	weaponsData[23] = ["iw5_1887_mp", "weapon_model1887"];
	weaponsData[24] = ["iw5_striker_mp", "viewmodel_striker_iw5"];
	weaponsData[25] = ["iw5_aa12_mp", "viewmodel_aa12_iw5"];
	weaponsData[26] = ["iw5_usas12_mp", "viewmodel_usas12_iw5"];
	weaponsData[27] = ["iw5_spas12_mp", "viewmodel_spas12_iw5"];
	weaponsData[28] = ["iw5_m60_mp", "viewmodel_m60_iw5"];
	weaponsData[29] = ["iw5_mk46_mp", "viewmodel_mk46_iw5"];
	weaponsData[30] = ["iw5_pecheneg_mp", "viewmodel_pecheneg_iw5"];
	weaponsData[31] = ["iw5_sa80_mp", "weapon_sa80_iw5"];
	weaponsData[32] = ["iw5_mg36_mp", "viewmodel_mg36"];
	weaponsData[33] = ["iw5_44magnum_mp", "weapon_44_magnum_iw5"];
	weaponsData[34] = ["iw5_usp45_mp", "weapon_usp45_iw5"]; //no view_
	weaponsData[35] = ["iw5_deserteagle_mp", "weapon_desert_eagle_iw5"];
	weaponsData[36] = ["iw5_mp412_mp", "weapon_mp412"];
	weaponsData[37] = ["iw5_p99_mp", "weapon_walther_p99_iw5"];
	weaponsData[38] = ["iw5_fnfiveseven_mp", "weapon_fn_fiveseven_iw5"];
	weaponsData[39] = ["iw5_g18_mp", "viewmodel_g18_iw5"];
	weaponsData[40] = ["iw5_fmg9_mp", "viewmodel_fmg_iw5"];
	weaponsData[41] = ["iw5_mp9_mp", "viewmodel_mp9_iw5"];
	weaponsData[42] = ["iw5_skorpion_mp", "viewmodel_skorpion_iw5"];
	weaponsData[43] = ["m320_mp", "viewmodel_m320_gl"];
	weaponsData[44] = ["rpg_mp", "viewmodel_rpg7"];
	weaponsData[45] = ["iw5_smaw_mp", "viewmodel_smaw"];
	weaponsData[46] = ["stinger_mp", "weapon_stinger"]; 
	weaponsData[47] = ["xm25_mp", "viewmodel_xm25"];
	weaponsData[48] = ["riotshield_mp", "weapon_riot_shield_mp"];
	weaponsData[49] = ["iw5_ak74u_mp", "viewmodel_ak74u_iw5"];
	
	level.noCamo = ["iw5_44magnum_mp", "iw5_usp45_mp", "iw5_deserteagle_mp", "iw5_mp412_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp", "iw5_g18_mp", "iw5_fmg9_mp", "iw5_mp9_mp", "iw5_skorpion_mp", "m320_mp", "rpg_mp", "iw5_smaw_mp", "stinger_mp", "xm25_mp", "javelin_mp", "iw5_m60jugg_mp", "iw5_riotshieldjugg_mp", "riotshield_mp"];
	
	level.os_weapons = [];
	
	wep_index = randomNum(level.os_zones.size, 0, weaponsData.size);
	for (i = 0; i < wep_index.size; i++)
		level.os_weapons[i] = weaponsData[wep_index[i]];
}

loadEquipment()
{
	equipmentData = [];
	equipmentData[0] = ["frag_grenade_mp", "viewmodel_m67"]; 
	equipmentData[1] = ["semtex_mp", "projectile_semtex_grenade"];
	equipmentData[2] = ["throwingknife_mp", "viewmodel_knife"];
	equipmentData[3] = ["claymore_mp", "weapon_claymore"];
	equipmentData[4] = ["c4_mp", "viewmodel_c4"];
	equipmentData[5] = ["bouncingbetty_mp", "projectile_bouncing_betty_grenade"];
	equipmentData[6] = ["flash_grenade_mp", "weapon_m84_flashbang_grenade"]; 
	equipmentData[7] = ["concussion_grenade_mp", "viewmodel_concussion_grenade"];
	equipmentData[8] = ["smoke_grenade_mp", "viewmodel_ussmokegrenade"];
	equipmentData[9] = ["emp_grenade_mp", "viewmodel_light_marker"];
	equipmentData[10] = ["trophy_mp", "mp_trophy_system_folded"];
	equipmentData[11] = ["scrambler_mp", "viewmodel_jammer"];
	equipmentData[12] = ["portable_radar_mp", "viewmodel_radar"];
	equipmentData[13] = ["flare_mp", "mil_emergency_flare"];
	
	level.offHandClass = [];	
	level.offHandClass[0] = ["frag", "frag_grenade_mp"];
	level.offHandClass[1] = ["flash", "flash_grenade_mp", "scrambler_mp", "emp_grenade_mp", "trophy_mp", "tacticalinsertion_mp", "portable_radar_mp"];
	level.offHandClass[2] = ["other", "semtex_mp", "bouncingbetty_mp", "claymore_mp", "c4_mp"];
	level.offHandClass[3] = ["smoke", "concussion_grenade_mp", "smoke_grenade_mp"];
	level.offHandClass[4] = ["throwingknife", "throwingknife_mp"];
	
	level.os_equipment = [];	
	equipment_index = randomNum(5, 0, equipmentData.size);
	for (i = 0; i < equipment_index.size; i++)
		level.os_equipment[i] = equipmentData[equipment_index[i]];
}

loadPerks()
{
	perksData = ["specialty_fastreload", "specialty_quickdraw", "specialty_stalker", "specialty_bulletaccuracy", "specialty_quieter" ];
	
	level.os_perks = [];
	
	perk_index = randomNum(3, 0, perksData.size);
	for (i = 0; i < perk_index.size; i++)
		level.os_perks[i] = perksData[perk_index[i]];
}

spawnTargets()
{
	level.targets = [];	
	for (i = 0; i < level.os_zones.size; i++)
	{
		level.targets[i]["model"] = spawn("script_model", level.os_zones[i] - (0, 0, 10));
		level.targets[i]["model"] setModel(level.os_weapons[i][1]);		
		
		level.targets[i]["fx"] = spawnFx(level.os_fx["neutral"], level.os_zones[i] - (0, 0, 50), level.forward_fx, level.right_fx);
		triggerFx(level.targets[i]["fx"]);
		
		level.targets[i]["type"] = "weapon";
		level.targets[i]["item"] = level.os_weapons[i][0];
		level.targets[i]["neutral"] = true;		
		level.targets[i]["index"] = i;		
		
		if(getWeaponClass(level.os_weapons[i][0]) == "weapon_sniper")
			level.targets[i]["scope"] = spawnScopeSniper(level.targets[i]["model"]);
		
		wait(0.1);
	}	
	
	if(getDvarInt("os_equipment_enable"))
	{
		zones_index = randomNum(level.os_equipment.size, 0, level.os_zones.size);
		for (i = 0; i < zones_index.size; i++)
		{
			level.targets[zones_index[i]]["model"] setModel(level.os_equipment[i][1]);		
			level.targets[zones_index[i]]["type"] = "equipment";
			level.targets[zones_index[i]]["item"] = level.os_equipment[i][0];
			
			if(level.os_equipment[i][0] == "trophy_mp") level.targets[zones_index[i]]["model"].angles = (-90, 0, 0);
			else if (level.os_equipment[i][0] == "flare_mp") level.targets[zones_index[i]]["model"].angles = (90, 0, 0);
			else if (level.os_equipment[i][0] == "flash_grenade_mp") level.targets[zones_index[i]]["model"].angles = (0, 0, 90);
			
			if(isDefined(level.targets[zones_index[i]]["scope"])) level.targets[zones_index[i]]["scope"] delete();
		}
	}
	
	if(getDvarInt("os_perks_enable"))
	{
		zones_index = randomNum(level.os_perks.size, 0, level.os_zones.size);
		for (i = 0; i < zones_index.size; i++)
		{
			level.targets[zones_index[i]]["model"] setModel("weapon_scavenger_grenadebag");		
			level.targets[zones_index[i]]["type"] = "perk";
			level.targets[zones_index[i]]["item"] = level.os_perks[i];
			
			if(isDefined(level.targets[zones_index[i]]["scope"])) level.targets[zones_index[i]]["scope"] delete();	
		}
	}
	
	for(;;)
	{
		foreach (target in level.targets) 
			target["model"] rotateYaw(360, 5);
		wait(1);
	}
}

onUsedTarget(index)
{
	if(isDefined(level.targets[index]["scope"])) level.targets[index]["scope"] hide();	
	level.targets[index]["model"] hide();	
	level.targets[index]["neutral"] = false;	
	level.targets[index]["fx"] delete();
	level.targets[index]["fx"] = spawnFx(level.os_fx["enemy"], level.targets[index]["model"].origin - (0, 0, 40), level.forward_fx, level.right_fx);
	triggerFx(level.targets[index]["fx"]);
	
	wait(25);
	
	if(isDefined(level.targets[index]["scope"])) level.targets[index]["scope"] show();	
	level.targets[index]["model"] show();
	level.targets[index]["neutral"] = true;
	level.targets[index]["fx"] delete();
	level.targets[index]["fx"] = spawnFx(level.os_fx["neutral"], level.targets[index]["model"].origin - (0, 0, 40), level.forward_fx, level.right_fx);
	triggerFx(level.targets[index]["fx"]);
}

onPlayerConnect()
{
  for (;;)
  {
    level waittill("connected", player);	
	
	player.targetIndex = undefined;
	
	player.hudMsg = player createHudText("", "hudbig", 0.6f, "CENTER", "CENTER", 0, -50);	
	player notifyonplayercommand("select", "+activate");
	
	player thread selectAssign();
	player thread onPlayerSpawn();
	player thread playerTrigger();
	player thread stingerFire(); 
  }
}

onPlayerSpawn()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("spawned_player");
		
		if(getDvar("g_gametype") == "infect" && self.sessionteam == "axis") break;
		
		self.os_perks = "";
		
		self disableWeaponPickup();		
		self takeAllWeapons();		
		self clearPerks();
		self openMenu("perk_hide");		
		
		_giveWeapon(level.os_primary);		
		_giveWeapon(level.os_secondary); 
		self switchToWeapon(level.os_primary);
		self setSpawnWeapon(level.os_primary);		
		self.pers["primaryWeapon"] = level.os_primary;	
		self.primaryWeapon = level.os_primary;	
	}
}

onPlayerUsedTarget()
{
	self waittill("select");
	
	if(!isDefined(getTarget(self)) || !getTarget(self)["neutral"]) return;
	
	if(getTarget(self)["type"] == "weapon")
	{
		weapon = getTarget(self)["item"];
		if(getDvarInt("os_camos_enable")) weapon = addPlayerCamo(weapon);
		
		if(!(self hasWeapon(weapon))) 
		{
			if(getDvarInt("os_camos_enable")) weapon = setRandomCamo(weapon);
			
			self takeWeapon(self getCurrentWeapon());
			self giveWeapon(weapon);
			self switchToWeaponImmediate(weapon);
			self playLocalSound("mp_suitcase_pickup");
			
			level thread onUsedTarget(getTarget(self)["index"]);
		}
		else if (self getAmmoCount(weapon) != weaponStartAmmo(weapon))
		{
			self playLocalSound("scavenger_pack_pickup");
			self giveStartAmmo(weapon);
			
			level thread onUsedTarget(getTarget(self)["index"]);
		}
	}
	else if (getTarget(self)["type"] == "equipment") 
	{
		equipment = getTarget(self)["item"];
		equipment_class = getEquipmentClass(equipment);
		
		if(!(self hasWeapon(equipment)))
		{
			offhandWeapons = self getWeaponsListOffhands();	
			foreach(offhand in offhandWeapons)
				if(getEquipmentClass(offhand) == equipment_class)
					self takeWeapon(offhand);
			
			if(equipment_class == "flash" || equipment_class == "smoke") self setOffhandSecondaryClass(equipment_class);
			else self setOffhandPrimaryClass(equipment_class);
			
			if(equipment == "scrambler_mp")
				self thread maps\mp\gametypes\_scrambler::setScrambler();
			else if (equipment == "portable_radar_mp")
				self thread maps\mp\gametypes\_portable_radar::setPortableRadar();
			else if (equipment == "flare_mp")
				self maps\mp\perks\_perkfunctions::setTacticalInsertion();
			
			self _giveWeapon(equipment);
			self giveStartAmmo(equipment);	
			
			self playLocalSound("scavenger_pack_pickup");		
			level thread onUsedTarget(getTarget(self)["index"]);
		}
		else if (self getAmmoCount(equipment) != weaponStartAmmo(equipment) || self getWeaponAmmoStock(equipment) == 0)
		{
			if(equipment == "scrambler_mp")
				self thread maps\mp\gametypes\_scrambler::setScrambler();
			else if (equipment == "portable_radar_mp")
				self thread maps\mp\gametypes\_portable_radar::setPortableRadar();
			else if (equipment == "flare_mp")
				self maps\mp\perks\_perkfunctions::setTacticalInsertion();
			else self giveStartAmmo(equipment);
			
			self playLocalSound("scavenger_pack_pickup");
			level thread onUsedTarget(getTarget(self)["index"]);
		}
	}
	else if (getTarget(self)["type"] == "perk" && !os_HasPerk(self, getTarget(self)["item"])) 
	{
		perk = getTarget(self)["item"];
		
		self showPerksHud(perk);
		self.os_perks += perk + ";";
		self givePerk(perk, false);		
		self playLocalSound("scavenger_pack_pickup");
		
		level thread onUsedTarget(getTarget(self)["index"]);
	}
}

playerTrigger()
{
	for(;;)
	{
		if (!isAlive(self) || (getDvar("g_gametype") == "infect" && !level.infect_choseFirstInfected))
		{
			wait(0.5);
			continue;
		}
		
		if(!isAlive(self) || !isDefined(getTarget(self)) || !getTarget(self)["neutral"] || distance(getTarget(self)["model"].origin, self.origin) >= 70 || level.gameEnded || (getDvar("g_gametype") == "infect" && self.sessionteam == "axis"))
		{
			self.hudMsg.alpha = 0;
			self.hudMsg setText("");
			self.targetIndex = undefined;
			if(level.gameEnded || (getDvar("g_gametype") == "infect" && self.sessionteam == "axis")) break;
		}
		
		if (isDefined(getTarget(self)))
		{
			self thread onPlayerUsedTarget();
			
			self.hudMsg.alpha = 1;
			if(getTarget(self)["type"] == "weapon" || getTarget(self)["type"] == "equipment")
			{
				weapon = getTarget(self)["item"];				
				if(getDvarInt("os_camos_enable") && getTarget(self)["type"] != "equipment") weapon = addPlayerCamo(weapon);
				
				if(!(self hasWeapon(weapon))) 
					self.hudMsg setText("Press ^3[{+activate}] ^7to get weapon.");
				else if (self getAmmoCount(weapon) != weaponStartAmmo(weapon) || self getWeaponAmmoStock(weapon) == 0)
					self.hudMsg setText("Press ^3[{+activate}] ^7to get ammo.");
			}
			else if (getTarget(self)["type"] == "perk" && !os_HasPerk(self, getTarget(self)["item"])) 
				self.hudMsg setText("Press ^3[{+activate}] ^7to get perk.");
		}
		else
		{
			foreach(target in level.targets)
				if (distance(target["model"].origin, self.origin) <= 70)
				{
					if (!target["neutral"]) continue;
					self.targetIndex = target["index"];
					break;
				}
		}
		wait(0.1);
	}
}

selectAssign()
{
	gametype = getDvar("g_gametype");	
	
	if (gametype == "dm" || gametype == "oitc")
	{
		for(;;)
		{
			self waittill("end_respawn");
			
			self closeMenus();
			self notify("menuresponse", "team_marinesopfor", "autoassign");
			
			self waittill("joined_team");			
			self thread maps\mp\gametypes\_menus::bypassClassChoice();	
		}	
	}
	else if (gametype != "infect" && gametype != "gg")
	{
		for(;;)
		{
			self waittill("joined_team");
			self thread maps\mp\gametypes\_menus::bypassClassChoice();	
		}
	}	
}

stingerFire()
{
	self notifyOnPlayerCommand("attack", "+attack");
	
	for(;;)
	{
		self waittill("attack");
		
		if (self getCurrentWeapon() == "stinger_mp" && self playerAds() >= 1)
			if (self getWeaponAmmoClip(self getCurrentWeapon()) != 0)
			{
				vector = anglesToForward(self getPlayerAngles());
				dsa = (vector[0] * 1000000, vector[1] * 1000000, vector[2] * 1000000);
				magicBullet("stinger_mp", self getTagOrigin("tag_weapon_left"), dsa, self);
				self setWeaponAmmoClip("stinger_mp", 0);
			}	
		wait(0.3);
	}
}

getTarget(player)
{
	if(!isDefined(player.targetIndex)) return undefined;
	return level.targets[player.targetIndex];
}

os_HasPerk(player, perk)
{
	hasperk = false;
	foreach(_perk in StrTok(player.os_perks, ";"))
		if(_perk == perk)
		{
			hasPerk = true;
			break;
		}
	return hasPerk;
}

getNumInfected()
{
	numInfected = 0;
	foreach (player in level.players)
		if (player.sessionteam == "axis")
			numInfected++;
	return numInfected;	
}

getEquipmentClass(equipment)
{
	equipment_class = "";
	for(i = 0; i < level.offHandClass.size; i++)
	{
		if(equipment_class != "") break;		
		foreach(item in level.offHandClass[i])
			if(equipment == item)
			{
				equipment_class = level.offHandClass[i][0];
				break;
			}
	}
	return equipment_class;
}

randomNum(size, min, max)
{
	uniqueArray = [size];
	random = 0;

	for (i = 0; i < size; i++)
	{
		random = randomIntRange(min, max);
		for (j = i; j >= 0; j--)
			if (isDefined(uniqueArray[j]) && uniqueArray[j] == random)
			{
				random = randomIntRange(min, max);
				j = i;
			}
		uniqueArray[i] = random;
	}
	return uniqueArray;
}

createPerkHud(name, perk, color)
{
	perkIcon = createIconHud(perk, "TOPCENTER", "TOPCENTER", 0, 60, 90, 90);
	perkName = createHudText(name, "hudbig", 1, "TOPCENTER", "TOPCENTER", 0, 165);
	perkname.glowAlpha = 1;
	perkname.glowColor = color;
	perkname setPulseFX(100, 1000, 800);
	
	wait(1.4);
	perkIcon destroy();
}

showPerksHud(perk)
{
	switch (perk)
	{
		case "specialty_longersprint":
			self thread createPerkHud("Extreme Conditioning", "specialty_longersprint_upgrade", (0, 0, 1));
			break;
		case "specialty_fastreload":
			self thread createPerkHud("Sleight of Hand", "specialty_fastreload_upgrade", (0, 0, 1));
			break;
		case "specialty_quickdraw":
			self thread createPerkHud("Quickdraw", "specialty_quickdraw_upgrade", (1, 0, 0));
			break;
		case "specialty_stalker":
			self thread createPerkHud("Stalker", "specialty_stalker_upgrade", (0, 1, 0));
			break;
		case "specialty_bulletaccuracy":
			self thread createPerkHud("Steady Aim", "specialty_steadyaim_upgrade", (0, 1, 0));
			break;
		case "specialty_quieter":
			self thread createPerkHud("Dead Silent", "specialty_quieter_upgrade", (0, 1, 0));
			break;
	}
}

createHudText(text, font, size, align, relative, x, y)
{
	hudText = createFontString(font, size);
	hudText setpoint(align, relative, x, y);
	hudText setText(text); 
	hudText.alpha = 1;
	hudText.hideWhenInMenu = true;
	hudText.foreground = true;
	return hudText;
}

createIconHud(shader, align, relative, x, y, width, height)
{
	hudIcon = createIcon(shader, width, height);
	hudIcon.align = align;
    hudIcon.relative = relative;
    hudIcon.width = width;
    hudIcon.height = height;    
	hudIcon.alpha = 1;
    hudIcon.hideWhenInMenu = true;
	hudIcon.hidden = false;
    hudIcon.archived = false;	
    hudIcon setPoint(align, relative, x, y);
	hudIcon setParent(level.uiParent);
    return hudIcon;
}

spawnScopeSniper(ent_model)
{
	pos = ent_model.origin;
	model = "";
	
	switch(ent_model.model)
	{
		case "viewmodel_m82_iw5":
			pos += (0.6, 0, 3.45);
			model = "viewmodel_m82_scope_iw5";
			break;
		case "viewmodel_rsass_iw5":
			pos += (5, 0, 5.3);
			model = "viewmodel_rsass_scope_iw5";
			break;
		case "viewmodel_dragunov_iw5":
			pos += (4.5, 0.3, 4.5);
			model = "viewmodel_dragunov_scope_iw5";
			break;
		case "viewmodel_remington_msr_iw5":
			pos += (5.1, 0, 5.2);
			model = "viewmodel_remington_msr_scope_iw5";
			break;
		case "viewmodel_l96a1_iw5":
			pos += (5, 0, 5.3);
			model = "viewmodel_l96a1_scope_iw5";
			break;
		case "viewmodel_as50_iw5":
			pos += (0.5, 0, 3.5);
			model = "viewmodel_as50_scope_iw5";
			break;
	}
	
	scopedSniper = spawn("script_model", pos);
	scopedSniper setModel(model);
	scopedSniper linkTo(ent_model);
	
	return scopedSniper;
}

setRandomCamo(weapon)
{
	if(!weaponCamoAllowed(weapon)) return weapon;
	
	newWep = weapon;
	
	camoNum = randomIntRange(1, 13);
	if (camoNum < 10) newWep = weapon + "_camo0" + camoNum;
	else newWep = weapon + "_camo" + camoNum;
	return newWep;
}

addPlayerCamo(weapon)
{
	if(!weaponCamoAllowed(weapon)) return weapon;
	
	withCamo = weapon;
	for (i = 1; i < 13; i++)
	{
		if (i < 10)
		{
			if (self hasWeapon(weapon + "_camo0" + i))
			{
				withCamo = weapon + "_camo0" + i;
				break;
			}
		}
		else
		{
			if (self hasWeapon(weapon + "_camo" + i))
			{
				withCamo = weapon + "_camo" + i;
				break;
			}
		}
	}
	return withCamo;
}

weaponCamoAllowed(weapon)
{
	allowed = true;
	for(i = 0; i < level.noCamo.size; i++)
		if(level.noCamo[i] == weapon)
		{
			allowed = false;
			break;
		}
	return allowed;
}

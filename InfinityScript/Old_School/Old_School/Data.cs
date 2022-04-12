using System;
using System.Collections.Generic;
using System.Linq;
using InfinityScript;

namespace Old_School
{
    public partial class OldSchool
    {
        private static Vector3[] CurrentTargetZones;
        private static readonly List<Entity> ItemsList = new List<Entity>();
        private static readonly List<Entity> FXList = new List<Entity>();

        private static string PrimaryWeapon { get { return "iw5_skorpion_mp"; } }
        private static string SecondaryWeapon { get { return "iw5_usp45_mp"; } }
        private static string PerkModel { get { return "weapon_scavenger_grenadebag"; } }
        private static readonly string[] PerksList = { "specialty_fastreload", "specialty_quickdraw", "specialty_stalker", "specialty_paint", "specialty_bulletaccuracy", "specialty_quieter" };

        private static readonly int redcircle_fx = GSCFunctions.LoadFX("misc/ui_flagbase_red");
        private static readonly int goldcircle_fx = GSCFunctions.LoadFX("misc/ui_flagbase_gold");

        #region Weapons data
        private static string[] Weapons { get { return ListWeapons.Select(wep => wep.Split(';')[0]).ToArray(); } }
        private static readonly string[] ListWeapons = {  "iw5_m4_mp;weapon_m4_iw5",
                                           "iw5_ak47_mp;weapon_ak47_iw5",
                                           "iw5_m16_mp;weapon_m16_iw5",
                                           "iw5_fad_mp;weapon_fad_iw5",
                                           "iw5_acr_mp;weapon_remington_acr_iw5",
                                           "iw5_type95_mp;weapon_type95_iw5",
                                           "iw5_mk14_mp;weapon_m14_iw5",
                                           "iw5_scar_mp;weapon_scar_iw5",
                                           "iw5_g36c_mp;weapon_g36_iw5",
                                           "iw5_cm901_mp;weapon_cm901",
                                           "iw5_mp5_mp;weapon_mp5_iw5",
                                           "iw5_mp7_mp;weapon_mp7_iw5",
                                           "iw5_m9_mp;weapon_uzi_m9_iw5",
                                           "iw5_p90_mp;weapon_p90_iw5",
                                           "iw5_pp90m1_mp;weapon_pp90m1_iw5",
                                           "iw5_ump45_mp;weapon_ump45_iw5",
                                           "iw5_barrett_mp_barrettscopevz;weapon_m82_iw5",
                                           "iw5_rsass_mp_rsassscopevz;weapon_rsass_iw5",
                                           "iw5_dragunov_mp_dragunovscopevz;weapon_dragunov_iw5",
                                           "iw5_msr_mp_msrscopevz;weapon_remington_msr_iw5",
                                           "iw5_l96a1_mp_l96a1scopevz;weapon_l96a1_iw5",
                                           "iw5_as50_mp_as50scopevz;weapon_as50_iw5",
                                           "iw5_ksg_mp;weapon_ksg_iw5",
                                           "iw5_1887_mp;weapon_model1887",
                                           "iw5_striker_mp;weapon_striker_iw5",
                                           "iw5_aa12_mp;weapon_aa12_iw5",
                                           "iw5_usas12_mp;weapon_usas12_iw5",
                                           "iw5_spas12_mp;weapon_spas12_iw5",
                                           "iw5_m60_mp;weapon_m60_iw5",
                                           "iw5_mk46_mp;weapon_mk46_iw5",
                                           "iw5_pecheneg_mp;weapon_pecheneg_iw5",
                                           "iw5_sa80_mp;weapon_sa80_iw5",
                                           "iw5_mg36_mp;weapon_mg36",
                                           "iw5_44magnum_mp;weapon_44_magnum_iw5",
                                           "iw5_usp45_mp;weapon_usp45_iw5",
                                           "iw5_deserteagle_mp;weapon_desert_eagle_iw5",
                                           "iw5_mp412_mp;weapon_mp412",
                                           "iw5_p99_mp;weapon_walther_p99_iw5",
                                           "iw5_fnfiveseven_mp;weapon_fn_fiveseven_iw5",
                                           "iw5_g18_mp;weapon_g18_iw5",
                                           "iw5_fmg9_mp;weapon_fmg_iw5",
                                           "iw5_mp9_mp;weapon_mp9_iw5",
                                           "iw5_skorpion_mp;weapon_skorpion_iw5",
                                           "m320_mp;weapon_m320_gl",
                                           "rpg_mp;weapon_rpg7",
                                           "iw5_smaw_mp;weapon_smaw",
                                           "stinger_mp;weapon_stinger",
                                           "xm25_mp;weapon_xm25",
                                           "riotshield_mp;weapon_riot_shield_mp"};
        #endregion
        #region TargetZones data
        public static Dictionary<string, Vector3[]> TargetZones = new Dictionary<string, Vector3[]>()
        {
            { "mp_seatown", new Vector3[] { new Vector3(-1226, -1399, 204),
                                            new Vector3(1048, 886, 228),
                                            new Vector3(-1982, 1494, 229),
                                            new Vector3(-2297, -855, 210),
                                            new Vector3(-2261, -334, 248),
                                            new Vector3(-2048, 512, 248),
                                            new Vector3(-1439, 1065, 72),
                                            new Vector3(-410, 982, 127),
                                            new Vector3(-666, -217, 226),
                                            new Vector3(-523, -875, 260),
                                            new Vector3(-345, -1449, 254),
                                            new Vector3(1167, -533, 294),
                                            new Vector3(367, 991, 179),
                                            new Vector3(1106, 219, 292)}},

            { "mp_dome", new Vector3[] {    new Vector3(97, 898, -240),
                                            new Vector3(-226, 1464, -231),
                                            new Vector3(-603, 194, -358),
                                            new Vector3(814, -406, -335),
                                            new Vector3(5, 1975, -231),
                                            new Vector3(-673, 1100, -284),
                                            new Vector3(669, 1028, -255),
                                            new Vector3(1231, 807, -267),
                                            new Vector3(709, 210, -342),
                                            new Vector3(1223, 10, -336),
                                            new Vector3(-222, 418, -333),
                                            new Vector3(501, -183, -330)}},

            { "mp_plaza2", new Vector3[] {  new Vector3(221, 440, 754),
                                            new Vector3(155, 1763, 668),
                                            new Vector3(-430, 1871, 691),
                                            new Vector3(-1190, 1759, 668),
                                            new Vector3(-1273, 1279, 829),
                                            new Vector3(-593, 1274, 676),
                                            new Vector3(-251, 1006, 722),
                                            new Vector3(80, 1343, 676),
                                            new Vector3(397, -99, 708),
                                            new Vector3(-1109, 92, 741),
                                            new Vector3(-280, -195, 700),
                                            new Vector3(28, -1600, 668),
                                            new Vector3(764, -1752, 669)}},

            { "mp_mobalrig", new Vector3[] {    new Vector3(1448, 1945, 39),
                                                new Vector3(1499, -1193, 15),
                                                new Vector3(791, -880, 16),
                                                new Vector3(38, -1007, 16),
                                                new Vector3(-691, -260, 22),
                                                new Vector3(2, 52, 2),
                                                new Vector3(664, 69, 12),
                                                new Vector3(1676, 251, -1),
                                                new Vector3(2314, 1860, 63),
                                                new Vector3(73, 858, 3),
                                                new Vector3(710, 837, 16),
                                                new Vector3(-549, 829, 2),
                                                new Vector3(34, 1850, 84),
                                                new Vector3(-778, 2614, 157),
                                                new Vector3(-204, 3206, 152),
                                                new Vector3(752, 3189, 148),
                                                new Vector3(692, 2354, 95) }},

            { "mp_mogadishu", new Vector3[] {   new Vector3(1448, 1945, 39),
                                                new Vector3(1499, -1193, 15),
                                                new Vector3(791, -880, 16),
                                                new Vector3(38, -1007, 16),
                                                new Vector3(-691, -260, 22),
                                                new Vector3(2, 52, 2),
                                                new Vector3(664, 69, 12),
                                                new Vector3(1676, 251, -1),
                                                new Vector3(2314, 1860, 63),
                                                new Vector3(73, 858, 3),
                                                new Vector3(710, 837, 16),
                                                new Vector3(-549, 829, 2),
                                                new Vector3(34, 1850, 84),
                                                new Vector3(-778, 2614, 157),
                                                new Vector3(-204, 3206, 152),
                                                new Vector3(752, 3189, 148),
                                                new Vector3(692, 2354, 95) }},

            { "mp_paris", new Vector3[] {   new Vector3(-931, -921, 110),
                                            new Vector3(1597, 1768, 47),
                                            new Vector3(716, 1809, 33),
                                            new Vector3(258, 2074, 36),
                                            new Vector3(459, 1067, 37),
                                            new Vector3(852, 1350, 118),
                                            new Vector3(1601, 897, 45),
                                            new Vector3(1286, 420, 41),
                                            new Vector3(1613, 181, 172),
                                            new Vector3(466, -752, 67),
                                            new Vector3(994, -625, 50),
                                            new Vector3(-211, -60, 63),
                                            new Vector3(-742, 177, 133),
                                            new Vector3(-1532, 100, 250),
                                            new Vector3(-343, 1922, 121),
                                            new Vector3(-1127, 1555, 284),
                                            new Vector3(-2025, 1327, 316),
                                            new Vector3(-1039, 841, 187)}},

            { "mp_exchange", new Vector3[] {    new Vector3(-614, 1286, 113),
                                                new Vector3(182, 1155, 148),
                                                new Vector3(1018, 1254, 120),
                                                new Vector3(2182, 1322, 145),
                                                new Vector3(655, 815, 13),
                                                new Vector3(761, -312, -18),
                                                new Vector3(761, -771, 112),
                                                new Vector3(635, -1450, 110),
                                                new Vector3(152, -1538, 96),
                                                new Vector3(303, -824, 88),
                                                new Vector3(-953, -768, 45),
                                                new Vector3(2392, 1305, 144),
                                                new Vector3(1634, 1329, 151),
                                                new Vector3(1315, 743, 159)}},

            { "mp_bootleg", new Vector3[] {     new Vector3(-1432, 1404, 8),
                                                new Vector3(-1017, 1787, -39),
                                                new Vector3(-590, 1514, -43),
                                                new Vector3(-588, 614, -12),
                                                new Vector3(-1732, 84, 11),
                                                new Vector3(-1809, -302, 140),
                                                new Vector3(-1649, -1147, 92),
                                                new Vector3(-884, -1035, -4),
                                                new Vector3(-719, -1673, 60),
                                                new Vector3(-335, -2111, 60),
                                                new Vector3(208, -1955, 68),
                                                new Vector3(-198, -1726, 60),
                                                new Vector3(100, -1101, -9),
                                                new Vector3(-427, -100, -8),
                                                new Vector3(949, -1132, -10),
                                                new Vector3(884, 1182, -28),
                                                new Vector3(242, 1194, -45)}},

            { "mp_carbon", new Vector3[] {      new Vector3(-3330, -3392, 3630),
                                                new Vector3(-3635, -3735, 3630),
                                                new Vector3(-3625, -4189, 3633),
                                                new Vector3(-2992, -4339, 3627),
                                                new Vector3(-2925, -4999, 3673),
                                                new Vector3(-2573, -4771, 3784),
                                                new Vector3(-1705, -4643, 3813),
                                                new Vector3(-1799, -3957, 3813),
                                                new Vector3(-2141, -3647, 3815),
                                                new Vector3(-3212, -2879, 3807),
                                                new Vector3(-1623, -3339, 3808),
                                                new Vector3(-1223, -4234, 3834),
                                                new Vector3(-896, -4888, 3944),
                                                new Vector3(-228, -4535, 3975),
                                                new Vector3(-257, -3865, 3956),
                                                new Vector3(-215, -3260, 3967),
                                                new Vector3(-535, -3798, 3966)}},

            { "mp_hardhat", new Vector3[] {     new Vector3(2035, -229, 246),
                                                new Vector3(1959, -772, 352),
                                                new Vector3(1883, -1384, 351),
                                                new Vector3(848, -1520, 334),
                                                new Vector3(1326, -1380, 342),
                                                new Vector3(-338, -1273, 348),
                                                new Vector3(-821, -884, 348),
                                                new Vector3(-920, -290, 230),
                                                new Vector3(-463, -250, 333),
                                                new Vector3(-741, 208, 245),
                                                new Vector3(-201, 806, 437),
                                                new Vector3(224, 980, 436),
                                                new Vector3(1125, 656, 255),
                                                new Vector3(1531, 1241, 364),
                                                new Vector3(1522, 542, 244)}},

            { "mp_alpha", new Vector3[] {   new Vector3(-1979, 1653, 148),
                                            new Vector3(-1392, 1623, 60),
                                            new Vector3(-1697, 1205, 52),
                                            new Vector3(-1671, 692, 54),
                                            new Vector3(-572, -272, 55),
                                            new Vector3(634, -345, 52),
                                            new Vector3(391, 121, 60),
                                            new Vector3(291, 1271, 60),
                                            new Vector3(-459, 868, 52),
                                            new Vector3(-353, 1334, 52),
                                            new Vector3(-37, 1637, 52),
                                            new Vector3(-5, 2226, 52),
                                            new Vector3(-407, 2198, 196)}},

            { "mp_village", new Vector3[] {     new Vector3(647, 1891, 332),
                                                new Vector3(-26, 1749, 334),
                                                new Vector3(104, 1292, 323),
                                                new Vector3(-1064, 1552, 322),
                                                new Vector3(-599, 886, 378),
                                                new Vector3(-1038, 569, 317),
                                                new Vector3(-1899, 1217, 336),
                                                new Vector3(-1540, 289, 304),
                                                new Vector3(-454, -277, 270),
                                                new Vector3(-1734, -790, 365),
                                                new Vector3(-1418, -1371, 431),
                                                new Vector3(-928, -749, 417),
                                                new Vector3(-861, -2105, 408),
                                                new Vector3(-191, -1550, 400),
                                                new Vector3(357, -678, 245),
                                                new Vector3(-216, 295, 223),
                                                new Vector3(162, -199, 229),
                                                new Vector3(179, -3052, 447),
                                                new Vector3(510, -1790, 375),
                                                new Vector3(1089, -615, 398),
                                                new Vector3(1631, 394, 297),
                                                new Vector3(1007, 1385, 337),
                                                new Vector3(992, 248, 330),
                                                new Vector3(551, 732, 386)}},

            { "mp_lambeth",  new Vector3[] {    new Vector3(-293, -1286, -180),
                                                new Vector3(-938, -785, -130),
                                                new Vector3(-375, -250, -187),
                                                new Vector3(-355, 409, -196),
                                                new Vector3(161, -5, -181),
                                                new Vector3(682, -407, -197),
                                                new Vector3(694, 263, -196),
                                                new Vector3(690, 1158, -243),
                                                new Vector3(1181, 801, -67),
                                                new Vector3(1281, 1248, -257),
                                                new Vector3(2057, 757, -249),
                                                new Vector3(1470, -1040, -109),
                                                new Vector3(1761, -258, -210),
                                                new Vector3(2800, -652, -186),
                                                new Vector3(2785, 445, -244),
                                                new Vector3(2751, 1090, -263),
                                                new Vector3(1535, 1980, -214),
                                                new Vector3(1262, 2602, -213),
                                                new Vector3(419, 2218, -183),
                                                new Vector3(170, 1631, -182),
                                                new Vector3(-606, 1549, -201),
                                                new Vector3(-1199, 1030, -196)}},

            { "mp_radar", new Vector3[] {   new Vector3(-3482, -498, 1222),
                                            new Vector3(-4263, -124, 1229),
                                            new Vector3(-4006, 827, 1238),
                                            new Vector3(-3375, 342, 1222),
                                            new Vector3(-4623, 531, 1298),
                                            new Vector3(-5157, 877, 1200),
                                            new Vector3(-5950, 1071, 1305),
                                            new Vector3(-6509, 1660, 1299),
                                            new Vector3(-7013, 2955, 1359),
                                            new Vector3(-6333, 3473, 1421),
                                            new Vector3(-5675, 2923, 1388),
                                            new Vector3(-7119, 4357, 1380),
                                            new Vector3(-5487, 4077, 1356),
                                            new Vector3(-5736, 2960, 1407),
                                            new Vector3(-4908, 3281, 1225),
                                            new Vector3(-4421, 4071, 1268),
                                            new Vector3(-4979, 1816, 1205),
                                            new Vector3(-4874, 2306, 1223)}},

            { "mp_interchange", new Vector3[] {     new Vector3(2465, -402, 149),
                                                    new Vector3(2128, 199, 68),
                                                    new Vector3(1280, 1263, 126),
                                                    new Vector3(762, 1747, 114),
                                                    new Vector3(-9, 1836, 38),
                                                    new Vector3(-284, 1171, 159),
                                                    new Vector3(-1028, 944, 31),
                                                    new Vector3(-256, 264, 126),
                                                    new Vector3(462, -463, 158),
                                                    new Vector3(1029, -1045, 179),
                                                    new Vector3(1760, -1434, 142),
                                                    new Vector3(1538, -361, 142),
                                                    new Vector3(1150, -2977, 171),
                                                    new Vector3(371, -2883, 209),
                                                    new Vector3(399, -2149, 220)}},

            { "mp_underground", new Vector3[] {     new Vector3(-602, 3072, -68),
                                                    new Vector3(-285, 2551, -215),
                                                    new Vector3(574, 2656, -40),
                                                    new Vector3(-627, 1579, -196),
                                                    new Vector3(28, 1556, -196),
                                                    new Vector3(727, 1615, -196),
                                                    new Vector3(-1491, 1268, -196),
                                                    new Vector3(-1370, 1757, -196),
                                                    new Vector3(-1259, 599, -156),
                                                    new Vector3(-959, -26, 60),
                                                    new Vector3(-303, -562, 60),
                                                    new Vector3(193, -922, 60),
                                                    new Vector3(305, 817, -68),
                                                    new Vector3(-276, 370, -68)}},

            { "mp_bravo", new Vector3[] {   new Vector3(-1359, 608, 975),
                                            new Vector3(-1686, 313, 991),
                                            new Vector3(-1228, 41, 976),
                                            new Vector3(-732, -715, 1032),
                                            new Vector3(31, -771, 1038),
                                            new Vector3(986, -833, 1116),
                                            new Vector3(1800, -577, 1229),
                                            new Vector3(1588, -55, 1181),
                                            new Vector3(619, 916, 1175),
                                            new Vector3(-129, 1310, 1228),
                                            new Vector3(-726, 1272, 1268),
                                            new Vector3(-741, 752, 1053),
                                            new Vector3(6, -136, 1282)}},
    };
        #endregion

        private static int[] RandomNum(int size, int Min, int Max)
        {
            int[] UniqueArray = new int[size];
            Random rnd = new Random();
            int Random;

            for (int i = 0; i < size; i++)
            {
                Random = rnd.Next(Min, Max);

                for (int j = i; j >= 0; j--)
                    if (UniqueArray[j] == Random)
                    {
                        Random = rnd.Next(Min, Max);
                        j = i;
                    }

                UniqueArray[i] = Random;
            }
            return UniqueArray;
        }
        private static Entity SpawnModel(Vector3 origin, string model)
        {
            Entity entity = GSCFunctions.Spawn("script_model", origin);
            entity.SetModel(model);
            return entity;
        }

        private static string FindWepbyModel(string model)
        {
            string nam = null;
            foreach (string info in ListWeapons)
            {
                string wepname = info.Split(';')[0];
                string modelname = info.Split(';')[1];

                if (0 <= modelname.ToLower().IndexOf(model.ToLower(), StringComparison.InvariantCultureIgnoreCase))
                    nam = wepname;
            }

            return nam;
        }
        private static string FindModelbyWep(string wep)
        {
            string nam = null;
            foreach (string info in ListWeapons)
            {
                string wepname = info.Split(';')[0];
                string modelname = info.Split(';')[1];

                if (0 <= wepname.ToLower().IndexOf(wep.ToLower(), StringComparison.InvariantCultureIgnoreCase))
                    nam = modelname;
            }
            return nam;
        }

        private static void GivePerk(Entity player, string perk)
        {
            string slot_perks = player.GetField<string>("slotperks");
            if (PerksList.Contains(perk) && !HasPerk(player, perk)) slot_perks += "," + perk;
            player.SetField("slotperks", slot_perks);
            player.SetPerk(perk, true, false);
        }
        private static void GivePerk(Entity player, Entity perkfield)
        {
            GivePerk(player, perkfield.GetField<string>("perk"));
        }
        private static bool HasPerk(Entity player, string perk)
        {
            bool hasperk = false;
            if (!string.IsNullOrEmpty(player.GetField<string>("slotperks")))
                foreach (string p in player.GetField<string>("slotperks").Split(','))
                    if (p.Equals(perk)) hasperk = true;
            return hasperk;
        }
        private static bool HasPerk(Entity player, Entity perkfield)
        {
            return HasPerk(player, perkfield.GetField<string>("perk"));
        }

        private static Entity SpawnTriggerFX(int fxid, Vector3 pos)
        {
            Vector3 upangles = GSCFunctions.VectorToAngles(new Vector3(0, 0, 1000));
            Vector3 forward = GSCFunctions.AnglesToForward(upangles);
            Vector3 right = GSCFunctions.AnglesToRight(upangles);

            Entity effect = GSCFunctions.SpawnFX(fxid, pos, forward, right);
            GSCFunctions.TriggerFX(effect);

            return effect;
        }

        private static List<string> RandomWeapons()
        {
            List<string> wep_list = new List<string>();
            foreach (int index in RandomNum(CurrentTargetZones.Length, 0, Weapons.Length))
                wep_list.Add(Weapons[index]);
            return wep_list;
        }
        private static List<string> RandomPerks()
        {
            List<string> rnd_perks = new List<string>();
            foreach (int index in RandomNum(3, 0, PerksList.Length))
                rnd_perks.Add(PerksList[index]);
            return rnd_perks;
        }

        private static void DisableSelectClass(Entity player)
        {
            string team = GetTeamForClass(player);
            GSCFunctions.ClosePopUpMenu(player, "");
            GSCFunctions.CloseInGameMenu(player);
            player.Notify("menuresponse", "team_marinesopfor", team);
            player.OnNotify("joined_team", ent =>
            {
                AfterDelay(500, () => { ent.Notify("menuresponse", "changeclass", "class1"); });
            });
            player.OnNotify("menuresponse", (player2, menu, response) =>
            {
                if (menu.ToString().Equals("class") && response.ToString().Equals("changeclass_marines"))
                    AfterDelay(100, () => { player.Notify("menuresponse", "changeclass", "back"); });
            });
        }
        private static string GetTeamForClass(Entity player)
        {
            string gametype = GSCFunctions.GetDvar("g_gametype");
            string team = player.SessionTeam;
            if (gametype.Equals("dm") || gametype.Equals("oitc")) team = "axis";
            else if (gametype.Equals("infected")) team = "allies";
            return team;
        }
        private static void WelcomeGameMode(Entity player, string tittle, float[] rgb)
        {
            player.SetField("welcome", 0);
            player.SpawnedPlayer += new Action(() =>
            {
                if (player.GetField<int>("welcome") == 0)
                {
                    HudElem serverWelcome = HudElem.CreateFontString(player, HudElem.Fonts.HudBig, 1f);
                    serverWelcome.SetPoint("TOPCENTER", "TOPCENTER", 0, 165);
                    serverWelcome.SetText(tittle);
                    serverWelcome.GlowColor = (new Vector3(rgb[0], rgb[1], rgb[2]));
                    serverWelcome.GlowAlpha = 1f;
                    serverWelcome.SetPulseFX(150, 4700, 700);
                    player.SetField("welcome", 1);

                    AfterDelay(5000, () => { serverWelcome.Destroy(); });
                }
            });
        }

        private static bool IsModeTarget(Entity player)
        {
            bool isTarget = true;
            if (GSCFunctions.GetDvar("g_gametype") == "infect")
                if (player.SessionTeam == "axis") isTarget = false;
            return isTarget;
        }

        private static void Credits()
        {
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");
            InfinityScript.Log.Write(LogLevel.Info, "-       Lethal Beats: Old School Game Mode by LastDemon99       -");
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");

            GSCFunctions.MakeDvarServerInfo("didyouknow", "^2Old School script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("g_motd", "^2Old School script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("motd", "^2Old School script by LastDemon99");
        }
    }
}

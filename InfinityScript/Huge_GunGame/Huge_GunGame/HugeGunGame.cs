using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using InfinityScript;

namespace Huge_GunGame
{
    public class HugeGunGame : BaseScript
    {
        private List<string> Weapons = new List<string>();
        private bool GameEnded = false;

        public HugeGunGame()
        {
            PreCacheItems();
            LoadWepList();
            InfiniteStock();
            Credits();

            PlayerConnected += (player) => OnConnected(player);
        }

        private void LoadWepList()
        {
            int[] wepClass = RandomNum(10, 0, 10);
            string[] weplist;

            for (int i = 0; i < wepClass.Length; i++)
            {
                switch (wepClass[i])
                {
                    case 0:
                        weplist = ListRandomizer(Pistols);
                        foreach (string wep in weplist)
                            Weapons.Add(wep);
                        break;
                    case 1:
                        weplist = ListRandomizer(MachinePistols);
                        foreach (string wep in weplist)
                            Weapons.Add(wep);
                        break;
                    case 2:
                        weplist = ListRandomizer(Shotguns);
                        foreach (string wep in weplist)
                            Weapons.Add(wep);
                        break;
                    case 3:
                        weplist = ListRandomizer(SniperRifles);
                        foreach (string wep in weplist)
                            Weapons.Add(wep);
                        break;
                    case 4:
                        weplist = ListRandomizer(AssaultRifles);
                        foreach (string wep in weplist)
                            Weapons.Add(wep);
                        break;
                    case 5:
                        weplist = ListRandomizer(SubmachineGuns);
                        foreach (string wep in weplist)
                            Weapons.Add(wep);
                        break;
                    case 6:
                        weplist = ListRandomizer(LightMachineGuns);
                        foreach (string wep in weplist)
                            Weapons.Add(wep);
                        break;
                    case 7:
                        weplist = ListRandomizer(Launchers);
                        foreach (string wep in weplist)
                            Weapons.Add(wep);
                        break;
                }
            }
            Weapons.Add("javelin_mp");
        }
        private void InfiniteStock()
        {
            OnInterval(50, () =>
            {
                foreach(Entity player in Players)
                    if (player.IsAlive && IsModeTarget(player))
                        if (!LetalEquipment.Contains(GetCurrentWeapon(player)))
                            GSCFunctions.SetWeaponAmmoStock(player, player.CurrentWeapon, 45);
                return true;
            });
        }

        private void OnConnected(Entity player)
        {
            if (!GameEnded)
            {
                DisableSelectClass(player);
                WelcomeGameMode(player, "Huge GunGame", new float[] { 0, 0, 1 });
            }
            else
            {
                player.CloseMenu("team_marinesopfor");
                GSCFunctions.ClosePopUpMenu(player, "");
                GSCFunctions.CloseInGameMenu(player);
            }

            player.SetClientDvar("ui_mapname", "Huge GunGame");
            player.SetClientDvar("ui_gametype", "Huge GunGame");
            player.SetField("gun_num", 0);

            SetHud(player);
            EquipmenStock(player);
            StingerFire(player);

            player.SpawnedPlayer += () => OnSpawn(player);
        }
        private void OnSpawn(Entity player)
        {
            player.DisableWeaponPickup();
            player.ClearPerks();
            player.OpenMenu("perk_hide");

            if (IsModeTarget(player))
            {
                GiveWeapon(player);
                GiveAllPerks(player);
            }
        }

        private void SetHud(Entity player)
        {
            HudElem gungamehud = HudElem.CreateFontString(player, HudElem.Fonts.Small, 1.6f);
            gungamehud.SetPoint("TOP LEFT", "TOP LEFT", 115, 5);
            gungamehud.SetText("Weapon:");
            gungamehud.Alpha = 1f;
            gungamehud.HideWhenInMenu = true;
            gungamehud.Foreground = true;
            gungamehud.HideWhenDead = true;

            HudElem wepnum = HudElem.CreateFontString(player, HudElem.Fonts.Small, 1.6f);
            wepnum.SetPoint("TOP LEFT", "TOP LEFT", 115, 22);
            wepnum.SetText((GetCurrentWeaponIndex(player) + 1).ToString() + "/" + Weapons.Count);
            wepnum.Alpha = 1f;
            wepnum.HideWhenInMenu = true;
            wepnum.Foreground = true;
            wepnum.HideWhenDead = true;

            player.SetField("gun_hud", new Parameter(gungamehud));
            player.SetField("gun_count_hud", new Parameter(wepnum));
        }
        private void UpdateHud(Entity player)
        {
            player.GetField<HudElem>("gun_count_hud").SetText((GetCurrentWeaponIndex(player) + 1).ToString() + "/" + Weapons.Count);
        }

        private void GiveWeapon(Entity player)
        {
            string weapon = SetRandomCamo(GetCurrentWeapon(player));

            player.SetSpawnWeapon(weapon);
            player.TakeAllWeapons();

            player.GiveWeapon(weapon);
            player.SetSpawnWeapon(weapon);
            player.GiveMaxAmmo(weapon);
        }
        private void GiveAllPerks(Entity player)
        {
            player.SetPerk("specialty_longersprint", true, false);
            player.SetPerk("specialty_fastreload", true, false);
            player.SetPerk("specialty_scavenger", true, false);
            player.SetPerk("specialty_blindeye", true, false);
            player.SetPerk("specialty_paint", true, false);
            player.SetPerk("specialty_hardline", true, false);
            player.SetPerk("specialty_coldblooded", true, false);
            player.SetPerk("specialty_quickdraw", true, false);
            player.SetPerk("specialty_twoprimaries", true, false);
            player.SetPerk("specialty_assists", true, false);
            player.SetPerk("_specialty_blastshield", true, false);
            player.SetPerk("specialty_detectexplosive", true, false);
            player.SetPerk("specialty_autospot", true, false);
            player.SetPerk("specialty_bulletaccuracy", true, false);
            player.SetPerk("specialty_quieter", true, false);
            player.SetPerk("specialty_stalker", true, false);
        }

        private void SetWinning(Entity winner = null)
        {
            if (Players.Count != 0) winner = GetPlayersByScore().Max();
            if (winner != null)
            {
                HudElem firstTitle = HudElem.CreateServerFontString(HudElem.Fonts.HudBig, 1.75f);
                firstTitle.SetPoint("TOPCENTER", "TOPCENTER", 0, 165);
                firstTitle.SetText("^7" + winner.Name + " has won the game");
                firstTitle.GlowColor = (new Vector3(0, 0, 1));
                firstTitle.GlowAlpha = 1f;
                firstTitle.SetPulseFX(150, 10000, 15000);
            }

            GameEnded = true;
            GSCFunctions.SetGameEndTime(0);

            GSCFunctions.SetDvar("g_deadChat", 1);
            GSCFunctions.SetDvar("ui_allow_teamchange", 0);
            GSCFunctions.SetDvar("scr_gameended", 1);


            AfterDelay(500, () =>
            {
                foreach (Entity player in Players)
                {
                    GSCFunctions.VisionSetNaked("mpOutro");
                    if (player.SessionTeam != "spectator")
                    {
                        player.Notify("menuresponse", "team_marinesopfor", "spectator");
                        AfterDelay(100, () => player.CloseMenu("changeclass"));
                    }
                    else
                    {
                        player.Notify("spawned");
                        player.Notify("end_respawn");
                        player.SessionTeam = "intermission";
                    }
                }
            });

            foreach (Entity player in Players)
            {
                HideHud(player);

                if (player == winner) player.PlayLocalSound("winning_music");
                else player.PlayLocalSound("losing_music");
                player.SetDepthOfField(0, 128, 512, 4000, 6, 1.8f);
                player.Notify("reset_outcome");

                OnInterval(50, () =>
                {
                    player.ClosePopUpMenu("");
                    player.CloseInGameMenu();
                    player.FreezeControls(true);
                    return true;
                });
            }

            Notify("game_win", winner, "MP_TIME_LIMIT_REACHED");
            AfterDelay(10000, () =>
            {
                Notify("game_over");
                Notify("block_notifies");
            });
        }

        private void UpWeapon(Entity player)
        {
            if (GetCurrentWeaponIndex(player) >= Weapons.Count - 1)
                SetWinning(player);
            else if (GetCurrentWeaponIndex(player) < Weapons.Count)
            {
                player.PlayLocalSound("mp_enemy_obj_captured");
                player.PlayLocalSound("mp_killconfirm_tags_pickup");
                player.SetField("gun_num", GetCurrentWeaponIndex(player) + 1);
                UpdateHud(player);
                GiveWeapon(player);
            }
        }
        private void DownWeapon(Entity player)
        {
            if (GetCurrentWeaponIndex(player) > 0)
            {
                player.PlayLocalSound("mp_war_objective_lost");
                player.PlayLocalSound("mp_killconfirm_tags_deny");
                player.SetField("gun_num", GetCurrentWeaponIndex(player) - 1);
                GiveWeapon(player);
                UpdateHud(player);
            }
        }
        private void HideHud(Entity player)
        {
            player.GetField<HudElem>("gun_hud").Alpha = 0f;
            player.GetField<HudElem>("gun_count_hud").Alpha = 0f;
        }

        private bool IsModeTarget(Entity player)
        {
            bool isTarget = true;
            if (GSCFunctions.GetDvar("g_gametype") == "infect")
                if (player.SessionTeam == "axis") isTarget = false;
            return isTarget;
        }
        private void DisableSelectClass(Entity player)
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
        private string GetTeamForClass(Entity player)
        {
            string gametype = GSCFunctions.GetDvar("g_gametype");
            string team = player.SessionTeam;
            if (gametype.Equals("dm") || gametype.Equals("oitc")) team = "axis";
            else if (gametype.Equals("infected")) team = "allies";
            return team;
        }
        private void EquipmenStock(Entity player)
        {
            player.OnNotify("weapon_fired", (self, weapon) =>
            {
                if (LetalEquipment.Contains(weapon.As<string>()))
                {
                    player.SetField("save_wep", weapon.As<string>());
                    player.TakeAllWeapons();

                    AfterDelay(1500, () =>
                    {
                        if (LetalEquipment.Contains(GetCurrentWeapon(player)))
                        {
                            player.GiveWeapon(player.GetField<string>("save_wep"));
                            player.SwitchToWeaponImmediate(player.GetField<string>("save_wep"));
                        }
                    });
                }
            });
        }
        private void WelcomeGameMode(Entity player, string tittle, float[] rgb)
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
        private void Credits()
        {
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");
            InfinityScript.Log.Write(LogLevel.Info, "-     Lethal Beats: Huge GunGame Game Mode by LastDemon99       -");
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");

            GSCFunctions.MakeDvarServerInfo("didyouknow", "^2Huge GunGame script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("g_motd", "^2Huge GunGame script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("motd", "^2Huge GunGame script by LastDemon99");
        }

        private void StingerFire(Entity player)
        {
            player.NotifyOnPlayerCommand("attack", "+attack");
            player.OnNotify("attack", self =>
            {
                if (player.CurrentWeapon == "stinger_mp")
                {
                    if (GSCFunctions.PlayerAds(player) >= 1f)
                    {
                        if (GSCFunctions.GetWeaponAmmoClip(player, player.CurrentWeapon) != 0)
                        {
                            Vector3 vector = GSCFunctions.AnglesToForward(GSCFunctions.GetPlayerAngles(player));
                            Vector3 dsa = new Vector3(vector.X * 1000000f, vector.Y * 1000000f, vector.Z * 1000000f);
                            GSCFunctions.MagicBullet("stinger_mp", GSCFunctions.GetTagOrigin(player, "tag_weapon_left"), dsa, self);
                            GSCFunctions.SetWeaponAmmoClip(player, player.CurrentWeapon, 0);
                        }
                    }
                }
            });
        }
        private string SetRandomCamo(string weapon)
        {
            string newWep = weapon;
            if (!NoCamo.Contains(newWep))
            {
                int camo_num = GSCFunctions.RandomIntRange(1, 13);
                if (camo_num < 10)
                    newWep = weapon + "_camo0" + camo_num.ToString();
                else
                    newWep = weapon + "_camo" + camo_num.ToString();
            }
            return newWep;
        }

        private void PreCacheItems()
        {
            GSCFunctions.PreCacheItem("at4_mp");
            GSCFunctions.PreCacheItem("iw5_mk12spr_mp");
            GSCFunctions.PreCacheItem("iw5_mk12spr_mp_acog");
            GSCFunctions.PreCacheItem("uav_strike_marker_mp");
        }
        private int GetCurrentWeaponIndex(Entity player)
        {
            return player.GetField<int>("gun_num");
        }
        private string GetCurrentWeapon(Entity player)
        {
            return Weapons[player.GetField<int>("gun_num")];
        }
        private string[] ListRandomizer(string[] list)
        {
            int[] newAR = RandomNum(list.Length, 0, list.Length);
            List<string> newlist = new List<string>();
            for (int i = 0; i < newAR.Length; i++)
                newlist.Add(list[newAR[i]]);

            string[] _list = new string[newlist.Count];
            for (int i = 0; i < newlist.Count; i++)
                _list[i] = newlist[i];

            return _list;
        }
        private int[] RandomNum(int size, int Min, int Max)
        {
            int[] UniqueArray = new int[size];
            Random rnd = new Random();
            int Random;

            for (int i = 0; i < size; i++)
            {
                Random = rnd.Next(Min, Max);

                for (int j = i; j >= 0; j--)
                {

                    if (UniqueArray[j] == Random)
                    { Random = rnd.Next(Min, Max); j = i; }

                }
                UniqueArray[i] = Random;
            }
            return UniqueArray;
        }

        private Entity[] GetPlayersByScore()
        {
            return Players.OrderBy(player => GetCurrentWeaponIndex(player)).ToArray(); 
        }

        public override void OnPlayerKilled(Entity player, Entity inflictor, Entity attacker, int damage, string mod, string weapon, Vector3 dir, string hitLoc)
        {
            if (damage >= player.Health)
                if (player != attacker && mod == "MOD_FALLING" || (mod == "MOD_MELEE" && weapon != "riotshield_mp"))
                    DownWeapon(player);

            if ((mod == "MOD_PISTOL_BULLET") || (mod == "MOD_RIFLE_BULLET") || (mod == "MOD_HEAD_SHOT") || (mod == "MOD_PROJECTILE") || (mod == "MOD_PROJECTILE_SPLASH") ||
            (mod == "MOD_IMPACT") || (mod == "MOD_GRENADE") || (mod == "MOD_GRENADE_SPLASH") || (mod == "MOD_MELEE" && (weapon == "riotshield_mp" || weapon == "iw5_riotshieldjugg_mp")))
            {
                if (damage >= player.Health && weapon != attacker.CurrentWeapon)
                    return;

                if(GetCurrentWeapon(player) == weapon)
                    UpWeapon(attacker);
            }
        }

        #region Data
        public static string[] AssaultRifles = {  "iw5_m4_mp",
                                           "iw5_ak47_mp",
                                           "iw5_m16_mp",
                                           "iw5_fad_mp",
                                           "iw5_acr_mp",
                                           "iw5_type95_mp",
                                           "iw5_mk14_mp",
                                           "iw5_scar_mp",
                                           "iw5_g36c_mp",
                                           "iw5_cm901_mp",
                                           "iw5_mk12spr_mp" };

        public static string[] SubmachineGuns = {  "iw5_mp7_mp",
                                           "iw5_m9_mp",
                                           "iw5_p90_mp",
                                           "iw5_pp90m1_mp",
                                           "iw5_ump45_mp"};

        public static string[] SniperRifles = {  "iw5_barrett_mp_barrettscopevz",
                                           "iw5_rsass_mp_rsassscopevz",
                                           "iw5_dragunov_mp_dragunovscopevz",
                                           "iw5_msr_mp_msrscopevz",
                                           "iw5_l96a1_mp_l96a1scopevz",
                                           "iw5_as50_mp_as50scopevz"};

        public static string[] Shotguns = {  "iw5_ksg_mp",
                                           "iw5_1887_mp",
                                           "iw5_striker_mp",
                                           "iw5_aa12_mp",
                                           "iw5_usas12_mp",
                                           "iw5_spas12_mp"};

        public static string[] LightMachineGuns = {  "iw5_m60_mp",
                                           "iw5_mk46_mp",
                                           "iw5_pecheneg_mp",
                                           "iw5_sa80_mp",
                                           "iw5_mg36_mp"};

        public static string[] Pistols = {  "iw5_44magnum_mp",
                                           "iw5_usp45_mp",
                                           "iw5_deserteagle_mp",
                                           "iw5_mp412_mp",
                                           "iw5_p99_mp",
                                           "iw5_fnfiveseven_mp"};

        public static string[] MachinePistols = {  "iw5_g18_mp",
                                           "iw5_fmg9_mp",
                                           "iw5_mp9_mp",
                                           "iw5_skorpion_mp"};

        public static string[] Launchers = {  "m320_mp",
                                           "rpg_mp",
                                           "iw5_smaw_mp",
                                           "stinger_mp",
                                           "xm25_mp",
                                           "at4_mp" };

        public static string[] LetalEquipment = { "semtex_mp",
                                           "throwingknife_mp",
                                           "claymore_mp",
                                           "c4_mp",
                                           "bouncingbetty_mp"};

        public static string[] SpecialWeps = { "iw5_riotshieldjugg_mp",
                                           "uav_strike_marker_mp",
                                           "defaultweapon_mp",
                                           "at4_mp",
                                           "iw5_mk12spr_mp_acog",
                                           "iw5_m60jugg_mp_acog_xmags_camo03",
                                           "gl_mp"};

        private readonly string[] NoCamo = {  "iw5_44magnum_mp",
                                           "iw5_usp45_mp",
                                           "iw5_deserteagle_mp",
                                           "iw5_mp412_mp",
                                           "iw5_p99_mp",
                                           "iw5_fnfiveseven_mp",
                                           "iw5_g18_mp",
                                           "iw5_fmg9_mp",
                                           "iw5_mp9_mp",
                                           "iw5_skorpion_mp",
                                           "m320_mp",
                                           "rpg_mp",
                                           "iw5_smaw_mp",
                                           "stinger_mp",
                                           "xm25_mp",
                                           "javelin_mp",
                                           "iw5_m60jugg_mp",
                                           "iw5_riotshieldjugg_mp",
                                           "riotshield_mp",
                                           "at4_mp",
                                           "iw5_mk12spr_mp",
                                           "iw5_mk12spr_mp_acog",
                                           "uav_strike_marker_mp",
                                           "semtex_mp",
                                           "throwingknife_mp",
                                           "claymore_mp",
                                           "c4_mp",
                                           "bouncingbetty_mp"};
        #endregion
    }
}

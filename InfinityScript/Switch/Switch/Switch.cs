using System;
using System.Linq;
using InfinityScript;

namespace Switch
{
    public class Switch : BaseScript
    {
        public Switch()
        {
            InfiniteStock();
            Credits();

            PlayerConnected += (player) => OnConnected(player);
        }

        private void InfiniteStock()
        {
            OnInterval(50, () =>
            {
                foreach (Entity player in BaseScript.Players)
                    if(player.IsAlive && IsModeTarget(player))
                        GSCFunctions.SetWeaponAmmoStock(player, player.CurrentWeapon, 45);
                return true;
            });
        }

        private void OnConnected(Entity player)
        {
            DisableSelectClass(player);
            WelcomeGameMode(player, "Switch", new float[] { 0, 0, 1 });

            player.SetClientDvar("ui_mapname", "Switch");
            player.SetClientDvar("ui_gametype", "Switch");

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
        private void GiveWeapon(Entity player)
        {
            int index = GSCFunctions.RandomIntRange(0, DefaultWeapons.Length);
            string weapon = SetRandomCamo(DefaultWeapons[index]);

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
        private static bool IsModeTarget(Entity player)
        {
            bool isTarget = true;
            if (GSCFunctions.GetDvar("g_gametype") == "infect")
                if (player.SessionTeam == "axis") isTarget = false;
            return isTarget;
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

        public override void OnPlayerKilled(Entity player, Entity inflictor, Entity attacker, int damage, string mod, string weapon, Vector3 dir, string hitLoc)
        {
            if (damage >= player.Health && player != attacker)
                if (mod != "MOD_MELEE" || weapon == "riotshield_mp")
                    GiveWeapon(attacker);
        }

        private static void Credits()
        {
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");
            InfinityScript.Log.Write(LogLevel.Info, "-       Lethal Beats: Switch Game Mode by LastDemon99       -");
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");

            GSCFunctions.MakeDvarServerInfo("didyouknow", "^2Switch script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("g_motd", "^2Switch script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("motd", "^2Switch script by LastDemon99");
        }

        private readonly string[] DefaultWeapons = {  "iw5_m4_mp",
                                           "iw5_ak47_mp",
                                           "iw5_m16_mp",
                                           "iw5_fad_mp",
                                           "iw5_acr_mp",
                                           "iw5_type95_mp",
                                           "iw5_mk14_mp",
                                           "iw5_scar_mp",
                                           "iw5_g36c_mp",
                                           "iw5_cm901_mp",
                                           "iw5_mp5_mp",
                                           "iw5_mp7_mp",
                                           "iw5_m9_mp",
                                           "iw5_p90_mp",
                                           "iw5_pp90m1_mp",
                                           "iw5_ump45_mp",
                                           "iw5_barrett_mp_barrettscopevz",
                                           "iw5_rsass_mp_rsassscopevz",
                                           "iw5_dragunov_mp_dragunovscopevz",
                                           "iw5_msr_mp_msrscopevz",
                                           "iw5_l96a1_mp_l96a1scopevz",
                                           "iw5_as50_mp_as50scopevz",
                                           "iw5_ksg_mp",
                                           "iw5_1887_mp",
                                           "iw5_striker_mp",
                                           "iw5_aa12_mp",
                                           "iw5_usas12_mp",
                                           "iw5_spas12_mp",
                                           "iw5_m60_mp",
                                           "iw5_mk46_mp",
                                           "iw5_pecheneg_mp",
                                           "iw5_sa80_mp",
                                           "iw5_mg36_mp",
                                           "iw5_44magnum_mp",
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
                                           "riotshield_mp",
                                           "javelin_mp"};

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
                                           "riotshield_mp"};

    }
}

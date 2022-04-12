using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using InfinityScript;

namespace Random_Sniper
{
    public class RandomSniper : BaseScript
    {
        public RandomSniper()
        {
            InfiniteStock();
            SniperSemiNerf();
            Credits();

            PlayerConnected += (player) => OnConnected(player);
        }

        private void OnConnected(Entity player)
        {
            DisableSelectClass(player);
            WelcomeGameMode(player, "Random Sniper", new float[] { 0, 0, 1 });

            player.SetClientDvar("ui_mapname", "Random Sniper");
            player.SetClientDvar("ui_gametype", "Random Sniper");

            player.OnNotify("weapon_fired", (self, weapon) =>
            {
                player.SetField("noreload", false);
                AfterDelay(700, () => { player.SetField("noreload", true); });
            });

            player.SpawnedPlayer += () => OnSpawn(player);
        }
        private void OnSpawn(Entity player)
        {
            player.DisableWeaponPickup();
            player.ClearPerks();
            player.OpenMenu("perk_hide");
            player.SetField("noreload", true);

            if (IsModeTarget(player))
            {
                GiveWeapon(player);
                GiveAllPerks(player);
            }
        }

        private void InfiniteStock()
        {
            OnInterval(50, () =>
            {
                foreach (Entity player in BaseScript.Players)
                    if (player.IsAlive && IsModeTarget(player))
                        GSCFunctions.SetWeaponAmmoStock(player, player.CurrentWeapon, 45);
                return true;
            });
        }
        private void SniperSemiNerf()
        {
            OnInterval(50, () =>
            {
                foreach (Entity player in Players)
                {
                    if (player.HasField("noreload") && player.GetField<bool>("noreload") == true)
                        GSCFunctions.SetWeaponAmmoStock(player, player.CurrentWeapon, GSCFunctions.WeaponStartAmmo(player.CurrentWeapon));
                    else
                        GSCFunctions.SetWeaponAmmoClip(player, player.CurrentWeapon, 0);

                    if (GSCFunctions.IsReloading(player))
                        GSCFunctions.SetWeaponAmmoClip(player, player.CurrentWeapon, 40);

                    GSCFunctions.SetWeaponAmmoStock(player, player.CurrentWeapon, GSCFunctions.WeaponStartAmmo(player.CurrentWeapon));
                }
                return true;
            });
        }

        private void GiveWeapon(Entity player)
        {
            int index = GSCFunctions.RandomIntRange(0, SniperRifles.Length);
            string weapon = SniperRifles[index];

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
        private static bool IsModeTarget(Entity player)
        {
            bool isTarget = true;
            if (GSCFunctions.GetDvar("g_gametype") == "infect")
                if (player.SessionTeam == "axis") isTarget = false;
            return isTarget;
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
        private static void Credits()
        {
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");
            InfinityScript.Log.Write(LogLevel.Info, "-     Lethal Beats: Random Sniper Game Mode by LastDemon99      -");
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");

            GSCFunctions.MakeDvarServerInfo("didyouknow", "^2Random Sniper script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("g_motd", "^2Random Sniper script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("motd", "^2Random Sniper script by LastDemon99");
        }

        public override void OnPlayerDamage(Entity player, Entity inflictor, Entity attacker, int damage, int dFlags, string mod, string weapon, Vector3 point, Vector3 dir, string hitLoc)
        {
            if (SniperRifles.Contains(weapon))
                if (player != attacker) player.Health = 0;
        }

        private static readonly string[] SniperRifles = {  "iw5_barrett_mp_barrettscopevz",
                                           "iw5_rsass_mp_rsassscopevz",
                                           "iw5_dragunov_mp_dragunovscopevz",
                                           "iw5_msr_mp_msrscopevz",
                                           "iw5_l96a1_mp_l96a1scopevz",
                                           "iw5_as50_mp_as50scopevz"};
    }
}

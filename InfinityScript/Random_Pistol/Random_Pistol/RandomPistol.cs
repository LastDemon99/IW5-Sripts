using System;
using InfinityScript;

namespace Random_Pistol
{
    public class RandomPistol : BaseScript
    {
        public RandomPistol()
        {
            InfiniteStock();
            Credits();

            PlayerConnected += (player) => OnConnected(player);
        }

        private void OnConnected(Entity player)
        {
            DisableSelectClass(player);
            WelcomeGameMode(player, "Random Pistol", new float[] { 0, 0, 1 });

            player.SetClientDvar("ui_mapname", "Random Pistol");
            player.SetClientDvar("ui_gametype", "Random Pistol");

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

        private void GiveWeapon(Entity player)
        {
            int index = GSCFunctions.RandomIntRange(0, Pistols.Length);
            string weapon = Pistols[index];

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
            InfinityScript.Log.Write(LogLevel.Info, "-     Lethal Beats: Random Pistol Game Mode by LastDemon99      -");
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");

            GSCFunctions.MakeDvarServerInfo("didyouknow", "^2Random Pistol script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("g_motd", "^2Random Pistol script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("motd", "^2Random Pistol script by LastDemon99");
        }

        private static readonly string[] Pistols = {  "iw5_44magnum_mp",
                                           "iw5_usp45_mp",
                                           "iw5_deserteagle_mp",
                                           "iw5_mp412_mp",
                                           "iw5_p99_mp",
                                           "iw5_fnfiveseven_mp"};
    }
}

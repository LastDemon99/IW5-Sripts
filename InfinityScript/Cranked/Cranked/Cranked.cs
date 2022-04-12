using System;
using InfinityScript;

namespace Cranked
{
    public class Cranked : BaseScript
    {
        private readonly int crank_time = 30;
        private readonly int Explosion = GSCFunctions.LoadFX("explosions/oxygen_tank_explosion");
        private static readonly string[] PerksList = { "specialty_longersprint", "specialty_fastreload", "specialty_quickdraw", "specialty_stalker", "specialty_paint", "specialty_bulletaccuracy", "specialty_quieter" };

        public Cranked()
        {
            PreCacheShader();
            EnableBunnyHop();
            Credits();

            PlayerConnected += (player) => OnConnected(player);
        }

        private void OnConnected(Entity player)
        {
            WelcomeGameMode(player, "Cranked", new float[] { 0, 0, 1 });

            player.SetClientDvar("ui_mapname", "Cranked");
            player.SetClientDvar("ui_gametype", "Cranked");
            player.SetField("is_crank", false);
            player.SetField("killstreak", 0);

            SetHud(player);
        }

        private void SetCranked(Entity player)
        {
            player.SetField("is_crank", true);
            player.SetPerk("specialty_longersprint", true, false);
            ShowHud(player);

            HudElem timer = player.GetField<HudElem>("crank_time");
            timer.SetTenthsTimer(crank_time);

            bool is_crank = true;
            OnInterval(100, () =>
            {
                is_crank = player.GetField<bool>("is_crank");
                return is_crank;
            });

            int count = 0;
            OnInterval(1000, () =>
            {
                if (is_crank)
                {
                    if (count == crank_time - 1) player.PlaySound("javelin_clu_lock");
                    if (count >= crank_time) CleanCranked(player);
                    else if (count >= 15)
                    {
                        TimerMotion(timer);
                        player.PlaySound("scrambler_beep");
                    }
                    count++;
                }
                return is_crank;
            });
        }
        private void ResetCranked(Entity player)
        {
            player.SetField("is_crank", false);
            player.PlaySound("talon_damaged");
            TimerMotion(player.GetField<HudElem>("crank_time"));
            AfterDelay(350, () => { SetCranked(player); });
        }
        private void CleanCranked(Entity player)
        {
            player.SetField("is_crank", false);
            GSCFunctions.PlaySoundAtPos(player.Origin, "detpack_explo_default");
            GSCFunctions.PlaySoundAtPos(player.Origin, "talon_destroyed");
            GSCFunctions.PlayFX(Explosion, GSCFunctions.GetTagOrigin(player, "tag_origin"));
            AfterDelay(0, () => player.Suicide());
            HideHud(player);
        }

        private void SetHud(Entity player)
        {
            HudElem cranktime = HudElem.CreateFontString(player, HudElem.Fonts.Objective, 1.5f);
            cranktime.SetPoint("CENTER", "CENTER", -180, 35);
            cranktime.SetText("0:" + crank_time.ToString() + ".0");
            cranktime.Alpha = 0f;
            cranktime.HideWhenInMenu = true;
            cranktime.Foreground = true;
            cranktime.HideWhenDead = true;

            HudElem crankstring = HudElem.CreateFontString(player, HudElem.Fonts.Objective, 0.7f);
            crankstring.SetPoint("CENTER", "CENTER", -143, 45);
            crankstring.SetText("^3CRANKED");
            crankstring.Alpha = 0f;
            crankstring.HideWhenInMenu = true;
            crankstring.Foreground = true;
            crankstring.HideWhenDead = true;

            HudElem bar1 = HudElem.CreateIcon(player, "gradient", 120, 23);
            bar1.Parent = HudElem.UIParent;
            bar1.SetPoint("CENTER", "CENTER", -150, 39);
            bar1.SetShader("gradient", 120, 23);
            bar1.Foreground = false;
            bar1.HideWhenInMenu = true;
            bar1.Alpha = 0f;

            HudElem bar2 = HudElem.CreateIcon(player, "gradient", 120, 15);
            bar2.Parent = HudElem.UIParent;
            bar2.SetPoint("CENTER", "CENTER", -150, 35);
            bar2.SetShader("gradient", 120, 15);
            bar2.Foreground = false;
            bar2.HideWhenInMenu = true;
            bar2.Alpha = 0f;

            HudElem bar3 = HudElem.CreateIcon(player, "gradient_fadein", 5, 23);
            bar3.Parent = HudElem.UIParent;
            bar3.SetPoint("CENTER", "CENTER", -212, 39);
            bar3.SetShader("gradient_fadein", 5, 23);
            bar3.Foreground = true;
            bar3.HideWhenInMenu = true;
            bar3.Alpha = 0f;

            HudElem icon = HudElem.CreateIcon(player, "waypoint_bomb", 13, 12);
            icon.Parent = HudElem.UIParent;
            icon.SetPoint("CENTER", "CENTER", -117, 43);
            icon.SetShader("waypoint_bomb", 13, 12);
            icon.Foreground = true;
            icon.HideWhenInMenu = true;
            icon.Alpha = 0f;

            player.SetField("crank_time", cranktime);
            player.SetField("crank_tittle", crankstring);
            player.SetField("crank_bar1", bar1);
            player.SetField("crank_bar2", bar2);
            player.SetField("crank_bar3", bar3);
            player.SetField("crank_icon", icon);
        }
        private void ShowHud(Entity player)
        {
            player.PlaySound("recondrone_tag");
            HudElem[] hud = GetCrankedHud(player);
            for (int i = 0; i < hud.Length; i++)
            {
                hud[i].FadeOverTime(0.7f);

                if (i == 0) TimerMotion(hud[i]);

                if (i == 2) hud[i].Alpha = 0.8f;
                else if (i == 3) hud[i].Alpha = 0.5f;
                else hud[i].Alpha = 1f;
            }
        }
        private void HideHud(Entity player)
        {
            player.PlaySound("talon_damaged");
            foreach (HudElem hud in GetCrankedHud(player))
                hud.Alpha = 0f;
        }

        private void TimerMotion(HudElem timer)
        {
            float current_scale = timer.FontScale;
            timer.Color = new Vector3(1, 0, 0);
            timer.FontScale = (current_scale + 0.15f);

            AfterDelay(350, () => { timer.FontScale = current_scale; });
            AfterDelay(600, () => { timer.Color = new Vector3(1, 1, 1); });
        }
        private HudElem[] GetCrankedHud(Entity player)
        {
            HudElem time = player.GetField<HudElem>("crank_time");
            HudElem tittle = player.GetField<HudElem>("crank_tittle");
            HudElem bar1 = player.GetField<HudElem>("crank_bar1");
            HudElem bar2 = player.GetField<HudElem>("crank_bar2");
            HudElem bar3 = player.GetField<HudElem>("crank_bar3");
            HudElem icon = player.GetField<HudElem>("crank_icon");

            return new HudElem[] { time, tittle, bar1, bar2, bar3, icon};
        }

        private void GivePerkHud(Entity player, string name, string perk, string color)
        {
            HudElem perkicon = HudElem.CreateIcon(player, perk, 90, 90);
            perkicon.Parent = HudElem.UIParent;
            perkicon.SetPoint("TOPCENTER", "TOPCENTER", 0, 60);
            perkicon.SetShader(perk, 90, 90);
            perkicon.Foreground = true;
            perkicon.HideWhenInMenu = true;
            AfterDelay(1400, () => { perkicon.Destroy(); });

            HudElem perkname = HudElem.CreateFontString(player, HudElem.Fonts.HudBig, 1f);
            perkname.SetPoint("TOPCENTER", "TOPCENTER", 0, 165);
            perkname.SetText(name);
            perkname.GlowAlpha = 1f;
            perkname.SetPulseFX(100, 1000, 600);

            switch (color)
            {
                case "green":
                    perkname.GlowColor = (new Vector3(0f, 1f, 0f));
                    break;
                case "blue":
                    perkname.GlowColor = (new Vector3(0f, 0f, 1f));
                    break;
                case "red":
                    perkname.GlowColor = (new Vector3(1f, 0f, 0f));
                    break;
                default:
                    perkname.GlowColor = (new Vector3(245f, 208f, 051f));
                    break;
            }
        }
        private void ShowPerksHud(Entity player, string perk)
        {
            switch (perk)
            {
                case "specialty_longersprint":
                    GivePerkHud(player, "Extreme Conditioning", "specialty_longersprint_upgrade", "blue");
                    break;
                case "specialty_fastreload":
                    GivePerkHud(player, "Sleight of Hand", "specialty_fastreload_upgrade", "blue");
                    break;
                case "specialty_quickdraw":
                    GivePerkHud(player, "Quickdraw", "specialty_quickdraw_upgrade", "red");
                    break;
                case "specialty_stalker":
                    GivePerkHud(player, "Stalker", "specialty_stalker_upgrade", "green");
                    break;
                case "specialty_paint":
                    GivePerkHud(player, "Recon", "specialty_paint_upgrade", "blue");
                    break;
                case "specialty_bulletaccuracy":
                    GivePerkHud(player, "Steady Aim", "specialty_steadyaim_upgrade", "green");
                    break;
                case "specialty_quieter":
                    GivePerkHud(player, "Dead Silent", "specialty_quieter_upgrade", "green");
                    break;
            }
        }

        private static bool IsModeTarget(Entity player)
        {
            bool isTarget = true;
            if (GSCFunctions.GetDvar("g_gametype") == "infect")
                if (player.SessionTeam == "axis") isTarget = false;
            return isTarget;
        }

        private void PreCacheShader()
        {
            GSCFunctions.PreCacheShader("gradient");
            GSCFunctions.PreCacheShader("gradient_fadein");
            GSCFunctions.PreCacheShader("waypoint_bomb");
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
            InfinityScript.Log.Write(LogLevel.Info, "-        Lethal Beats: Cranked Game Mode by LastDemon99         -");
            InfinityScript.Log.Write(LogLevel.Info, "-----------------------------------------------------------------");

            GSCFunctions.MakeDvarServerInfo("didyouknow", "^2Cranked script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("g_motd", "^2Cranked Pistol script by LastDemon99");
            GSCFunctions.MakeDvarServerInfo("motd", "^2Cranked Pistol script by LastDemon99");
        }

        public unsafe void EnableBunnyHop()
        {
            int[] addr = { 0x0422AB6, 0x0422AAF, 0x041E00C, 0x0414127, 0x04141b4, 0x0414e027, 0x0414b126, 0x041416d, 0x041417c };
            byte nop = 0x90;
            for (int i = 0; i < 7; ++i)
            {

                *((byte*)addr[7] + i) = nop;
                *((byte*)addr[8] + i) = nop;
                *((byte*)addr[i]) = nop;
                *((byte*)(addr[i] + 1)) = nop;
            }
        }

        public override void OnPlayerDamage(Entity player, Entity inflictor, Entity attacker, int damage, int dFlags, string mod, string weapon, Vector3 point, Vector3 dir, string hitLoc)
        {
            if (mod == "MOD_FALLING") player.Health += damage;
        }

        public override void OnPlayerKilled(Entity player, Entity inflictor, Entity attacker, int damage, string mod, string weapon, Vector3 dir, string hitLoc)
        {
            if (damage >= player.Health)
            {
                if (player.GetField<bool>("is_crank")) CleanCranked(player);
                if (player != attacker && IsModeTarget(attacker))
                {
                    if (attacker.GetField<bool>("is_crank")) ResetCranked(attacker);
                    else SetCranked(attacker);

                    attacker.SetField("killstreak", attacker.GetField<int>("killstreak") + 1);
                    int attacker_killstreak = attacker.GetField<int>("killstreak");
                    if (attacker_killstreak < PerksList.Length)
                    {
                        ShowPerksHud(attacker, PerksList[attacker_killstreak]);
                        attacker.SetPerk(PerksList[attacker_killstreak], true, false);
                    }
                }
                player.SetField("killstreak", 0);
            }
        }
    }
}

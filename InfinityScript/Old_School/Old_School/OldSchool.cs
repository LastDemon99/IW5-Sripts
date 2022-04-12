using System;
using System.Collections.Generic;
using System.Linq;
using InfinityScript;

namespace Old_School
{
    public partial class OldSchool : BaseScript
    {
        public OldSchool()
        {
            CurrentTargetZones = TargetZones[GSCFunctions.GetDvar("mapname")];

            PreCachePerksHud();
            SpawnItems();
            TriggerItemMSG();
            EnableBunnyHop();
            Credits();

            PlayerConnected += (player) => OnConnected(player);
        }

        private void OnConnected(Entity player)
        {
            DisableSelectClass(player);
            StingerFire(player);
            WelcomeGameMode(player, "Old School FFA", new float[] { 0, 0, 1 });

            player.SetClientDvar("ui_mapname", "Old School");
            player.SetClientDvar("ui_gametype", "Old School");

            HudElem message = HudElem.CreateFontString(player, HudElem.Fonts.HudBig, 0.6f);
            message.SetPoint("CENTER", "CENTER", 0, -50);
            message.SetText("");
            message.Alpha = 0f;

            player.SetField("msg_hud", message);
            player.SetField("item_msg", false);

            UseItem(player);

            player.SpawnedPlayer += () => OnSpawn(player);
        }
        private void OnSpawn(Entity player)
        {
            player.DisableWeaponPickup();
            player.ClearPerks();
            player.OpenMenu("perk_hide");

            player.SetSpawnWeapon(PrimaryWeapon);
            player.TakeAllWeapons();

            player.GiveWeapon(PrimaryWeapon);
            player.GiveWeapon(SecondaryWeapon);
            player.SetSpawnWeapon(PrimaryWeapon);

            player.SetField("slotperks", ",");

            GivePerk(player, "specialty_longersprint");
            GivePerk(player, "specialty_fastsprintrecovery");

            AfterDelay(500, () => { player.SwitchToWeaponImmediate(PrimaryWeapon); });
        }

        private void SpawnItems()
        {
            List<string> wep_list = RandomWeapons();
            List<string> perk_list = RandomPerks();

            for (int i = 0; i < CurrentTargetZones.Length; i++)
            {
                Entity item = SpawnModel(CurrentTargetZones[i] - new Vector3(0, 0, 10), FindModelbyWep(wep_list[i]));
                item.SetField("used", 0);
                ItemsList.Add(item);

                Entity fx = SpawnTriggerFX(goldcircle_fx, CurrentTargetZones[i] + new Vector3(0, 0, -50));
                FXList.Add(fx);
            }

            int perk_index = 0;
            foreach (int index in RandomNum(perk_list.Count, 0, ItemsList.Count))
            {
                ItemsList[index].SetModel(PerkModel);
                ItemsList[index].SetField("perk", perk_list[perk_index]);
                perk_index++;
            }

            OnInterval(5000, () =>
            {
                foreach (Entity ent in ItemsList) ent.RotateYaw(360, 5);
                return true;
            });
        }
        private void TriggerItemMSG()
        {
            OnInterval(50, () =>
            {
                foreach (Entity player in Players)
                    foreach (Entity item in ItemsList)
                        if (player.IsAlive && player.Origin.DistanceTo(item.Origin) <= 70)
                        {
                            player.SetField("OnItem", item);
                            break;
                        }

                foreach (Entity player in Players)
                    if (player.IsAlive && player.HasField("OnItem"))
                    {
                        Entity item = player.GetField<Entity>("OnItem");
                        if (player.Origin.DistanceTo(item.Origin) <= 70)
                        {
                            int curr_state = item.GetField<int>("used");
                            if (curr_state.Equals(0))
                            {
                                if (item.HasField("perk"))
                                {
                                    if (!HasPerk(player, item))
                                        SetMessage(player, "Press ^3[{+activate}] ^7to get perk.");
                                    else
                                        SetMessage(player, "");
                                }
                                else
                                {
                                    string weapon_item = FindWepbyModel(item.Model);
                                    string weapon_target = AddPlayerCamo(weapon_item, player);
                                    if (!player.HasWeapon(weapon_target))
                                        SetMessage(player, "Press ^3[{+activate}] ^7to get weapon.");
                                    else if (player.GetAmmoCount(weapon_target) != GSCFunctions.WeaponStartAmmo(weapon_target))
                                        SetMessage(player, "Press ^3[{+activate}] ^7to get ammo.");
                                    else
                                        SetMessage(player, "");
                                }
                            }
                            else
                                SetMessage(player, "");
                        }
                        else
                            SetMessage(player, "");
                    }

                return true;
            });
        }
        private void UseItem(Entity player)
        {
            player.NotifyOnPlayerCommand("use", "+activate");
            player.OnNotify("use", entity =>
            {
                if (player.IsAlive && IsModeTarget(player) && player.GetField<bool>("item_msg"))
                {
                    Entity item = player.GetField<Entity>("OnItem");
                    int curr_state = item.GetField<int>("used");
                    if (curr_state.Equals(0))
                    {
                        if (item.HasField("perk"))
                        {
                            if (!HasPerk(player, item))
                            {
                                GivePerk(player, item);
                                player.PlayLocalSound("scavenger_pack_pickup");
                                ShowPerksHud(player, item);
                                SwitchItemState(item);

                                AfterDelay(30000, () => { SwitchItemState(item); });
                            }
                        }
                        else
                        {
                            string weapon_item = FindWepbyModel(item.Model);
                            string weapon_target = AddPlayerCamo(weapon_item, player);
                            if (!player.HasWeapon(weapon_target))
                            {
                                string newwep = SetRandomCamo(weapon_item);
                                player.TakeWeapon(player.CurrentWeapon);
                                player.GiveWeapon(newwep);
                                player.SwitchToWeaponImmediate(newwep);
                                player.PlayLocalSound("mp_suitcase_pickup");
                                SwitchItemState(item);

                                AfterDelay(30000, () => { SwitchItemState(item); });
                            }
                            else if (player.GetAmmoCount(weapon_target) != GSCFunctions.WeaponStartAmmo(weapon_target))
                            {
                                player.PlayLocalSound("scavenger_pack_pickup");
                                player.GiveStartAmmo(weapon_target);
                                SwitchItemState(item);

                                AfterDelay(30000, () => { SwitchItemState(item); });
                            }
                        }
                    }
                }
            });
        }

        private void SwitchItemState(Entity item)
        {
            int item_index = ItemsList.FindIndex(ent => ent == item);
            int state = item.GetField<int>("used") == 0 ? 1 : 0;
            item.SetField("used", state);

            Entity fx = FXList[item_index];
            Entity newfx = null;
            FXList.Remove(fx);
            if (item.GetField<int>("used") == 0)
            {
                item.Show();
                fx.Delete();
                newfx = SpawnTriggerFX(goldcircle_fx, item.Origin + new Vector3(0, 0, -40));
            }
            else
            {
                item.Hide();
                fx.Delete();
                newfx = SpawnTriggerFX(redcircle_fx, item.Origin + new Vector3(0, 0, -40));
            }
            FXList.Insert(item_index, newfx);
        }
        private void SetMessage(Entity player, string msg)
        {
            if (player.HasField("msg_hud"))
            {
                HudElem message = player.GetField<HudElem>("msg_hud");
                if (!string.IsNullOrEmpty(msg))
                {
                    message.SetText(msg);
                    message.Alpha = 1f;
                    player.SetField("item_msg", true);
                }
                else
                {
                    message.SetText("");
                    message.Alpha = 0f;
                    player.SetField("item_msg", false);
                }
            }
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
        private void ShowPerksHud(Entity player, Entity perkfield)
        {
            switch (perkfield.GetField<string>("perk"))
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
        private string AddPlayerCamo(string weapon, Entity player)
        {
            for (int i = 1; i < 13; i++)
            {
                if (i < 10)
                {
                    if (player.HasWeapon(weapon + "_camo0" + i.ToString()))
                    {
                        weapon = weapon + "_camo0" + i.ToString();
                        break;
                    }
                }
                else
                {
                    if (player.HasWeapon(weapon + "_camo" + i.ToString()))
                    {
                        weapon = weapon + "_camo" + i.ToString();
                        break;
                    }
                }
            }
            return weapon;
        }

        private void StingerFire(Entity player)
        {
            player.NotifyOnPlayerCommand("attack", "+attack");
            player.OnNotify("attack", self =>
            {
                if (player.CurrentWeapon == "stinger_mp")
                    if (GSCFunctions.PlayerAds(player) >= 1f)
                        if (GSCFunctions.GetWeaponAmmoClip(player, player.CurrentWeapon) != 0)
                        {
                            Vector3 vector = GSCFunctions.AnglesToForward(GSCFunctions.GetPlayerAngles(player));
                            Vector3 dsa = new Vector3(vector.X * 1000000f, vector.Y * 1000000f, vector.Z * 1000000f);
                            GSCFunctions.MagicBullet("stinger_mp", GSCFunctions.GetTagOrigin(player, "tag_weapon_left"), dsa, self);
                            GSCFunctions.SetWeaponAmmoClip(player, player.CurrentWeapon, 0);
                        }
            });
        }

        private void PreCachePerksHud()
        {
            GSCFunctions.PreCacheShader("specialty_longersprint_upgrade");
            GSCFunctions.PreCacheShader("specialty_fastreload_upgrade");
            GSCFunctions.PreCacheShader("specialty_quickdraw_upgrade");
            GSCFunctions.PreCacheShader("specialty_stalker_upgrade");
            GSCFunctions.PreCacheShader("specialty_coldblooded_upgrade");
            GSCFunctions.PreCacheShader("specialty_paint_upgrade");
            GSCFunctions.PreCacheShader("specialty_steadyaim_upgrade");
            GSCFunctions.PreCacheShader("specialty_quieter_upgrade");
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

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using InfinityScript;

namespace Switch
{
    public class Weapon
    {
        private string _weapon = "";
        private List<string> _attachments = new List<string>();
        private string[] _allowed_attachs;

        public Weapon(string weapon)
        {
            this._weapon = weapon;
            this._allowed_attachs = GetAllowedAttach();
        }

        public string GetWeapon
        {
            get { return this._weapon; }
        }
        public string GetWeaponWithAttachments
        {
            get
            {
                string wep = this._weapon;
                foreach (string attach in _attachments)
                    wep += "_" + attach;
                return wep;
            }
        }
        public string[] GetAllowedAttachments
        {
            get { return this._allowed_attachs; }
        }

        public bool HasAttachment(string attachment)
        {
            return _attachments.Contains(attachment);
        }
        public void AddAttachment(string attachment)
        {
            if (!HasAttachment(attachment) && IsAllowedAttach(attachment))
            {
                if (Data.Silencer.Contains(attachment) && HasSilencer) RemoveAttachment(Data.Silencer);
                if (Data.Sights.Contains(attachment) && HasSight) RemoveAttachment(Data.Sights);
                if (Data.SpecialAttach.Contains(attachment) && HasSpecialAttach) RemoveAttachment(Data.SpecialAttach);
                if (Data.Camos.Contains(attachment) && HasCamo) RemoveAttachment(Data.Camos);

                _attachments.Add(attachment);
            }
        }
        public void RemoveAttachment(string attachment)
        {
            if (_attachments.Contains(attachment))
                _attachments.Remove(attachment);
        }
        public void RemoveAttachment(string[] attachment_list)
        {
            foreach (string attach in attachment_list)
                if (_attachments.Contains(attach))
                    _attachments.Remove(attach);
        }

        public bool HasSilencer
        {
            get { return Data.Silencer.Any(i => _attachments.Contains(i)); }
        }
        public bool HasSight
        {
            get { return Data.Sights.Any(i => _attachments.Contains(i)); }
        }
        public bool HasSpecialAttach
        {
            get { return Data.SpecialAttach.Any(i => _attachments.Contains(i)); }
        }
        public bool HasCamo
        {
            get { return Data.Camos.Any(i => _attachments.Contains(i)); }
        }

        public void SetSilencer()
        {
            foreach (string silencer in Data.Silencer)
                if (IsAllowedAttach(silencer))
                {
                    _attachments.Add(silencer);
                    break;
                }
        }
        public void RemoveSilencer()
        {
            RemoveAttachment(Data.Silencer);
        }

        public void SetRandomSight()
        {
            if (HasSight) RemoveAttachment(Data.Sights);

            List<string> sights_allowed = new List<string>();
            foreach (string sight in Data.Sights)
                if (IsAllowedAttach(sight)) sights_allowed.Add(sight);

            if (sights_allowed.Count != 0)
                _attachments.Add(sights_allowed[Data.RandomRange(0, sights_allowed.Count)]);
        }
        public void RemoveSight()
        {
            RemoveAttachment(Data.Sights);
        }

        public void SetRandomSpecialAttach()
        {
            if (HasSpecialAttach) RemoveAttachment(Data.SpecialAttach);
            string attach = Data.SpecialAttach[Data.RandomRange(0, Data.SpecialAttach.Length)];
            if(IsAllowedAttach(attach))
                _attachments.Add(attach);
        }
        public void RemoveSpecialAttach()
        {
            RemoveAttachment(Data.SpecialAttach);
        }

        public void SetRandomCamo()
        {   
            if (HasCamo) RemoveAttachment(Data.Camos);
            string camo = Data.Camos[Data.RandomRange(0, Data.Camos.Length)];
            if(IsAllowedAttach(camo))
                _attachments.Add(camo);
        }
        public void RemoveCamo()
        {
            RemoveAttachment(Data.Camos);
        }

        public void SetRandomAttachments()
        {
            if (Data.RandomRange(0, 2) == 1) SetSilencer();
            if (Data.RandomRange(0, 2) == 1 || Data.SniperRifles.Contains(this._weapon)) SetRandomSight();
            if (Data.RandomRange(0, 2) == 1) SetRandomSpecialAttach();

            foreach (string attach in GetAllowedAttachments)
            {
                if (_attachments.Count == 3) break;

                if (Data.Sights.Contains(attach)) continue;
                if (Data.Silencer.Contains(attach)) continue;
                if (Data.SpecialAttach.Contains(attach)) continue;
                if (Data.Camos.Contains(attach)) continue;
                if (Data.RandomRange(0, 2) == 1) AddAttachment(attach);
            }
            SetRandomCamo();
        }

        public bool IsAllowedAttach(string attach)
        {
            return this._allowed_attachs.Contains(attach);
        }
        private string[] GetAllowedAttach()
        {
            List<string> attachs = new List<string>();

            foreach (var item in Data.AllowedWeapons)
                if (item.Value.Contains(this._weapon)) attachs.Add(item.Key);

            if (!Data.NoCamo.Contains(this._weapon))
                foreach (string camo in Data.Camos)
                    attachs.Add(camo);

            return attachs.ToArray();
        }
    }

    public static class Data
    {
        public static int RandomRange(int min, int max)
        {
            return GSCFunctions.RandomIntRange(min, max);
        }

        public static readonly string[] DefaultWeapons = {  "iw5_m4_mp",
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
                                           "iw5_barrett_mp",
                                           "iw5_rsass_mp",
                                           "iw5_dragunov_mp",
                                           "iw5_msr_mp",
                                           "iw5_l96a1_mp",
                                           "iw5_as50_mp",
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

        public static readonly string[] SniperRifles = {  "iw5_barrett_mp",
                                           "iw5_rsass_mp",
                                           "iw5_dragunov_mp",
                                           "iw5_msr_mp",
                                           "iw5_l96a1_mp",
                                           "iw5_as50_mp"};

        public static readonly Dictionary<string, string[]> AllowedWeapons = new Dictionary<string, string[]>()
        {
            { "reflex", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp"  } },
            { "silencer", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_mp5_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"  } },
            { "m320", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp"  } },
            { "acog", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp"  } },
            { "heartbeat", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_mk46_mp", "iw5_sa80_mp", "iw5_mg36_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp"  } },
            { "eotech", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp"  } },
            { "shotgun", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp"  } },
            { "hybrid", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp"  } },
            { "xmags", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_mp5_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp", "iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp", "iw5_usp45_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp", "iw5_fmg9_mp", "iw5_g18_mp", "iw5_mp9_mp", "iw5_skorpion_mp"  } },
            { "thermal", new string[] { "iw5_acr_mp", "iw5_type95_mp", "iw5_m4_mp", "iw5_ak47_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_g36c_mp", "iw5_scar_mp", "iw5_fad_mp", "iw5_cm901_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp"  } },
            { "rof", new string[] { "iw5_type95_mp", "iw5_m16_mp", "iw5_mk14_mp", "iw5_mp5_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"  } },
            { "gl", new string[] { "iw5_m4_mp", "iw5_m16_mp", "iw5_mk14_mp"  } },
            { "gp25", new string[] { "iw5_ak47_mp"  } },
            { "reflexsmg", new string[] { "iw5_mp5_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp", "iw5_fmg9_mp", "iw5_g18_mp", "iw5_mp9_mp", "iw5_skorpion_mp"  } },
            { "acogsmg", new string[] { "iw5_mp5_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp"  } },
            { "eotechsmg", new string[] { "iw5_mp5_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp"  } },
            { "hamrhybrid", new string[] { "iw5_mp5_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp"  } },
            { "thermalsmg", new string[] { "iw5_mp5_mp", "iw5_p90_mp", "iw5_m9_mp", "iw5_pp90m1_mp", "iw5_ump45_mp", "iw5_mp7_mp"  } },
            { "grip", new string[] { "iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp", "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"  } },
            { "silencer03", new string[] { "iw5_spas12_mp", "iw5_aa12_mp", "iw5_striker_mp", "iw5_usas12_mp", "iw5_ksg_mp", "iw5_barrett_mp", "iw5_msr_mp", "iw5_rsass_mp", "iw5_dragunov_mp", "iw5_as50_mp", "iw5_l96a1_mp"  } },
            { "reflexlmg", new string[] { "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"  } },
            { "eotechlmg", new string[] { "iw5_m60_mp", "iw5_mk46_mp", "iw5_pecheneg_mp", "iw5_sa80_mp", "iw5_mg36_mp"  } },
            { "barrettscopevz", new string[] { "iw5_barrett_mp"  } },
            { "msrscopevz", new string[] { "iw5_msr_mp"  } },
            { "rsassscopevz", new string[] { "iw5_rsass_mp"  } },
            { "dragunovscopevz", new string[] { "iw5_dragunov_mp"  } },
            { "as50scopevz", new string[] { "iw5_as50_mp"  } },
            { "l96a1scopevz", new string[] { "iw5_l96a1_mp"  } },
            { "silencer02", new string[] { "iw5_usp45_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp", "iw5_fmg9_mp", "iw5_g18_mp", "iw5_mp9_mp", "iw5_skorpion_mp"  } },
            { "akimbo", new string[] { "iw5_usp45_mp", "iw5_mp412_mp", "iw5_44magnum_mp", "iw5_deserteagle_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp", "iw5_fmg9_mp", "iw5_g18_mp", "iw5_mp9_mp", "iw5_skorpion_mp"  } },
            { "tactical", new string[] { "iw5_usp45_mp", "iw5_mp412_mp", "iw5_44magnum_mp", "iw5_deserteagle_mp", "iw5_p99_mp", "iw5_fnfiveseven_mp"  } }
        };

        public static readonly string[] Sights = { "reflex", 
                                          "reflexsmg",
                                          "acog", 
                                          "eotech", 
                                          "reflexlmg", 
                                          "reflexsmg", 
                                          "eotechsmg", 
                                          "eotechlmg", 
                                          "acogsmg", 
                                          "thermalsmg", 
                                          "hamrhybrid",
                                          "barrettscopevz", 
                                          "as50scopevz", 
                                          "l96a1scopevz", 
                                          "msrscopevz", 
                                          "dragunovscopevz", 
                                          "rsassscopevz", 
                                          "thermal",
							              "hybrid" };

        public static readonly string[] Silencer = { "silencer", "silencer03", "silencer02" };

        public static readonly string[] SpecialAttach = { "gl", "gp25", "m320", "shotgun" };

        public static readonly string[] Camos = {
                                        "camo01",
                                        "camo02",
                                        "camo03",
                                        "camo04",
                                        "camo05",
                                        "camo06",
                                        "camo07",
                                        "camo08",
                                        "camo09",
                                        "camo10",
                                        "camo11",
                                        "camo12",
                                        "camo13"};

        public static readonly string[] NoCamo = {  "iw5_44magnum_mp",
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

<p align="center">
  <img src="https://github.com/LastDemon99/LastDemon99/blob/main/Data/lb_logo.jpg">
  <br><br>
  <b>SharpShooter</b><br>
  <a>Game mode script for Plutonium</a>    
  <br><br>
  <img src="https://github.com/LastDemon99/LastDemon99/blob/main/Data/sharpshooter_demo.gif">
  <br><br>
  • <a href="#key-features">Key Features</a> •  
  <a href="#how-to-use">How To Use</a> •
  <a href="#download">Download</a> •  
  <a href="#game-modes">Game Modes</a> •
  <a href="#credits">Credits</a> •
  <a href="#sponsor">Sponsor</a> •
</p>

# <a name="key-features"></a>Key Features
- Every 30 seconds a counter is reset and all players will receive a random weapon.
- If the player stabs someone, will lose double the score of a kill.
- The random equipment can be allow.
- The random attachs can be allow.
- Two random weapons can be allow.

# <a name="how-to-use"></a>How To Use
##### Installation
Unzip SharpShooter.rar, it will have 3 files, a `.bat` for a quick installation where you will only have to `double-click`, or else manually copy the folders on `%localappdata%/plutonium/storage/iw5/`

##### Configuration
You can configure the script with the following dvars, in your server config or in the game console

| Name               | Description                                                                           | Default Value | Accepted values      |
|--------------------|---------------------------------------------------------------------------------------|---------------|----------------------|
| ss_switch_time     | Set the switch time for the next weapon                                               | 30            | any positive integer |
| ss_allow_secondary | Enables or disables obtaining 2 weapons, primary and secondary to switch between them | 0             | 0 or 1               |
| ss_allow_attachs   | Enables or disables weapon accessories                                                | 0             | 0 or 1               |
| ss_allow_equipment | Enables or disables grenade equipment                                                 | 0             | 0 or 1               |
##### Modification
If you added new mod weapons, you can modify the script to implement them, open the SharpShooter.gsc file located in `%localappdata%/plutonium/storage/iw5/scripts/`, in the `gameSetup()` function use `add_custom_weapon(<baseName>, <displayName>, <weaponClass>, <attachs>);` **¡Ensure the attach is supported by your custom weapon!** [WeponClass & Attachs](https://github.com/LastDemon99/IW5-Sripts/tree/main/GSC/ClassReplace/Data#weapons-attachs)

##### Modification Example
By default the script integrates weapons that incorporate plutonium
```
gameSetup()
{
	add_custom_weapon("iw5_cheytac", "Intervention", "weapon_sniper", ["acog", "silencer03", "thermal", "xmags", "heartbeat", "vzscope"]);
	add_custom_weapon("iw5_ak74u", "AK74-u", "weapon_smg", ["reflex", "silencer", "rof", "acog", "eotech", "xmags", "thermal"]);
```

# <a name="download"></a>Download
- Download: [SharpShooter](https://github.com/LastDemon99/IW5-Sripts/releases/download/ss-v0.2/SharpShooter.rar)

# <a name="game-modes"></a>Game Modes
Other game modes you might be interested in:

- [OldSchool](https://github.com/LastDemon99/COD_CustomModes/tree/main/GSC/OldSchool)
- [Cranked] (no progress)
- [Switch] (no progress)
- [Huge GunGame] (no progress)
- [Random Sniper] (no progress)
- [Random Shotgun] (no progress)
- [Random Pistol] (no progress)

# <a name="credits"></a>Credits
- LethalBeats Team
- The Plutonium team for gsc implementation

# <a name="sponsor"></a>Sponsor
If you like my work and wish to contribute:<br><br/>
-Btc: bc1q07ke80u33uu4ymvhgmsrlay3xt7emt253rgqxq<br/>
-Eth: 0x50C34b8D20d2a195CC35cF506375EdE3B84548dE<br/>
<a href="https://www.paypal.com/paypalme/lastdemon99/"><img src="https://github.com/LastDemon99/LastDemon99/blob/main/Data/paypal_dark.svg" height="60"></a>

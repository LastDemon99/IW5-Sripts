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
  <a href="#donate">Donate</a> •
</p>

# <a name="key-features"></a>Key Features
- Every 30 seconds a counter is reset and all players will receive a random weapon.
- The random equipment can be enabled.

# <a name="how-to-use"></a>How To Use
- Place the script file at "%localappdata%/plutonium/storage/iw5/scripts" if the folder does not exist, create it
- To configure the script you can set the following dvars in your server config or in the game console

- Enable game mode, this option is because I plan to create more modes and then incorporate this into a voting or rotation
	>lb_cutomMode "SharpShooter"
	
- Set the switch time for the next weapon
	>ss_switch_time

- Enable or disable random equipments "lethal & tactical"
	>ss_equipment_enable 

- 0 will set a single random weapon,1 will set a primary and a secondary weapon separately
	>ss_type 
	
- Indicate to the script which is the default value so that when it is not executed it changes it to this one.
	>lb_defaultJumpSlowValue 
	
	>lb_defaultFallDamageValue
	
# <a name="download"></a>Download
- Download v0.1.0 pre-release: [SharpShooter](https://github.com/LastDemon99/COD_CustomModes/releases/download/0.1.0/SharpShooter.gsc)

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

# <a name="donate"></a>Donate
<a href="https://www.paypal.com/paypalme/lastdemon99/"><img src="https://github.com/LastDemon99/LastDemon99/blob/main/Data/paypal_dark.svg" height="40"></a>  
If you liked this project and you want to collaborate for the creation of more you can donate here :3

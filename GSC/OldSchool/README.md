<p align="center">
  <img src="https://github.com/LastDemon99/LastDemon99/blob/main/Data/lb_logo.jpg">
  <br><br>
  <b>Old School</b><br>
  <a>Game mode script for Plutonium, that aims to re-create the Old School mode of cod4</a>    
  <br><br>
  <img src="https://github.com/LastDemon99/LastDemon99/blob/main/Data/old_school_demo.gif">
  <br><br>
  • <a href="#key-features">Key Features</a> •  
  <a href="#how-to-use">How To Use</a> •
  <a href="#download">Download</a> •  
  <a href="#game-modes">Game Modes</a> •
  <a href="#credits">Credits</a> •
  <a href="#donate">Donate</a> •
</p>

# <a name="key-features"></a>Key Features
- Players cannot choose preset or custom classes. Everyone starts with a Skorpion as a primary weapon and an usp as a secondary weapon.
- Script spawns random items in different zones, once a player picks up a weapon or perk, the fx location turns red, after a time of 25 seconds, then regenerates the same weapon, or 
perk.
- The way to pick up an item is by using the f key, if you don't have the weapon it will be replaced by the one you have in your hand, otherwise it will just fill your ammo, likewise only if you don't have the weapon or perk will you be able to use the item.
- The only available perks are FastReload, QuickDraw, Stalker, BulletAccuracy, Quieter.
- Players can jump twice the normal height and falling damage is negated, jump slow has disable.
- The script only works for stock maps, i have to add more zones and more maps, by default the "drop zone" mode zones are used, I will update this in the future.

# <a name="how-to-use"></a>How To Use
- Place the script file at "%localappdata%/plutonium/storage/iw5/scripts" if the folder does not exist, create it
- To configure the script you can set the following dvars in your server config or in the game console

- Enable game mode, this option is because I plan to create more modes and then incorporate this into a voting or rotation
	>lb_cutomMode "OldSchool"

- Enable or disable spawn perks items
	>os_perks_enable 

- Enable or disable spawn perks items
	>os_equipment_enable 

- Enable or disable random camos after get the weapon
	>os_camos_enable 

- Indicate to the script which is the default value so that when it is not executed it changes it to this one.
	>os_defaultJumpSlowValue 
	>os_defaultFallDamageValue
	
# <a name="download"></a>Download
- Download the .gsc file from the main repository.

# <a name="game-modes"></a>Game Modes
Other game modes you might be interested in:

- [Cranked] (no progress)
- [SharpShooter] (no progress)
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

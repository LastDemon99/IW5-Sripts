<p align="center">
  <img src="https://github.com/LastDemon99/LastDemon99/blob/main/Data/lb_logo.jpg">  
  <br><br>
  <b>IW5_VoteSystem</b><br>
  <a>GSC script for plutonium, a dynamic hud for selecting maps and game modes</a> 
  <br><br>
  <img src="https://github.com/LastDemon99/LastDemon99/blob/main/Data/IW5_VoteSystem.png">
  <br><br>
  • <a href="#key-features">Key Features</a> •  
  <a href="#how-to-use">How To Use</a> •
  <a href="#download">Download</a> •  
  <a href="#credits">Credits</a> •
  <a href="#sponsor">Sponsor</a> •
</p>

# <a name="key-features"></a>Key Features
- This script will create a random list of maps and dsr at the end of the game with a drop down menu to vote the next rotation
- The range of maps and dsr that will be displayed in the menu will be the one of your preference

# <a name="how-to-use"></a>How To Use
- Place the script file at "%localappdata%/plutonium/storage/iw5/scripts" if the folder does not exist, create it
- To configure the script you can set the following dvars in your server config or in the game console

- Enable or disable voting at the end of the game 
	>vote_enable

- Number of maps to be shown in the vote, maximum 6, if the value is 0 or 1 no map will be shown allowing to increase the maximum of vote_dsr_count as long as it does not exceed the length of the list
	>vote_maps_count

- Number of dsr to be shown in the vote, maximum 6, if the value is 0 or 1 no dsr will be shown allowing to increase the maximum of vote_map_count as long as it does not exceed the length of the list
	>vote_dsr_count

- Voting time in seconds 
	>vote_time 

- Either to set the map or the dsr you will have to use the following format "name;alias" to add more  elements split it with a ":"
	>vote_maps "name1;alias1:name2;alias2"
	>vote_dsr "name1;alias1:name2;alias2"


- The config file: [Config](https://github.com/LastDemon99/IW5_VoteSystem/blob/main/config.cfg) 
- To interact with the menu press the keys that appear at the bottom of the screen

# <a name="download"></a>Download
- Download v0.2.4: [IW5_VoteSystem](https://github.com/LastDemon99/IW5_VoteSystem/releases/download/v0.2.4/IW5_VoteSystem.gsc)

# <a name="credits"></a>Credits
- LethalBeats Team
- The Plutonium team for gsc implementation
- Special thanks to Swifty for solving doubts, testing and fixing part of the code: [Swifty](https://github.com/swifty-tekno) 
- Plutonium discord community for solving doubts

# <a name="sponsor"></a>Sponsor
<a href="https://www.patreon.com/RandomScriptsIW5"><img src="https://github.com/LastDemon99/LastDemon99/blob/main/Data/patreon_dark.png" height="60"></a>  
if you want to help me create more content and have access and preview in advance, support me in patreon :3

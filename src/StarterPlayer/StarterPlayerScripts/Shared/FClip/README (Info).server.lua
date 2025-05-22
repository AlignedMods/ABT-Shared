--[[

Thanks for using this script!

Credit goes to Jukereise for the original Flip script
This version was altered to resemble OG corner clipping and to fix a few bugs and nitpicks I had with the used version.

---------------------------------------------------------------- Instructions ---------------------------------------------------------------

1.) Put folder in StarterPlayer\StarterPlayerScripts for scripts to function
2.) To make a part clippable, add a boolvalue and name it "CanFlip"
3.) Just corner clip lol

Side note: The FClip script contains adjustable parameters which are notated in the script itself.

----------------------------------------------------------- Patch Notes/Changelog -----------------------------------------------------------

v1.3:	- Rearranged model contents for Marketplace appearance
		- Added R15 compatibility/detection
		- Fixed the camera's position lagging behind a frame
		- Tweaked how cRatio and player's relative position affect clip distance
		
v1.2:	- Added new parameter cRatio (explained under Parameters)
		- Adjusted default hRange value from pi/6 to arctan of 2/3
		
v1.1:	- Added optional debugger that prevents invalid parts from clipping the player

v1.0:	- Release

]]
--[[----------------------------------------------------------
	Supertos Industries
	----------------------------------------------------------
	Autonomous MultiPurpose Robot
	Author: Supertos
	Year: 2023
	Ver: Rev 5
--]]----------------------------------------------------------

-- error("LOADED!")
load(readFile( "movement.lua" ), "move", "bt", _G)()
load(readFile( "nav.lua" ), "nav", "bt", _G)()
load(readFile( "actions/wander.lua" ), "wander", "bt", _G)()
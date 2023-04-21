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
load(readFile( "mem.lua" ), "nav", "bt", _G)()
load(readFile( "ai.lua" ), "wander", "bt", _G)()

while true do
	ai:processInventory()
	ai:pickUpPickaxe()
	coroutine.yield()
end

-- load(readFile( "actions/wander.lua" ), "wander", "bt", _G)()
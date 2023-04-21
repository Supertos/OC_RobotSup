--[[----------------------------------------------------------
	Supertos Industries
	----------------------------------------------------------
	Autonomous MultiPurpose Robot
	Author: Supertos
	Year: 2023
	Ver: Rev 5
--]]----------------------------------------------------------

mem = {}

mem.distTraveled = 0
mem.BlocksFound = {}

function mem:getItemRarity( item )
	return ( self.BlocksFound[ item ] or self.distTraveled ) / self.distTraveled 
end
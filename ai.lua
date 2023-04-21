--[[----------------------------------------------------------
	Supertos Industries
	----------------------------------------------------------
	Autonomous MultiPurpose Robot
	Author: Supertos
	Year: 2023
	Ver: Rev 5
--]]----------------------------------------------------------

ai = {}

ai.inventory = {}
ai.inv_summary = {}
ai.inv_size = 0
ai.inv_occupied = 0

ai.setup = {
	target_ores = { 
		"minecraft:diamon_ore",
		"minecraft:emerald_ore",
		"minecraft:coal_ore"		
	}




}

---------------------------------------------------------------
-- *processInventory( )
-- Unifies stacks of items and generates report table
function ai:processInventory()
	self.inventory = {}
	self.inv_summary = {}
	self.inv_size = robot.inventorySize()
	
	local item
	local combine_item
	for slot=1, self.inv_size, 1 do
		item = inventory_controller.getStackInInternalSlot( slot )
		
		if item then
			
			for combine_slot=slot+1, self.inv_size, 1 do
				combine_item = inventory_controller.getStackInInternalSlot( combine_slot )
				
				if combine_item and combine_item.name == item.name then
					robot.select( combine_slot )
					robot.transferTo( slot )
				end
				
				if item.size == item.maxSize then break end
			
			end
			
			
			if not self.inv_summary[ item.name ] then
				self.inv_summary[ item.name ] = ( self.inv_summary[ item.name ] or 0 ) + item.size
			end
			
			
			
			
			self.inventory[ slot ] = { item.name, item.size, item.maxSize }
			self.inv_occupied = self.inv_occupied + 1
		end
	end
	
end

---------------------------------------------------------------
-- *pickUpPickaxe( )
-- Searches for and equips pickaxe
function ai:pickUpPickaxe() 
	for slot, item in pairs( self.inventory ) do
		if string.find( item[1], "pickaxe" ) then
			robot.select( slot )
			inventory_controller.equip()
			break
		end
	end

end

---------------------------------------------------------------
-- *closestBlocks( )
-- Returns block data on nearest blocks
function ai:closestBlocks()
	local obj = {}
	local out = {}
	for side=0, 6, 1 do
		out[side] = geolyzer.analyze( side )
	end
	return out
end
---------------------------------------------------------------
-- *poorestItem( )
-- Returns slotID and item data
function ai:poorestItem()


end

---------------------------------------------------------------
-- *getItemCost( )
-- Returns item cost
function ai:getItemCost( name, size )
	local out = 0.25/mem:getItemRarity( name ) + size/8
	if string.find( item.name, "pickaxe" ) then out = 99999999 end --Never get rid of pickaxe
	
	for priority in self.setup.target_ores do
		if priority == out then
			out = out + 500
			break
		end
	end
end
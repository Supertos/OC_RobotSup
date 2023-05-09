--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	env.lua > screen.lua
	
	Initializes screen library
--]]----------------------------------------------------

robot = {}

robot.x = 0
robot.y = 0
robot.z = 0

robot.ang = 0

-- Side order: 3 4 2 5
-- Positive Z - 3
-- Negative X - 4
-- Negative Z - 2
-- Positive X - 5

--[[-------------------------------------------------------------
	*robot.getForward( )
	Returns how robot coordinates will change if they move forward
--]]-------------------------------------------------------------
robot.getForward = function()
	if robot.ang == 3 then return 0, 1 end
	if robot.ang == 4 then return -1, 0 end
	if robot.ang == 2 then return 0, -1 end
	if robot.ang == 5 then return 1, 0 end
end

--[[-------------------------------------------------------------
	*robot.getRight( )
	Returns how robot coordinates will change if they move right
--]]-------------------------------------------------------------
robot.getRight = function()
	if robot.ang == 3 then return -1, 0 end
	if robot.ang == 4 then return 0, -1 end
	if robot.ang == 2 then return 1, 0 end
	if robot.ang == 5 then return 0, 1 end
end

--[[-------------------------------------------------------------
	*robot.turnRight( )
	Turns robot right
--]]-------------------------------------------------------------
robot.turnRight = function()
	if robot.ang == 3 then robot.ang = 4 elseif robot.ang == 4 then robot.ang = 2 elseif robot.ang == 2 then robot.ang = 5 else robot.ang = 3 end
	component.invoke( env.robot, "turn", true )
end

--[[-------------------------------------------------------------
	*robot.turnLeft( )
	Turns robot left
--]]-------------------------------------------------------------
robot.turnLeft = function()
	if robot.ang == 3 then robot.ang = 5 elseif robot.ang == 5 then robot.ang = 2 elseif robot.ang == 2 then robot.ang = 4 else robot.ang = 3 end
	component.invoke( env.robot, "turn", false )
end

--[[-------------------------------------------------------------
	*robot.forward( )
	Moves robot forward
--]]-------------------------------------------------------------
robot.forward = function()
	local canMove, reason = component.invoke( env.robot, "detect", 3 )
	
	if canMove then
		local x, z = robot.getForward()
		robot.x = robot.x + x
		robot.z = robot.z + z
	else
		return reason
	end
end

--[[-------------------------------------------------------------
	*robot.back( )
	Moves robot backwards
--]]-------------------------------------------------------------
robot.back = function()
	local canMove, reason = component.invoke( env.robot, "detect", 2 )
	
	if canMove then
		local x, z = robot.getForward()
		robot.x = robot.x - x
		robot.z = robot.z - z
	else
		return reason
	end
end

local function xyzToID( x, y, z, w, d )
	return x + z*w + y*w*d
end

--[[-------------------------------------------------------------
	*robot.traceforward( )
	Analyzes stuff forward
--]]-------------------------------------------------------------


--TODO: USE 	FUCKING CORNERS
robot.traceforward = function ()
	if not geolyzer then io.error("Geolyzer not found!") return end
	
	local forward_x, forward_z = robot.getForward()
	local right_x, right_z = robot.getRight()
	
	local start_x, start_z, start_y  = -right_x + forward_x, -right_z  + forward_z, -1
	
	width = forward_x*7+right_x*3
	depth = forward_z*7+right_z*3
	height = 3
	
	local end_x, end_y, end_z = start_x+width, 1, start_z + depth
	
	
	local x = math.min( start_x, end_x )
	local z = math.min( start_z, end_z )
	local y = math.min( start_y, end_y )
	
	
	io.write( -right_x, " ", forward_x, " ")
	io.write( x, " ", y, " ", z )
	
	
	
	
	
	
	
	
	
	
	local map = {}
	local result = component.invoke( env.geolyzer, "scan", x, z, y, math.abs(width),  math.abs(depth), height )
	map.data = result
	
	
	map.start_x = x
	map.start_y = y
	map.start_z = z
	
	
	map.width = math.abs( width )
	map.depth = math.abs( depth )
	
	function map:getHardness( x, y, z )
		local rel_x = x - self.start_x
		local rel_y = y - self.start_y
		local rel_z = z - self.start_z
		io.write( "Coords: ", x, " ", y, " ", z )
		io.write( "Start coords: ", self.start_x, " ", self.start_y, " ", self.start_z )
		io.write( "Relative coords: ", rel_x, " ", rel_y, " ", rel_z )
		io.write( rel_x + rel_z*self.width + rel_y*self.width*self.depth + 1  )
		return self.data[ rel_x + rel_z*self.width + rel_y*self.width*self.depth + 1 ]
	end
	
	io.write( map:getHardness( forward_x, 0, forward_z ) )
	
	
	
	
	
	
	
	
	
	
	if math.abs(width) == 1 then width = 3 end
	if math.abs(depth) == 1 then depth = 3 end
	-- for x=1, 64, 8 do
		-- io.write( math.floor(result[x]), " ",math.floor(result[x+1]), " ",math.floor(result[x+2]), " ",math.floor(result[x+3]), " ",math.floor(result[x+4]), " ",math.floor(result[x+5]), " ", math.floor(result[x+6]), " ", math.floor(result[x+7]) )
	-- end
	-- return
end







robot.initialize = function()
	component.invoke( env.robot, "setLightColor", tonumber("FF0000", 16) )
	
	if navigation then 
		robot.ang = component.invoke( env.navigation, "getFacing" ) 
		io.write( "Current angle: ", robot.ang )
		io.write( "You may now eject Navigation Module!")
	else 
		robot.ang = 5 
		io.write( "Warning: robot facing is unknown! robot.ang set to Positive X!")
	end
	

	
	component.invoke( env.robot, "setLightColor", tonumber("00FF00", 16) )


end
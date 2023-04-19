--[[----------------------------------------------------------
	Supertos Industries
	----------------------------------------------------------
	Autonomous MultiPurpose Robot
	Author: Supertos
	Year: 2023
	Ver: Rev 5
--]]----------------------------------------------------------

loco = {}

loco.X = 0
loco.Y = 0
loco.Z = 0

loco.LastX = 0
loco.LastY = 0
loco.LastZ = 0

loco.MoveDist = 0
--[[--------------------------------------
	Each loco.Ang corresponds to pair X/Y:
	1 - Positive X
	2 - Positive Y
	3 - Negative X
	4 - Negative Y
--]]---------------------------------------
loco.Ang = 1

------------------------
-- *getPos( )
-- Gets robot pos
function loco:getPos()
	return self.X, self.Y, self.Z
end

------------------------
-- *getLastPos( )
-- Gets robot last pos
function loco:getLastPos()
	return self.LastX, self.LastY, self.LastZ
end

------------------------
-- *distMove( )
-- Returns distance bot traversed
function loco:distMove()
	return self.MoveDist
end

------------------------
-- *resetDistMove( )
-- Resets distance bot traversed
function loco:resetDistMove()
	self.MoveDist = 0
end

------------------------
-- *getForward( )
-- Gets robot forward direction
function loco:getForward()
	if self.Ang == 1 then
		return 1, 0
	elseif self.Ang == 2 then
		return 0, 1
	elseif self.Ang == 3 then
		return -1, 0
	elseif self.Ang == 4 then
		return 0, -1
	end
end

------------------------
-- *forward( )
-- Moves robot forward
function loco:forward()
	if robot.detect( 3 ) then return end
	
	self.LastX = self.X
	self.LastY = self.Y
	self.MoveDist = self.MoveDist + 1
	
	local MoveX, MoveY = self:getForward()
	self.X = self.X + MoveX
	self.Y = self.Y + MoveY
	
	robot.move( 3 )
end

------------------------
-- *turn( clockwise )
-- Turns robot
function loco:turn( clockwise )
	self.Ang = self.Ang + ( clockwise and 1 or - 1 )
	
	if self.Ang < 1 then self.Ang = 4 end
	if self.Ang > 4 then self.Ang = 1 end
	
	robot.turn( clockwise )
end

-------------------------------------------
-- *moveUp( )
-- Moves robot up
function loco:moveUp( )
	if robot.detect( 1 ) then return end
	if robot.move( 1 ) then self.MoveDist = self.MoveDist + 1 self.LastZ = self.Z self.Z = self.Z + 1 end
end

-------------------------------------------
-- *moveDown( )
-- Moves robot down
function loco:moveDown( )
	if robot.detect( 0 ) then return end
	if robot.move( 0 ) then self.MoveDist = self.MoveDist + 1 self.LastZ = self.Z self.Z = self.Z - 1 end
end

-------------------------------------------
-- *setAng( ang )
-- Turns robot until pushed ang is achieved
function loco:setAng( target )
	while target ~= self.Ang do
		if target > self.Ang then self:turn( true ) end
		if target < self.Ang then self:turn( false ) end
	end
end
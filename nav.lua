--[[----------------------------------------------------------
	Supertos Industries
	----------------------------------------------------------
	Autonomous MultiPurpose Robot
	Author: Supertos
	Year: 2023
	Ver: Rev 5
--]]----------------------------------------------------------


nav = {}
nav.nodegraph = {}

nav.lastMoveDir = 1
nav.moveDir = 1

nav.lastNode = 0

---------------------------------------------------------------
-- *updateDir( )
-- Updates movement direction for shouldDropNode
function nav:updateDir()
	nav.lastMoveDir = nav.moveDir
	nav.moveDir = loco.Ang

end

---------------------------------------------------------------
-- *shouldDropNode( )
-- Returns true if a node should be placed on previous position
function nav:shouldDropNode()
	return self.lastMoveDir ~= self.moveDir or loco.MoveDist > 16 
end

---------------------------------------------------------------
-- *closestNode( X, Y, Z )
-- Returns node ID that is close enough ( 16 blocks away ) from provided coordinates

function nav:closestNode( x, y, z )
	
	local bestDist = 16
	local bestId = 0
	
	local dist = 0
	local nodeX, nodeY, nodeZ
	for id=1, #self.nodegraph do
		nodeX, nodeY, nodeZ = self.nodegraph[ id ].x, self.nodegraph[ id ].y, self.nodegraph[ id ].z
		dist = math.sqrt( ( nodeX - x )^2 + ( nodeY - y )^2 + ( nodeZ - z )^2 )
		
		if dist < bestDist then
			dist = bestDist
			bestId = id
		end
	end
	
	return bestId
end

---------------------------------------------------------------
-- *getNode( X, Y, Z )
-- Returns ID of a node on this position

function nav:getNode( x, y, z )
	local dist = 0
	local nodeX, nodeY, nodeZ
	for id=1, #self.nodegraph do
		nodeX, nodeY, nodeZ = self.nodegraph[ id ].x, self.nodegraph[ id ].y, self.nodegraph[ id ].z
		if nodeX == x and nodeY == y and nodeZ == z then
			return id
		end
	end
	
end

---------------------------------------------------------------
-- *dropNode( )
-- Generates new node
function nav:dropNode()
	
	local cur = self:getNode( self.lastX, self.lastY, self.lastZ )
	if cur then
		self.nodegraph[cur].links[ #self.nodegraph[cur].links + 1 ] = self.lastNode
		return
	end
		
	local node = {}
	
	node.links = {}
	if self.lastNode then node.links[ 1 ] = self.lastNode end
	node.x = self.lastX
	node.y = self.lastY
	node.z = self.lastZ
	
	self.lastNode = #self.nodegraph + 1
	self.nodegraph[ self.lastNode ] = node
	
	loco.MoveDist = 0
end


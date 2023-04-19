--[[----------------------------------------------------------
	Supertos Industries
	----------------------------------------------------------
	Autonomous MultiPurpose Robot
	Author: Supertos
	Year: 2023
	Ver: Rev 5
--]]----------------------------------------------------------

function analyzeEnv()
	local data = geolyzer.scan( 0, 0, 0, 8, 8, 1 )

end


while true do
	
	local canRight = not geolyzer.detect( 4 )
	local canLeft = not geolyzer.detect( 5 )
	
	local canFront = not geolyzer.detect( 3 )
	local canBack = not geolyzer.detect( 2 )
	
	local canUp = not geolyzer.detect( 1 )
	local canDown = not geolyzer.detect( 0 )
	
	while not geolyzer.detect( 0 ) do loco:moveDown() end
	if canFront then
		loco:forward()
		if nav:shouldDropNode() then
			
			nav:dropNode( loco:getLastPos() )
			
			if math.random() > 0.8 then
				loco:turn( math.random()>=0.5 and true or false )
			end
		end
	else
		loco:moveUp()
		if not geolyzer.detect( 3 ) then
			nav:dropNode( loco.lastX, loco.lastY, loco.lastZ )
			loco:forward()
		else
			loco:moveDown()
			loco:turn( math.random()>=0.5 and true or false )
		end
	end
	nav:updateDir()
	-- coroutine.yield()
end



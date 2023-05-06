--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	init.lua > startup.lua
	
	Handles OS initialize
--]]----------------------------------------------------


--[[-- IO Initialize --]]--
function initializeIO()
	
end




function processInputs()
	
	repeat
		local signal, a, b, c, d, e, f = computer.pullSignal(0)
		
		if signal == "key_down" then
			io._setKey( c, true )
			io.key_to_char[ c ] = string.char(b)
		elseif signal == "key_up" then
			io._setKey( c, false )
		end
    until not signal

end









initializeIO()
while true do
	
	processInputs()
	
	
	for pos, mykey in pairs( io.keys_just_press ) do
		io.write( io.key_to_char[ mykey ] )
		table.remove( io.keys_just_press, pos ) 
	end
	
	for pos, line in pairs( io.log ) do
		io.drawText( 1, pos, line )
	end
end
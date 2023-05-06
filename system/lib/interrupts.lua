--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	init.lua > interrupts.lua
	
	Initializes interrupt handling
--]]----------------------------------------------------


os._interrupts_hooks = {}

--[[-------------------------------------------------------------
	*os.hookInt(  handler, Event Type )
	Hooks handler with Data Table argument to provided Event Type. 
	Returns HandleID which is used to unhook handler
--]]-------------------------------------------------------------
os.hookInt = function( handler, event )
	
	if not os._interrupts_hooks[ handler ] then os._interrupts_hooks[ handler ] = {} end
	
	--[[-- Try to find empty slot --]]--
	for pos, old_handler in pairs( os._interrupts_hooks[ handler ] ) do
		if not old_handler then
			os._interrupts_hooks[ pos ] = handler
			return pos
		end
	end
	
	os._interrupts_hooks[ handler ][ #os._interrupts_hooks[ handler ] + 1 ] = event 
	return #os._interrupts_hooks[ handler ]
end

--[[-------------------------------------------------------------
	*os.unhookInt( Event Type, HandleID )
	Removes Handle with provided HandleID
--]]-------------------------------------------------------------
os.unhookInt = function( event, id )
	if not os._interrupts_hooks[ event ] then return end
	os._interrupts_hooks[ event ][ id ] = nil
end

--[[-------------------------------------------------------------
	*os._processInts( Event Type, HandleID )
	!Internal! Tries to pull event and run associated hooks
--]]-------------------------------------------------------------
os._processInts = function()
	repeat
		local signal = table.pack( computer.pullSignal(0) )
		
		local event = signal[1]
		table.remove( signal, 1 )
		
		if event and os._interrupts_hooks[ event ] then
			for _, hook in pairs( os._interrupts_hooks[ event ] ) do
				
				if hook then hook( signal ) end
			end
		end
	until not event
end
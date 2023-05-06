--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	env.lua > keyboard.lua
	
	Initializes keyboard library
--]]----------------------------------------------------

keyboard = {}

keyboard._keys = {}
keyboard._just_press_map = {}
keyboard.buffer = ""
keyboard._buffer = {}

--[[-------------------------------------------------------------
	*keyboard._pressKey( key )
	!Internal! Adds a key to _keys and _just_press_map
--]]-------------------------------------------------------------
keyboard._pressKey = function( key_id )
	keyboard._keys[ #keyboard._keys + 1 ] = key_id
	keyboard._just_press_map[ #keyboard._just_press_map + 1 ] = key_id
end

--[[-------------------------------------------------------------
	*keyboard._unpressKey( key )
	!Internal! Removes key entry
--]]-------------------------------------------------------------
keyboard._unpressKey = function( key_id )
	for i, key in pairs( keyboard._keys ) do
		if key == key_id then table.remove( keyboard._keys, i ) break end
	end
	
	for i, key in pairs( keyboard._just_press_map ) do
		if key == key_id then table.remove( keyboard._just_press_map, i ) break end
	end
end

--[[-------------------------------------------------------------
	*keyboard.isKeyPressed( key )
	Returns true if key has been just pressed
--]]-------------------------------------------------------------
keyboard.isKeyPressed = function( key_id )
	for i, key in pairs( keyboard._just_press_map ) do
		if key == key_id then table.remove( keyboard._just_press_map, i ) return true end
	end
	return false
end

--[[-------------------------------------------------------------
	*keyboard.isKeyDown( key )
	Returns true if key is down
--]]-------------------------------------------------------------
keyboard.isKeyDown = function( key_id )
	for i, key in pairs( keyboard._keys ) do
		if key == key_id then table.remove( keyboard._keys, i ) return true end
	end
	return false
end

--[[-------------------------------------------------------------
	*keyboard._rebuildBuffer( key )
	!Internal! Rebuilds table _buffer into buffer
--]]-------------------------------------------------------------
keyboard._rebuildBuffer = function( data )
	keyboard.buffer = ""
	for _, chr in pairs( keyboard._buffer ) do
		keyboard.buffer = keyboard.buffer .. utf8.char( chr )
	end
	
end
--[[-------------------------------------------------------------
	*keyboard._processPress( key )
	!Internal! Interrupt hook
--]]-------------------------------------------------------------
keyboard._processPress = function( data )
	
	keyboard._pressKey( data[3] )
	
	if data[3] == 56 or data[3] == 42 or data[3] == 29 then return end
	if data[3] == 28 then 
		computer.pushSignal( "drv_enter", keyboard.buffer )
		keyboard.clearBuffer() 
	elseif data[3] == 14 then 
		table.remove( keyboard._buffer )
	else 
		keyboard._buffer[ #keyboard._buffer + 1 ] = data[2]
	end
	
	keyboard._rebuildBuffer()
end

--[[-------------------------------------------------------------
	*keyboard._processUnPress( key )
	!Internal! Interrupt hook
--]]-------------------------------------------------------------
keyboard._processUnPress = function( data )
	keyboard._unpressKey( data[3] )
end

os.hookInt( "key_down", keyboard._processPress )
os.hookInt( "key_up", keyboard._processUnPress )

--[[-------------------------------------------------------------
	*keyboard.clearBuffer( )
	Clears buffer
--]]-------------------------------------------------------------
keyboard.clearBuffer = function( )
	keyboard.buffer = ""
	keyboard._buffer = {}
end
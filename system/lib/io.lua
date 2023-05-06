--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	init.lua > io.lua
	
	Initializes io library
--]]----------------------------------------------------


io = {}
io._std = {}

--[[-------------------------------------------------------------
	*io.write( ... )
	Removes Handle with provided HandleID
--]]-------------------------------------------------------------
io.write = function( ... )
	out = ""
	for _, data in pairs( ... ) do
		out = data..data
	end
	
	io._std[ #io._std + 1 ] =	string.sub(out , 1, 64 )
	if #io._std > 16 then table.remove( io._std, 1 ) end
end

--[[-------------------------------------------------------------
	*io.read( )
	Reads last entry in io.read
--]]-------------------------------------------------------------
io.read = function( )
	return io._std[ #io._std ]
end

--[[-------------------------------------------------------------
	*io.waitForKey( )
	Halts all execution and waits for a key
--]]-------------------------------------------------------------
io.waitForKey = function( )
	local signal = computer.pullSignal()
	if signal == "key_down" then return end
end


--[[-------------------------------------------------------------
	*io.shutdown( )
	Shutdowns computer
--]]-------------------------------------------------------------
io.shutdown = function( ) computer.shutdown() end

--[[-------------------------------------------------------------
	*io.reboot( )
	Shutdowns computer
--]]-------------------------------------------------------------
io.reboot = function( ) computer.shutdown( true ) end

--[[-------------------------------------------------------------
	*io.fatalError( )
	Does fatal error!
--]]-------------------------------------------------------------
io.fatalError = function( ... ) 

	if gpu then
		gpu.fill( "FFFFFF" )
		
		local size = select('#', ...)
		local y_start = gpu.height/2 - math.floor( size/2 )
		
		local y_offset = 0
		local val
		for pos = 1, size do
			val = select( pos, ... )
			local x_start = math.floor( gpu.width/2 - string.len( tostring( val ) ) / 2 )
			
			gpu.drawText( x_start, y_start+y_offset, tostring( val ), "000000", "FFFFFF" )
			y_offset = y_offset + 1
		end
		local x_start = gpu.width/2 - string.len( "Fatal Error Occured:" ) / 2
		gpu.drawText( x_start, 1, "Fatal Error Occured:", "000000", "FFFFFF" )
		
		x_start = gpu.width/2 - string.len( "Press Any Key To Continue" ) / 2
		gpu.drawText( x_start, gpu.height, "Press Any Key To Continue", "000000", "FFFFFF" )
	end

	computer.beep(300)
	computer.beep(400)
	computer.beep(300)
	computer.beep(500)
	computer.beep(600)
	
	io.waitForKey()
	io.reboot()
end

string.split = function(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[ #t + 1 ] = str
    end
    
	return t
end

--[[-------------------------------------------------------------
	*io.fileExists( path )
	Returns true if file with path exists
--]]-------------------------------------------------------------
io.fileExists = function( path ) 
	if not path then return false end
	return component.invoke( env.filesystem, "exists", path )
end

--[[-------------------------------------------------------------
	*io.runFile( path )
	runsFile
--]]-------------------------------------------------------------
io.runFile = function( path ) 

	local handle = assert(component.invoke(env.filesystem, "open", path ))
    local buffer = ""
    repeat
      local data = component.invoke(env.filesystem, "read", handle, math.huge)
      buffer = buffer .. (data or "")
    until not data
    component.invoke(env.filesystem, "close", handle)
    load(buffer, "=" .. path , "bt", _G)()
end
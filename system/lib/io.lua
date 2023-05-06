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
	Pushes new entry to the io._std
--]]-------------------------------------------------------------
io.write = function( ... )
	out = ""
	for pos = 1, select( "#", ... ) do
		out = out..select( pos, ... )
	end
	
	io._std[ #io._std + 1 ] =	string.sub(out , 1, 64 )
	if #io._std > 12 then table.remove( io._std, 1 ) end
	computer.pushSignal( "std_push" )
end

--[[-------------------------------------------------------------
	*io.read( )
	Reads last entry in the io._std
--]]-------------------------------------------------------------
io.read = function( )
	return io._std[ #io._std ]
end

--[[-------------------------------------------------------------
	*io.waitForKey( )
	Halts all execution and waits for a key
--]]-------------------------------------------------------------
io.waitForKey = function( )
	repeat
		local signal = computer.pullSignal()
	until signal == "key_down"
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
		gpu.foreground = 15
		
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


--[[-------------------------------------------------------------
	*io.error( )
	Does regular error!
--]]-------------------------------------------------------------
io.error = function( data ) 

	if gpu then
		gpu.fillLine( gpu.height/2-1, "FFFFFF" )
		gpu.fillLine( gpu.height/2, "FFFFFF" )
		gpu.fillLine( gpu.height/2+1, "FFFFFF" )
		
		local x_start = math.floor( gpu.width/2 - string.len( tostring( data ) ) / 2 )
		gpu.drawText( x_start, gpu.height/2, tostring( data ), "000000", "FFFFFF" )
		
		x_start = gpu.width/2 - string.len( "Fatal Error Occured:" ) / 2
		gpu.drawText( x_start, gpu.height/2-1, "Minor Error Occured:", "000000", "FFFFFF" )
		
		x_start = gpu.width/2 - string.len( "Press Any Key To Continue" ) / 2
		gpu.drawText( x_start, gpu.height/2+1, "Press Any Key To Continue", "000000", "FFFFFF" )
	end
	

	computer.beep(800)
	computer.beep(500)
	computer.beep(200)
	computer.beep(1000)
	computer.beep(1500)
	
	io.waitForKey()
	computer.pushSignal("io_err", data )
	gpu.fill( "000000" )
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
	Runs file
--]]-------------------------------------------------------------
io.runFile = function( path ) 

	local handle = assert(component.invoke(env.filesystem, "open", path ))
    local buffer = ""
    repeat
      local data = component.invoke(env.filesystem, "read", handle, math.huge)
      buffer = buffer .. (data or "")
    until not data
    component.invoke(env.filesystem, "close", handle)
	local func = load(buffer, "=" .. path , "bt", _G)
    if func then func() end
end

--[[-------------------------------------------------------------
	*io.readFile( path )
	Reads file
--]]-------------------------------------------------------------
io.readFile = function( path ) 

	local handle = assert(component.invoke(env.filesystem, "open", path ))
    local buffer = ""
    repeat
      local data = component.invoke(env.filesystem, "read", handle, math.huge)
      buffer = buffer .. (data or "")
    until not data
    component.invoke(env.filesystem, "close", handle)
	return buffer
end
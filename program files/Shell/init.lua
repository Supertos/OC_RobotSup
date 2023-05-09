--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	init.lua > Shell/init.lua
	
	Handles main shell operations
--]]----------------------------------------------------


shell = {}

shell._tasques = {}
shell._next_upd = computer.uptime() + 1
shell.cur_task = {}

shell._rams = {}
--[[-------------------------------------------------------------
	*shell.runTask( path )
	pushes new task to run. Returns TasqueID
--]]-------------------------------------------------------------
shell.runTask = function( path )
	
	local func = load(io.readFile(path), "=" .. path , "bt", _G)
	
	--[[-- Try to find empty slot --]]--
	for pos, old_cor in pairs( shell._tasques ) do
		if not old_cor then
			shell._tasques[ pos ] = { pos, path, coroutine.create( func ) }
			return pos
		end
	end
	
	shell._tasques[ #shell._tasques + 1 ] = { #shell._tasques, path, coroutine.create( func ) }
	return #shell._tasques 
end

--[[-------------------------------------------------------------
	*shell.killTask( id )
	Kills task
--]]-------------------------------------------------------------
shell.killTask = function( id )
	shell._tasques[ id ] = nil
end


--[[-------------------------------------------------------------
	*shell.runProgram( name )
	Runs a program
--]]-------------------------------------------------------------
shell.runProgram = function( name )
	local data = io.readFile( "/program files/list.ini" )
	
	for pos, line in pairs( string.split( data, "\n") ) do
		local data = string.split( line, "=" )
		if data[1] == name then
			shell.runTask( "/program files/"..data[2].."/init.lua" )
			return
		end
	end
	
	error( "No such program or command" )
	
end


--[[-------------------------------------------------------------
	*shell._doMultitask( )
	!Internal! Runs each and every task
--]]-------------------------------------------------------------
shell._doMultitask = function( name )
	
	for id, task in pairs( shell._tasques ) do
		if task ~= nil then
			shell.cur_task = task
			
			if coroutine.status( task[3] ) == "dead" then
				shell._tasques[ id ] = nil
			else
				local a, b = coroutine.resume( task[3] )
				
				if not a then io.error( b ) end
			end
		end
	end
end

--[[-------------------------------------------------------------
	*shell._doGUI( )
	!Internal! Draws cool gui
--]]-------------------------------------------------------------
shell._doGUI = function( name )
	
	gpu.drawText( 1, gpu.height, ">"..keyboard.buffer.."                                                                 ", "000000", "FFFFFF" )
	
	shell._rams[ #shell._rams + 1 ] = math.ceil( (computer.totalMemory()-computer.freeMemory())/computer.totalMemory()*100 )
	if #shell._rams > 12 then table.remove( shell._rams, 1 ) end
	
	local apr_ram = 0
	
	for _, ram in pairs( shell._rams ) do
		apr_ram = apr_ram + ram
	end
	apr_ram = math.floor( apr_ram / #shell._rams )
	
	gpu.drawText( 2, 1, tostring( apr_ram ).."% RAM of "..tostring( math.floor( computer.totalMemory()/1024)).."kb total   ", "000000", "FFFFFF" )
	gpu.drawText( 32, 1, tostring( math.ceil( (computer.energy())/computer.maxEnergy()*100 ) ).."% Power     ", "000000", "FFFFFF" )

end

--[[-------------------------------------------------------------
	*shell._tryCommand( line )
	!Internal! Tries to lookup a command to execute
	Returns false on fail
--]]-------------------------------------------------------------
shell._tryCommand = function( line )
	if line == "reboot" then io.reboot() return true  end
	if line == "shutdown" then io.shutdown() return true  end
	local data = string.split( line, " " )
	if data[1] == "beep" then if tonumber(data[2]) and tonumber(data[2]) >= 20 and tonumber(data[2]) <= 2000 then computer.beep(tonumber(data[2]) ) else error("Invalid frequency!") end return true end
	if data[1] == "error" then io.error( data[2] ) return end
	if data[1] == "die" then io.fatalError( data[2] or "Debug Fatal Error" ) return true end
	return false
end

--[[-------------------------------------------------------------
	*shell._processEnter( )
	!Internal! Shell hook
--]]-------------------------------------------------------------
shell._processEnter = function( data )
	if data[1] == "" then return end
	io.write( data[ 1 ] )
	if not shell._tryCommand( data[1] ) then
		shell.runProgram( data[1] )
	end
	shell._doGUI()
end

--[[-------------------------------------------------------------
	*shell._recover( )
	!Internal! Called when recovering from Minor Error
--]]-------------------------------------------------------------
shell._recover = function( data )
	gpu.fillLine( 1, "FFFFFF" )
	gpu.fillLine( gpu.height, "FFFFFF" )
	for pos, line in pairs( io._std ) do
		gpu.drawText( 2, pos+1, line.."                                                ", "FFFFFF", "000000" )
	end
end

if not robot then
	os.hookInt( "drv_enter", shell._processEnter )
	os.hookInt( "key_down", shell._doGUI )
	os.hookInt( "io_err", shell._recover )

	os.hookInt( "std_push", function()
		for pos, line in pairs( io._std ) do
			gpu.drawText( 2, pos+1, line.."                                                ", "FFFFFF", "000000" )
		end
	end)
	
	gpu.fillLine( 1, "FFFFFF" )
	gpu.fillLine( gpu.height, "FFFFFF" )
	shell._doGUI()
	
else
	io.write("Running on robot! Loading robot packages...")
	os.hookInt( "io_err", shell._recover )
	
	
	local files = component.invoke( computer.getBootAddress(), "list", "/system/robolib/" )
	
	for _, file in pairs( files ) do
		if io.fileExists("/system/robolib/"..file) then
			shell.runTask("/system/robolib/"..file )
		end
	end
	
	
	os.hookInt( "std_push", function()
		for pos, line in pairs( io._std ) do
			gpu.drawText( 2, pos+1, line.."                                                ", "FFFFFF", "000000" )
		end
	end)
	shell._doGUI = function( name )
	
		 

		gpu.drawText( 1, 1, tostring( math.ceil( (computer.totalMemory()-computer.freeMemory())/computer.totalMemory()*100 ) ).."% RAM used out of "..tostring( math.floor( computer.totalMemory()/1024)).."bytes total  ", "FFFFFF", "000000" )
		
		
	end
	
	shell._doGUI()
end

while true do
	os._processInts()
	if shell._next_upd < computer.uptime() then
		shell._doGUI()
		shell._next_upd = computer.uptime() + ( robot and 1 or 0.25 )
	end
	shell._doMultitask()
end
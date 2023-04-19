--[[----------------------------------------------------------
	Supertos Industries
	----------------------------------------------------------
	Autonomous MultiPurpose Robot
	Author: Supertos
	Year: 2023
	Ver: Rev 5
--]]----------------------------------------------------------

-------------------------------------
--[[-- COMPONENT INITIALIZING --]]--

do 
	
	config_report = ""
	for addr, component_type in component.list() do
		if component_type ~= "computer" then
			_G[ component_type ] = component.proxy( addr )
			_G[ component_type.."_addr" ] = addr
			config_report = config_report .. component_type .. " " .. tostring(addr) .. "\n"
		end
	end

	filesystem_addr = computer.getBootAddress()
	filesystem = component.proxy( computer.getBootAddress() )
	---------------------------------------
	--[[-- FILESYSTEM IMPLEMENTATION --]]--

	------------------------
	-- *readFile( path )
	-- Loads file
	function readFile( path )
		local invoke = component.invoke
		local handler = invoke( filesystem_addr, "open", path )
		local buffer = ""
		
		repeat
			local data = invoke( filesystem_addr, "read", handler, 64 )
			buffer = buffer .. ( data or "" )
		until not data
		invoke( filesystem_addr, "close", handler )
		
		return buffer 
	end
	
	load(readFile( "main.lua", "genfile", "bt", _G ))()
end
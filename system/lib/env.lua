--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	init.lua > env.lua
	
	Initializes env library
--]]----------------------------------------------------

env = {}
env.loaded_drivers = {}

--[[-- Load all required components --]]--



--[[-------------------------------------------------------------
	*env.reload()
	Checks all connected devices and loads possible components
--]]-------------------------------------------------------------
env.reload = function()
	io.write("Reloading all drivers!")
	local temp_gpu = nil
	local temp_scr = nil
	
	for _, name in pairs( env.loaded_drivers ) do --Deload all drivers
	
		if _G[name] and _G[name].reloadDriver then
			_G[name].reloadDriver()
		end
		
		_G[ name ] = nil
	end
	
	env.filesystem = computer.getBootAddress()
	if component.slot( computer.getBootAddress() ) then
		local boot = computer.getBootAddress()
		for addr, comType in component.list() do
			if comType then
				env[ comType ] = env[ comType ] or addr 
				
				if comType ~= "computer" then
					if io.fileExists( "/system/lib/drv/"..comType..".lua" ) then
						io.runFile("/system/lib/drv/"..comType..".lua")
						io.write("drv/"..comType..".lua", " loaded!")
					else
						if gpu then
							io.fatalError( "Unknown device with no driver!", comType, addr )
						else
							error("Unknown device with no driver:"..comType.." "..addr)
						end
					end
				end
			end
		end
	else
		io.fatalError( "Cannot operate with no harddrive!" )
	end
end




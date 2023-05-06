--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	init.lua > env.lua
	
	Initializes env library
--]]----------------------------------------------------

env = {}


--[[-- Load all required components --]]--



--[[-------------------------------------------------------------
	*env.reload()
	Checks all connected devices and loads possible components
--]]-------------------------------------------------------------
env.reload = function()

	local temp_gpu = nil
	local temp_scr = nil
	
	env.filesystem = computer.getBootAddress()
	if component.slot( computer.getBootAddress() ) then
		local boot = computer.getBootAddress()
		for addr, comType in component.list() do
				
			if comType == "filesystem" and addr == boot and state then
				env.drive = addr
			elseif comType == "gpu" then
				if temp_scr then
					component.invoke( addr, "bind", temp_scr )
					env.gpu = addr
				else temp_gpu = addr end
			elseif comType == "screen" then
				if temp_gpu then
					component.invoke( temp_gpu, "bind", addr )
					env.gpu = temp_gpu
				else temp_scr = addr end
			end
			
			if comType then
				env[ comType ] = env[ comType ] or addr 
				
				if comType ~= "computer" then
					if io.fileExists( "/system/lib/drv/"..comType..".lua" ) then
						io.runFile("/system/lib/drv/"..comType..".lua")
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




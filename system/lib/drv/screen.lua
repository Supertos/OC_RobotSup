--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	env.lua > screen.lua
	
	Initializes screen library
--]]----------------------------------------------------

screen = {}
if gpu then	component.invoke( gpu.dev, "bind", env.screen ) end
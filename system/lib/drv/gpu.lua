--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	env.lua > gpu.lua
	
	Initializes gpu library
--]]----------------------------------------------------

gpu = {}

gpu.dev = env.gpu

gpu.background = ""
gpu.foreground = ""

local w, h = component.invoke( env.gpu, "getResolution" )
gpu.width = w
gpu.height = h

--[[-------------------------------------------------------------
	*gpu.drawText( x, y, text to draw, *foreground, *background )
	Draws text at gpu
--]]-------------------------------------------------------------
gpu.drawText = function( x, y, text, color, back )
		
	if not back then back = "000000" end
	if not color then color = "FFFFFF" end
		
	if gpu.foreground ~= color then
		component.invoke( gpu.dev, "setForeground", tonumber(color or "FFFFFF", 16) )
		gpu.foreground = color
	end
		
	if gpu.background ~= back then
		component.invoke( gpu.dev, "setBackground", tonumber(back or "FFFFFF", 16) )
		gpu.background = back
	end
		
	component.invoke( gpu.dev, "set", x, y, tostring( text ) )
end

--[[-------------------------------------------------------------
	*gpu.fill( color )
	Fills whole screen with provided color
--]]-------------------------------------------------------------
gpu.fill = function( color )
	gpu.background = color
	component.invoke( gpu.dev, "setBackground", tonumber(color or "FFFFFF", 16) )
	component.invoke( gpu.dev, "fill", 1, 1, gpu.width, gpu.height, " " )
	
end
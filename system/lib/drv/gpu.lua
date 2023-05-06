--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	env.lua > gpu.lua
	
	Initializes gpu library
--]]----------------------------------------------------

gpu = {}

gpu.dev = env.gpu

gpu.background = 22
gpu.foreground = 22

local w, h = component.invoke( env.gpu, "getResolution" )
gpu.width = w
gpu.height = h

if screen then component.invoke( gpu.dev, "bind", env.screen ) end
--[[-------------------------------------------------------------
	*gpu.drawText( x, y, text to draw, *foreground, *background )
	Draws text at gpu
--]]-------------------------------------------------------------
gpu.drawText = function( x, y, text, color, back )
	
	
	back = tonumber(back or "000000", 16)
	color = tonumber(color or "FFFFFF", 16)
		
	if gpu.foreground ~= color then
		component.invoke( gpu.dev, "setForeground", color )
		gpu.foreground = color
	end
		
	if gpu.background ~= back then
		component.invoke( gpu.dev, "setBackground", back )
		gpu.background = back
	end
		
	component.invoke( gpu.dev, "set", x, y, tostring( text ) )
end

--[[-------------------------------------------------------------
	*gpu.fill( color )
	Fills whole screen with provided color
--]]-------------------------------------------------------------
gpu.fill = function( color )
	color = tonumber(color or "FFFFFF", 16)
	gpu.background = color
	component.invoke( gpu.dev, "setBackground", color )
	component.invoke( gpu.dev, "fill", 1, 1, gpu.width, gpu.height, " " )
	
end

--[[-------------------------------------------------------------
	*gpu.fillLine( id, color )
	Fills line with provided color
--]]-------------------------------------------------------------
gpu.fillLine = function( y, color )
	color = tonumber(color or "FFFFFF", 16)
	gpu.background = color
	component.invoke( gpu.dev, "setBackground", color )
	component.invoke( gpu.dev, "fill", 1, y, gpu.width, 1, " " )
	
end
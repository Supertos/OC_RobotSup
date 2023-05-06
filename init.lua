--[[----------------------------------------------------
	Supertos Industries
	----------------------------------------------------
	init.lua
	
	Handles OS initialize
--]]----------------------------------------------------

local addr, invoke = computer.getBootAddress(), component.invoke
function loadfile(file)
    local handle = assert(invoke(addr, "open", file))
    local buffer = ""
    repeat
      local data = invoke(addr, "read", handle, math.huge)
      buffer = buffer .. (data or "")
    until not data
    invoke(addr, "close", handle)
    return load(buffer, "=" .. file, "bt", _G)
 end


os = {}
loadfile("/system/lib/io.lua")(loadfile)

loadfile("/system/lib/interrupts.lua")(loadfile)

loadfile("/system/lib/env.lua")(loadfile)
env.reload()
local hookUpd = function() env.reload() end
os.hookInt( "component_added", hookUpd )
os.hookInt( "component_removed", hookUpd )


if gpu then gpu.drawText( 1, 1, "Interrupt handle loaded!" ) end
computer.beep(300)




if gpu then gpu.drawText( 1, 2, "I/O lib loaded!" ) end
computer.beep(400)
if gpu then gpu.drawText( 1, 3, "Press any key to continue..." ) end
computer.beep(500)

-- io.waitForKey()
-- computer.beep(600)
-- io.reboot()
while true do
	os._processInts()
	-- coroutine.yield()
end
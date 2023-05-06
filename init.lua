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
 
string.split = function(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[ #t + 1 ] = str
    end
    
	return t
end


local load_queue = {
	"/system/lib/io.lua",
	"/system/lib/interrupts.lua",
	"/system/lib/env.lua"
}

os = {}
io = {}
env = {}
interrupt = {}


local beep_step = 2000/#load_queue
for beep, file in pairs( load_queue ) do
	loadfile(file)(loadfile)
	io.write( file, " loaded!" )
	computer.beep( math.floor(beep_step*beep) )
end

env.reload()
os.hookInt( "component_added", env.reload )
os.hookInt( "component_removed", env.reload )
if gpu then error = io.error end

loadfile( "/program files/Shell/init.lua" )(loadfile)
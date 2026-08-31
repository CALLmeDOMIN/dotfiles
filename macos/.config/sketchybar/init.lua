sbar = require("sketchybar")

-- WORKAROUND: Add sbar.log if it's missing from the loaded module
if sbar and type(sbar.log) ~= "function" then
    print("WARNING: sbar.log is missing from the 'sketchybar' module. Using print() as a fallback for logging.")
    sbar.log = function(...)
        local args = {...}
        local log_string = "SKETCHYBAR_LUA_LOG: "
        for i, v in ipairs(args) do
            log_string = log_string .. tostring(v)
            if i < #args then
                log_string = log_string .. "\t" -- Add a tab between arguments
            end
        end
        print(log_string) -- Output to SketchyBar's stdout/stderr
    end
    print("Fallback sbar.log has been defined.")
else
    if sbar then
        print("sbar.log was already defined in the 'sketchybar' module.")
    else
        print("ERROR: 'sbar' module failed to load, sbar is nil.")
    end
end

-- Set the bar name, if you are using another bar instance than sketchybar
-- sbar.set_bar_name("bottom_bar")

-- Bundle the entire initial configuration into a single message to sketchybar
sbar.begin_config()
require("bar")
require("default")
require("items") -- This will eventually load your items/spaces.lua
sbar.end_config()

-- Run the event loop of the sketchybar module (without this there will be no
-- callback functions executed in the lua module)
sbar.event_loop()

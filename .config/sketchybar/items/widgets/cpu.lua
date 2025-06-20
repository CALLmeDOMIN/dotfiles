local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

-- Item for the CPU percentage text
local cpu_percent = sbar.add("item", "widgets.cpu1" , {
  position = "right",
  padding_left = 0,
  icon = { drawing = false },
  label = {
    string = "??%",
    font = {
        family = settings.font.numbers,
        style = settings.font.style_map["Bold"],
        size = 14.0,
    },
    y_offset = 1,
  },
})

-- Item for the CPU icon
local cpu_icon = sbar.add("item", "widgets.cpu2", {
  position = "right",
  padding_right = 0,
  icon = {
    string = icons.cpu,
    align = "left",
    color = colors.white,
    font = {
        style = settings.font.style_map["Regular"],
        size = 14.0,
     },
     y_offset = 1,
  },
  label = { drawing = false },
})

-- Subscribe to the "cpu_update" event for BOTH items
cpu_percent:subscribe("cpu_update", function(env)
  local load = tonumber(env.total_load)

  -- Update the label of the percentage item
  cpu_percent:set({
    label = env.total_load .. "%",
  })
end)

cpu_icon:subscribe("cpu_update", function(env)
  local load = tonumber(env.total_load)

  local color = colors.white
  if load > 30 then
    if load < 60 then
      color = colors.yellow
    elseif load < 80 then
      color = colors.orange
    else
      color = colors.red
    end
  end

  cpu_icon:set({
    icon = { color = color },
  })
end)

-- Subscribe to the "mouse.clicked" event for the icon item
cpu_icon:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around BOTH cpu items
sbar.add("bracket", "widgets.cpu.bracket", { cpu_percent.name, cpu_icon.name }, {
  background = { 
      color = colors.bg1, 
  }
})

-- Background around the cpu item (adjust or remove as needed)
-- This padding item might need its width adjusted based on the combined width of your new items
sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width = settings.group_paddings
})


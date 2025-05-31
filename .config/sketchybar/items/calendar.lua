local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
  icon = {
    color = colors.white,
    padding_left = 8,
    font = {
      style = settings.font.style_map["Regular"],
      size = 12.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 8,
    width = 125,
    align = "right",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Regular"],
    },
  },
  position = "right",
  update_freq = 30,
  padding_left = 1,
  padding_right = 1,
})


cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
  local formatted_datetime = os.date("%d/%m/%Y %H:%M")
  cal:set({ icon = "", label = formatted_datetime })
end)

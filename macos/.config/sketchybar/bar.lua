local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  -- topmost = "window",
  height = 40,
  color = colors.bar.bg,
  padding_right = 0,
  padding_left = 5,
  blur_radius = 0,
  shadow = true,
  y_offset = 0,
  margin = 0,
  corner_radius = 0,
})

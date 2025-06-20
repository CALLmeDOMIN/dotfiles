return {
	black = 0xff232136,    -- base
	white = 0xffe0def4,    -- text
	red = 0xffeb6f92,      -- love
	green = 0xff3e8fb0,    -- pine
	blue = 0xff9ccfd8,     -- foam
	yellow = 0xfff6c177,   -- gold
	orange = 0xffff8000,   -- rose
	magenta = 0xffc4a7e7,  -- iris
	grey = 0xff6e6a86,     -- muted
	transparent = 0x00000000,

	bar = {
		bg = 0x002a273f,       -- surface
		border = 0x00524f67,   -- highlightHigh
	},
	popup = {
		bg = 0xff000000,       -- overlay with alpha
		border = 0x0044415a,   -- highlightMed
	},
	bg1 = 0xaa000000,         -- background
	bg2 = 0xccff8000,         -- border

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}

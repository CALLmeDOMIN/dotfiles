-- Hyprland Lua configuration entry point.
-- See https://wiki.hypr.land/Configuring/Start/
--
-- Config is split into modules under modules/, required below.
-- Migrated stage by stage from the old hyprland.conf (see hyprland.conf.bak):
--   Stage 1: monitors, autostart, env vars, look & feel, input
--   Stage 2: keybindings
--   Stage 3 (this): window/layer/workspace rules
-- All done.

require("modules.monitors")
require("modules.autostart")
require("modules.env")
require("modules.look")
require("modules.input")
require("modules.binds")
require("modules.rules")

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Restrict certain windows to certain workspaces
hl.window_rule({ match = { class = "^(discord)$" }, workspace = "1 silent" })
hl.window_rule({ match = { class = "^(zen)$" },      workspace = "2 silent" })

hl.window_rule({ match = { class = "^(vintagestory.exe)$" }, immediate = true })

-- Vicinae (menu) layer rules
hl.layer_rule({
    name         = "vicinae-blur",
    match        = { namespace = "vicinae" },
    blur         = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    name    = "vicinae-no-animation",
    match   = { namespace = "vicinae" },
    no_anim = true,
})

-- Picture-in-Picture window (Zen browser)
hl.window_rule({ match = { class = "^(zen)$", title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { class = "^(zen)$", title = "^(Picture-in-Picture)$" }, pin = true })
-- New PiP size (e.g. 640x360 for a 1440p monitor)
hl.window_rule({ match = { class = "^(zen)$", title = "^(Picture-in-Picture)$" }, size = { 640, 360 } })
-- Move to bottom-left corner with a margin, absolute pixel values
hl.window_rule({ match = { class = "^(zen)$", title = "^(Picture-in-Picture)$" }, move = { 1650, 120 } })

-- Example window rules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = { 20, "monitor_h-120" },
    float = true,
})

-- GPU stats terminal (see modules/autostart.lua)
hl.window_rule({ match = { initial_class = "com.gpu.stats" }, float = true })
hl.window_rule({ match = { initial_class = "com.gpu.stats" }, size = { 800, 500 } })
hl.window_rule({ match = { initial_class = "com.gpu.stats" }, center = true })

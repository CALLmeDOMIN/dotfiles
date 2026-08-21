local programs = require("modules.programs")

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("linux-wallpaperengine --screen-root HDMI-A-1 2797965500") -- Blade Runner 2049

    -- Regenerate pywal colors (used by hyprlock) from a static extracted
    -- frame of the wallpaper-engine background (see wallpapers/lockscreen.jpg).
    -- -n: don't set the wallpaper via wal itself (wallpaperengine owns that)
    -- -s: don't recolor open terminals    -e: skip gtk/xrdb/i3/sway reload
    hl.exec_cmd("wal -n -s -e -q -i ~/dotfiles/wallpapers/lockscreen.jpg")

    -- dark mode / GTK theming
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Catppuccin-Mocha-Standard-Mauve-Dark'")
    hl.exec_cmd("nwg-look -a")

    hl.exec_cmd("discord")
    hl.exec_cmd("zen-browser")
    hl.exec_cmd(programs.terminal, { workspace = "4 silent" })

    -- app launcher
    hl.exec_cmd("vicinae server")

    -- GPU stats terminal on its own special workspace
    hl.exec_cmd('/usr/bin/ghostty --class=com.gpu.stats -e "nvidia-smi -l 1"', { workspace = "special:stats silent" })

    -- Watches the active window class and unbinds/rebinds ALT+LMB drag so it
    -- doesn't fight with in-game mouse look (see scripts/bg3-submap-watch.sh)
    hl.exec_cmd("~/.config/hypr/scripts/bg3-submap-watch.sh")
end)

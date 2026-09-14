#!/bin/bash
socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | \
while read -r line; do
    case "$line" in
        activewindow\>\>*)
            class="${line#activewindow>>}"
            class="${class%%,*}"
            if [[ "$class" == "bg3" ]]; then
                hyprctl keyword unbind ALT,mouse:272
            else
                hyprctl keyword bindm ALT,mouse:272,movewindow
            fi
            ;;
    esac
done

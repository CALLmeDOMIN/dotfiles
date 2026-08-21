#!/usr/bin/env bash
STATE=/tmp/hypr-gamemode
NOTIF_ID=9999

if [[ -f $STATE ]]; then
    hyprctl reload
    rm "$STATE"
    dunstify -a gamemode -r $NOTIF_ID -t 2000 "Gamemode OFF"
else
    hyprctl --batch "\
        keyword unbind ALT, mouse:272;\
        keyword unbind ALT, mouse:273"
    touch "$STATE"
    dunstify -a gamemode -r $NOTIF_ID -t 2000 "🎮 Gamemode ON"
fi

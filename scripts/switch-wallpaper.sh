#!/usr/bin/env bash
# Switch the wallpaper-engine background live, and refresh the lock-screen
# color palette to match - no relogin needed for either.
#
# Usage: switch-wallpaper.sh <workshop-id>

set -euo pipefail

ID="${1:?Usage: switch-wallpaper.sh <workshop-id>}"
CONTENT_DIR="$HOME/.local/share/Steam/steamapps/workshop/content/431960/$ID"
PREVIEW="$CONTENT_DIR/preview.jpg"
LOCKSCREEN_IMG="$HOME/dotfiles/wallpapers/lockscreen.jpg"

if [[ ! -d "$CONTENT_DIR" ]]; then
    echo "Workshop item $ID not found at $CONTENT_DIR (not downloaded/subscribed via Steam?)" >&2
    exit 1
fi

if [[ ! -f "$PREVIEW" ]]; then
    echo "No preview.jpg in $CONTENT_DIR - can't refresh colors, but will still switch the wallpaper." >&2
fi

pkill -f "linux-wallpaperengine --screen-root" || true
sleep 0.5
linux-wallpaperengine --screen-root HDMI-A-1 "$ID" >/dev/null 2>&1 &
disown

if [[ -f "$PREVIEW" ]]; then
    cp "$PREVIEW" "$LOCKSCREEN_IMG"
    # pywal caches its computed palette per image path, not per content -
    # since this script always reuses the same lockscreen.jpg path, the
    # stale cache entry has to be cleared or wal just re-serves old colors.
    rm -f ~/.cache/wal/schemes/_home_"$USER"_dotfiles_wallpapers_lockscreen_jpg_*
    wal -n -s -e -q -i "$LOCKSCREEN_IMG"
fi

echo "Switched to workshop item $ID"

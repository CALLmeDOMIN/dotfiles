# References: Fernando Cejas (https://fernandocejas.com/blog/engineering/2022-03-30-arch-linux-system-maintance/)
echo "----------------------------------------------------"
echo "UPDATING SYSTEM"
echo "----------------------------------------------------"

yay -Syu

echo ""
echo "----------------------------------------------------"
echo "REBUILDING AUR PACKAGES FLAGGED BY PACMAN HOOKS"
echo "----------------------------------------------------"

# Pacman hooks can't rebuild AUR packages inline (they run while pacman holds
# db.lck, so a nested yay deadlocks). Instead they drop a flag file here and we
# do the rebuild now, outside any transaction.
rebuild_dir=/var/lib/aur-rebuild
found=0
for stamp in "$rebuild_dir"/*; do
    [ -e "$stamp" ] || continue
    found=1
    pkg=$(basename "$stamp")
    echo "Rebuilding $pkg..."
    if yay -S --rebuild --noconfirm "$pkg"; then
        rm -f "$stamp"
    else
        echo "WARNING: $pkg failed to rebuild; keeping its flag for next run."
    fi
done
[ "$found" -eq 0 ] && echo "No AUR packages flagged for rebuild."

echo ""
echo "----------------------------------------------------"
echo "CLEARING PACMAN CACHE"
echo "----------------------------------------------------"

pacman_cache_space_used="$(du -sh /var/cache/pacman/pkg/)"
echo "Space currently in use: $pacman_cache_space_used"
echo ""
echo "Clearing Cache, leaving newest 2 versions:"
paccache -vrk2
echo ""
echo "Clearing all uninstalled packages:"
paccache -ruk0

echo ""
echo "----------------------------------------------------"
echo "REMOVING ORPHANED PACKAGES"
echo "----------------------------------------------------"

orphaned=$(yay -Qdtq)
if [ -n "$orphaned" ]; then
    echo "$orphaned" | yay -Rns -
else
    echo "No orphaned packages to remove."
fi

echo ""
echo "----------------------------------------------------"
echo "CLEARING HOME CACHE"
echo "----------------------------------------------------"

home_cache_used="$(du -sh ~/.cache)"
rm -rf ~/.cache/
echo "Clearing ~/.cache/..."
echo "Spaced saved: $home_cache_used"

echo ""
echo "----------------------------------------------------"
echo "CLEARING SYSTEM LOGS"
echo "----------------------------------------------------"

sudo journalctl --vacuum-time=7d
echo ""


yay -S --noconfirm --needed waybar-git zen-browser-bin oh-my-posh linux-wallpaperengine-git fnm sddm-silent-theme papirus-icon-theme vicinae-bin

# power menu, graceful uwsm-aware shutdown/reboot, cursor theme, GTK theme
yay -S --noconfirm --needed wlogout hyprshutdown bibata-cursor-theme catppuccin-gtk-theme-mocha

# image viewer (no official repo package, AUR only)
yay -S --noconfirm --needed qimgv-git

# qimgv's .desktop only claims jpeg/png/gif/bmp/webp, but Qt's libqtiff covers
# tiff too. video/webm is deliberately left to mpv - qimgv claims it, but it's
# an image viewer. image/svg+xml is left to gimp for the same reason.
for m in image/jpeg image/png image/gif image/bmp image/webp image/tiff; do
  xdg-mime default qimgv.desktop "$m"
done

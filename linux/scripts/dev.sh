#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed git base-devel

sudo pacman -S --noconfirm --needed bat btop gimp lsd tldr fzf ghostty hyprpolkitagent wl-clipboard hyprlauncher zsh neovim stow fastfetch fortune-mod hyprpicker hyprlock ttf-jetbrains-mono-nerd qt5ct qt6ct nwg-look pavucontrol fd pnpm docker bluez luarocks bluez-utils blueman noto-fonts-emoji

# waybar prerequisities
sudo pacman -S --noconfirm --needed \
  gtkmm3 \
  jsoncpp \
  libsigc++ \
  fmt \
  chrono-date \
  spdlog \
  gobject-introspection \
  libmpdclient \
  sndio \
  meson \
  cmake \
  scdoc \
  glib2-devel

# session/login stack (uwsm-managed Hyprland session via sddm)
sudo pacman -S --noconfirm --needed uwsm sddm

# notifications, cursor theming source, wallpaper->colorscheme pipeline
sudo pacman -S --noconfirm --needed dunst python-pywal imagemagick

# nvidia stats (used by waybar's gpu module)
sudo pacman -S --noconfirm --needed nvidia-utils

# networking GUI (nm-connection-editor)
sudo pacman -S --noconfirm --needed network-manager-applet

# hypr ecosystem extras
sudo pacman -S --noconfirm --needed hyprtoolkit

# system maintenance (paccache, pacdiff, reflector mirror refresh)
sudo pacman -S --noconfirm --needed pacman-contrib reflector

# used by waybar's weather/docker/gpu custom modules
sudo pacman -S --noconfirm --needed jq

# scans installed packages against known CVEs
sudo pacman -S --noconfirm --needed arch-audit

# file manager (nemo) + plugins. gvfs is NOT optional: without it nemo has no
# trash, no network shares and no phone/camera mounting. Dolphin never needed
# it because KIO covers that itself, so it won't already be installed.
sudo pacman -S --noconfirm --needed nemo nemo-fileroller nemo-terminal nemo-audio-tab \
  nemo-media-columns nemo-emblems nemo-image-converter nemo-compare nemo-pastebin
sudo pacman -S --noconfirm --needed gvfs gvfs-mtp gvfs-afc gvfs-gphoto2 gvfs-smb

# Open folders in nemo. Worth setting explicitly - with nothing registered,
# inode/directory falls to whichever .desktop claims it first (it was
# kitty-open.desktop here, so folders opened in a terminal).
xdg-mime default nemo.desktop inode/directory

# nemo's "Open in Terminal" hardcodes gnome-terminal otherwise
gsettings set org.cinnamon.desktop.default-applications.terminal exec ghostty
gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg -e

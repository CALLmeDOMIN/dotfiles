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

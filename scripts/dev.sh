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

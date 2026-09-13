# Dotfiles

Single-branch layout, stowed with GNU stow:

- `common/` - stowed on every machine (shell, git, nvim, fastfetch)
- `macos/` - stowed only on macOS (aerospace, sketchybar, karabiner, etc.)
- `linux/` - stowed only on Linux (hyprland, waybar, rofi, etc.)
- `windows/` - reference config for native Windows tools (glazewm, zebar); not installed by `install.sh`

## Setup

```sh
./install.sh                     # stows common/ + the detected OS package
./install.sh --identity work     # also link ~/.gitconfig-identity to common/.gitconfig-work
./install.sh --identity personal
```

Git identity (work vs personal email) is chosen once per machine via a symlink at
`~/.gitconfig-identity`, not switched dynamically - see `install.sh`.

Machine-specific overrides that don't belong in version control go in
`~/.zshrc.local` (untracked, sourced automatically if present).

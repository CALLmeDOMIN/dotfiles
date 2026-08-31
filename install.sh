#!/usr/bin/env bash
# Installs dotfiles via GNU stow: common/ always, plus one OS-specific package.
#
# Usage: ./install.sh [--identity work|personal]
#
# The windows/ package (glazewm, zebar) is for native Windows tools and is not
# installed by this script - copy those files into place manually on Windows.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU stow is required but not installed. Install it first (e.g. 'brew install stow' or 'sudo pacman -S stow')." >&2
  exit 1
fi

case "$(uname -s)" in
  Darwin) OS_PACKAGE="macos" ;;
  Linux)  OS_PACKAGE="linux" ;;
  *)
    echo "Unsupported OS for automatic install: $(uname -s). See windows/ for manual setup." >&2
    exit 1
    ;;
esac

echo "Stowing common/ ..."
stow -d "$DOTFILES_DIR" -t "$HOME" common

echo "Stowing $OS_PACKAGE/ ..."
stow -d "$DOTFILES_DIR" -t "$HOME" "$OS_PACKAGE"

# Git identity: pick once per machine, symlinked (not copied) so future edits
# to common/.gitconfig-work or common/.gitconfig-personal apply automatically.
IDENTITY="${1:-}"
if [ "$IDENTITY" = "--identity" ]; then
  IDENTITY="${2:-}"
fi

if [ -e "$HOME/.gitconfig-identity" ] || [ -L "$HOME/.gitconfig-identity" ]; then
  echo "~/.gitconfig-identity already exists, leaving it as-is."
elif [ "$IDENTITY" = "work" ] || [ "$IDENTITY" = "personal" ]; then
  ln -s "$DOTFILES_DIR/common/.gitconfig-$IDENTITY" "$HOME/.gitconfig-identity"
  echo "Linked ~/.gitconfig-identity -> common/.gitconfig-$IDENTITY"
else
  echo
  echo "No git identity set yet. Run one of:"
  echo "  ln -s $DOTFILES_DIR/common/.gitconfig-work     ~/.gitconfig-identity"
  echo "  ln -s $DOTFILES_DIR/common/.gitconfig-personal ~/.gitconfig-identity"
fi

# Same idea for zsh (e.g. work-only aliases in common/.zshrc-work). Only links
# if a file for the chosen identity actually exists - not every identity needs one.
if [ -e "$HOME/.zshrc-identity" ] || [ -L "$HOME/.zshrc-identity" ]; then
  echo "~/.zshrc-identity already exists, leaving it as-is."
elif { [ "$IDENTITY" = "work" ] || [ "$IDENTITY" = "personal" ]; } && [ -f "$DOTFILES_DIR/common/.zshrc-$IDENTITY" ]; then
  ln -s "$DOTFILES_DIR/common/.zshrc-$IDENTITY" "$HOME/.zshrc-identity"
  echo "Linked ~/.zshrc-identity -> common/.zshrc-$IDENTITY"
fi

echo "Done."

# compinstall
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle :compinstall filename "$HOME/.zshrc"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -e

# FZF CACHE
FZF_DIR_CACHE="$HOME/.cache/fd_dirs.txt"

update_dir_cache() {
  local lockfile="$HOME/.cache/fd_dirs.lock"
  ( if ( set -o noclobber; > "$lockfile" ) 2>/dev/null; then
      trap "rm -f '$lockfile'" EXIT
      fd --type d --hidden \
        --exclude .git --exclude node_modules --exclude .cache \
        --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv \
        --base-directory "$HOME" \
        > "$FZF_DIR_CACHE" 2>/dev/null
      rm -f "$lockfile"
    fi & )
}

alias f='cd "$HOME/$(cat "$FZF_DIR_CACHE" | fzf)"'

# go (portable: works regardless of how go was installed)
export PATH="$PATH:$(go env GOBIN 2>/dev/null):$(go env GOPATH 2>/dev/null)/bin"

# java (asdf-managed)
export JAVA_HOME="${ASDF_DATA_DIR:-$HOME/.asdf}/installs/java/corretto-21.0.8.9.1"

# ASDF (portable shims/completions; the asdf.sh sourcing itself is OS-specific -
# see macos/.zshrc-os / linux/.zshrc-os, since install method differs per OS)
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
fpath=(${ASDF_DATA_DIR:-$HOME/.asdf}/completions $fpath)
autoload -Uz compinit && compinit

# aliases
alias cl='clear'
alias clera='clear'
alias ls='lsd -la'
alias cat='bat'
alias exp='explorer.exe .'
alias cls='cl && ls'
alias repos='cd ~/repos'
alias cdr='cd ~'
alias vim='nvim'
alias count='ls -1 | wc -l'
alias wtls='git wtls'
alias profile='vim ~/.zshrc'
alias zshrc='vim ~/.zshrc'
alias srcp='exec zsh'
alias cc='claude'
alias ccr='claude --resume'

# WORKTREES
wt() {
  local root parent repo wt_path
  root=$(git rev-parse --show-toplevel) || return 1
  parent=$(dirname "$root")
  repo=$(basename "$root")
  wt_path="$parent/${repo}-worktrees/$1"
  mkdir -p "$parent/${repo}-worktrees"
  git fetch origin --quiet
  if git show-ref --verify --quiet "refs/heads/$1" || git show-ref --verify --quiet "refs/remotes/origin/$1"; then
    git worktree add "$wt_path" "$1"
  else
    git worktree add "$wt_path" -b "$1" origin/master
  fi
  cd "$wt_path" && zed .
  update_dir_cache
}

wtrm() {
    local target=$(cd "$1" && pwd)
    [[ "$PWD" == "$target"* ]] && cd "$(git rev-parse --show-toplevel)/.."
    git worktree remove "$target"
    update_dir_cache
}

wts() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "wts: not in a git repository — cd into one first (try \`f\`)" >&2
    return 1
  }
  local selected
  selected=$(git worktree list | fzf --preview 'echo {}')
  [[ -z "$selected" ]] && return 1
  cd "${selected%% *}" && zed .
}

# console ninja
PATH=~/.console-ninja/.bin:$PATH

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH=$HOME/.local/bin:$PATH

# oh-my-posh
if command -v oh-my-posh >/dev/null; then
  eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json')"
fi

# OS-specific additions (provided by the macos/ or linux/ stow package)
[ -f "$HOME/.zshrc-os" ] && source "$HOME/.zshrc-os"

# identity-specific additions (work vs personal) - untracked, symlinked once per
# machine to common/.zshrc-work or common/.zshrc-personal. See install.sh.
[ -f "$HOME/.zshrc-identity" ] && source "$HOME/.zshrc-identity"

# per-machine overrides (untracked)
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

fastfetch
fortune
update_dir_cache

# corepack: never auto-write packageManager into package.json
export COREPACK_ENABLE_AUTO_PIN=0

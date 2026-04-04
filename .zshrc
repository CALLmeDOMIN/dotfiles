# compinstall
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle :compinstall filename '/Users/cmdmac/.zshrc'

autoload -Uz compinit
compinit

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep

# brew
export PATH="/opt/homebrew/bin:$PATH"

# fnm
eval "$(fnm env --use-on-cd)"

# go
export PATH=$PATH:/usr/local/go/bin

# aliases
alias cl='clear'
alias clera='clear'
alias profile='vim ~/.zshrc'
alias srcp='exec zsh'
alias ls='lsd -la'
alias cat='bat'
alias exp='explorer.exe .'
alias cls='cl && ls'
alias repos='cd ~/repos'
alias vim='nvim'
alias f='cd $(fd --type d --hidden --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv | fzf)'
alias clients='yabai -m query --windows'
alias count='ls -1 | wc -l'

# console ninja
PATH=~/.console-ninja/.bin:$PATH

# bun completions
[ -s "/Users/cmdmac/.bun/_bun" ] && source "/Users/cmdmac/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
FNM_PATH="/opt/homebrew/bin/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

export PATH=$HOME/.local/bin:$PATH

# pnpm
export PNPM_HOME="/Users/cmdmac/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# oh-my-posh
eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json')"
bindkey -e

fastfetch
fortune

# Added by Antigravity
export PATH="/Users/cmdmac/.antigravity/antigravity/bin:$PATH"

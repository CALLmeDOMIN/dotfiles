# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -v

# go
export PATH="$PATH:$(go env GOBIN):$(go env GOPATH)/bin"

# aliases
alias cl='clear'
alias clera='clear'
alias zshrc='nvim ~/.zshrc'
alias srcp='source ~/.zshrc'
alias ls='lsd -la'
alias cat='bat'
alias exp='explorer.exe .'
alias cls='cl && ls'
alias repos='cd ~/repos'
alias cdr='cd ~'
alias vim='nvim'
alias f='cd $(fd --type d --hidden --exclude .git --exclude node_module --exclude .cache --exclude .npm --exclude .mozilla --exclude .meteor --exclude .nv | fzf)'

alias dev='~/dotfiles/scripts/dev.sh'
alias devyay='~/dotfiles/scripts/dev-yay.sh'
alias bye="hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'"
alias reboot="hyprshutdown -t 'Restarting...' --post-cmd 'reboot'"

# console ninja
PATH=~/.console-ninja/.bin:$PATH

# bun completions #! wrong path
[ -s "/home/cmd/.bun/_bun" ] && source "/home/cmd/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
FNM_PATH="/home/cmdarch/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

export PATH=$HOME/.local/bin:$PATH

# for non-pattern search like in bash 
bindkey "^R" history-incremental-search-backward

# oh-my-posh
eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json')"

fastfetch
fortune

# pnpm
export PNPM_HOME="/home/cmdarch/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

set +H

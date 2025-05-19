# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:]}={[:upper:]}' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2 numeric
zstyle :compinstall filename '/home/domin/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -v

# End of lines configured by zsh-newuser-install

# go
export PATH=$PATH:/usr/local/go/bin

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


# console ninja
PATH=~/.console-ninja/.bin:$PATH

# bun completions
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

neofetch
fortune

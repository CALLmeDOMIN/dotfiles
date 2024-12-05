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
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/catppuccin_mocha.omp.json)"
fi

# go
export PATH=$PATH:/usr/local/go/bin

# aliases
alias cl='clear'
alias clera='clear'
alias profile='vim ~/.zshrc'
alias execp='exec zsh'
alias ls='lsd -la'
alias cat='bat'
alias exp='explorer.exe .'
alias cls='cl && ls'

# console ninja
PATH=~/.console-ninja/.bin:$PATH

# bun completions
[ -s "/home/cmd/.bun/_bun" ] && source "/home/cmd/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH=$HOME/.local/bin:$PATH

fortune

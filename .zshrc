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

alias cl='clear'
alias clera='clear'
alias profile='vim ~/.zshrc'
alias execp='exec zsh'
alias ls='lsd -lah'
alias cat='bat'

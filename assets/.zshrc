export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gruz0"
DISABLE_AUTO_UPDATE="true"

plugins=(git bundler osx rake ruby)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias docker-clean-unused='docker system prune --all --force --volumes'
alias docker-clean-all='docker container stop $(docker container ls -a -q) && docker system prune -a -f --volumes'
alias docker-clean-none-containers='docker rmi -f $(docker images | grep none | awk "{ print $3 }")'

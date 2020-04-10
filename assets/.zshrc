export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gruz0"
DISABLE_AUTO_UPDATE="true"
NVIM_TUI_ENABLE_TRUE_COLOR=1

plugins=(
  git
  bundler
  osx
  rake
  ruby
  docker
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source ~/.rvm/scripts/rvm

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
alias docker-stop-all='docker stop $(docker ps -q)'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Go development
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

alias ctags="`brew --prefix`/bin/ctags"

alias csv='column -s, -t'

function grep-before() { grep -rnI -B 5 "$@" * ;}
function grep-after() { grep -rnI -A 5 "$@" * ;}
function grep-around() { grep -rnI -C 5 "$@" * ;}

alias nmap-vulners="cd ~/Soft/nmap; nmap --script vulscan,nmap-vulners -sV"

alias ls='exa'
alias la='exa --git --header --long --all'
alias flushdns='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed'

# Use it as `swaggerize path/to/directory/contains/swagger.json`
alias swaggerize='swaggerize() { docker run -p 80:8080 -e SWAGGER_JSON=/foo/swagger.json -v $(pwd)/$1:/foo swaggerapi/swagger-ui };swaggerize'

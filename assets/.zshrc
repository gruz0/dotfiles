export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gruz0"

# OS-aware plugins
if [[ "$OSTYPE" == "darwin"* ]]; then
  plugins=(
    git
    bundler
    macos
    rake
    ruby
    docker
    zsh-autosuggestions
  )
else
  plugins=(
    git
    bundler
    rake
    ruby
    docker
    zsh-autosuggestions
  )
fi

source $ZSH/oh-my-zsh.sh

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Local user binaries (e.g., neovim, sops)
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Locale settings
export LC_ALL=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

alias docker-clean-unused='docker system prune --all --force --volumes'
alias docker-clean-all='containers=$(docker container ls -a -q); [ -n "$containers" ] && docker container stop $containers; docker system prune -a -f --volumes'
alias docker-clean-none-containers='docker rmi -f $(docker images | grep none | awk "{ print $3 }")'
alias docker-stop-all='docker stop $(docker ps -q)'

# RVM (Ruby Version Manager)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export PATH="$PATH:/usr/local/sbin"

# Optional PATH additions (only if directories exist)
[ -d "$HOME/.npm-packages/bin" ] && export PATH="$HOME/.npm-packages/bin:$PATH"
[ -d "$HOME/.foundry/bin" ] && export PATH="$PATH:$HOME/.foundry/bin"

# Go development
export GOPATH="${HOME}/.go"
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS with Homebrew
  export GOROOT="$(brew --prefix golang)/libexec"
else
  # Linux
  export GOROOT="/usr/local/go"
fi
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# macOS uses Homebrew's ctags
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias ctags="`brew --prefix`/bin/ctags"
fi

alias csv='column -s, -t'

function grep-before() { grep -rnI -B 5 "$@" * ;}
function grep-after() { grep -rnI -A 5 "$@" * ;}
function grep-around() { grep -rnI -C 5 "$@" * ;}

# macOS-only: Flush DNS cache
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias flushdns='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed'
fi

# Cross-platform 'open' command
if [[ "$OSTYPE" != "darwin"* ]]; then
  # On Linux/WSL, provide an 'open' command similar to macOS
  if command -v xdg-open &> /dev/null; then
    # Standard Linux
    alias open='xdg-open'
  elif command -v explorer.exe &> /dev/null; then
    # WSL - use Windows explorer
    function open() {
      local target="$1"
      if [ -z "$target" ]; then
        echo "Usage: open <file|directory|url>"
        return 1
      fi
      # Convert WSL path to Windows path if it's a file/directory
      if [ -e "$target" ]; then
        target=$(wslpath -w "$target" 2>/dev/null || realpath "$target")
      fi
      explorer.exe "$target"
    }
  fi
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

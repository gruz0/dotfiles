export HISTSIZE="100500"
export HISTCONTROL="ignoredups"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export SUDO_PS1="\w\\$ "
export TERM=screen-256color
export EDITOR=vim
export SVN_EDITOR="vim"
export RBENV_ROOT=/usr/local/var/rbenv
export ENV=development
export RAILS_ENV=development
export DYLD_FORCE_FLAT_NAMESPACE=1

PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/Applications/LibreOffice.app/Contents/MacOS:$PATH"
PATH="/usr/local/Cellar/ctags/5.8_1/bin:$PATH"
export PATH

source ~/.aliases
source ~/.functions

if [ -f $HOME/.env ]; then
    source $HOME/.env
fi

GIT_PROMPT=/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh

if [ -f $GIT_PROMPT ]; then
    source $GIT_PROMPT
    export PS1="\w\$(__git_ps1 '(%s)')\\$ "
else
    export PS1="\w\\$ "
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

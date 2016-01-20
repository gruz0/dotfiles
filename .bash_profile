PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
PATH="/Applications/LibreOffice.app/Contents/MacOS:$PATH"
PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
PATH="$(brew --prefix subversion)/bin:$PATH"
PATH="/usr/local/Cellar/imagemagick/6.8.9-7/bin:$PATH"

source ~/.aliases
source ~/.functions

export PATH
export PS1="\u:\w$ "
export HISTSIZE="100500"
export HISTCONTROL="ignoredups"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export SVN_EDITOR="vim"
export RBENV_ROOT=/usr/local/var/rbenv
export EDITOR=vim

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

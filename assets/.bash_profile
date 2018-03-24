export HISTSIZE="100500"
export HISTCONTROL="ignoredups"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export SUDO_PS1="\w\\$ "
export EDITOR="nvim"
export SVN_EDITOR="nvim"
export RBENV_ROOT="/usr/local/var/rbenv"
export DYLD_FORCE_FLAT_NAMESPACE="1"
export ANSIBLE_HOST_KEY_CHECKING="False"
export OCI_DIR="$(brew --prefix)/lib"
export NLS_LANG="AMERICAN_AMERICA.UTF8"
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export DISABLE_AUTO_TITLE=true
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/.private/keys/gcloud.json

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
export PATH="/usr/local/opt/coreutils/bin:$PATH" # brew --prefix coreutils
export PATH="/usr/local/opt/ctags/bin:$PATH" # brew --prefix ctags
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/Applications/LibreOffice.app/Contents/MacOS:$PATH"

if [ -f $HOME/.aliases ]; then
    source $HOME/.aliases
fi

if [ -f $HOME/.custom ]; then
    source $HOME/.custom
fi

GIT_PROMPT=/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh

if [ -f $GIT_PROMPT ]; then
    source $GIT_PROMPT
    export PS1="\w\$(__git_ps1 '(%s)')\\$ "
else
    export PS1="\w\\$ "
fi

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

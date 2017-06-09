#!/bin/bash

set -e

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

if [[ ! -x /usr/bin/gcc ]]; then
    echo "Installing Command Line Tools..."
    xcode-select --install
fi

if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    sudo chown -R $(whoami) /usr/local/sbin
    sudo chown -R $(whoami) /usr/local/share/man
    brew doctor
    brew update
fi

if [[ ! -x /usr/local/bin/ansible ]]; then
    echo "Installing ansible..."
    easy_install pip
    pip install --user ansible
fi

defaults write NSGlobalDomain ApplePressAndHoldEnabled 0
defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1
defaults write com.apple.desktopservices DSDontWriteNetworkStores 1
defaults write com.apple.TextEdit RichText 0

ansible-playbook playbook.yml

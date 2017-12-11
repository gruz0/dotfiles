#!/bin/bash

set -e

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"

defaults write NSGlobalDomain ApplePressAndHoldEnabled 0
defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1
defaults write com.apple.desktopservices DSDontWriteNetworkStores 1
defaults write com.apple.TextEdit RichText 0

if [[ ! -x /usr/bin/gcc ]]; then
    echo "Installing Command Line Tools..."
    xcode-select --install
fi

if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
    brew doctor
    sudo chown -R $(whoami) /usr/local/sbin
    sudo chown -R $(whoami) /usr/local/share/man
fi

brew install ansible
brew cask install tunnelblick google-cloud-sdk minikube

ansible-playbook playbook.yml

sudo mkdir -p /etc/resolver
echo -e "domain rcntec.com\nnameserver 10.210.146.241\nnameserver 10.210.146.242\nnameserver 10.210.146.243\nnameserver 10.210.146.244" | sudo tee /etc/resolver/rcntec.com

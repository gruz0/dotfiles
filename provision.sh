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

brew install python3
brew cask install tunnelblick google-cloud-sdk minikube wkhtmltopdf virtualbox docker kitematic caskroom/versions/java8

if [[ ! -x /usr/local/bin/ansible ]]; then
    echo "Installing ansible..."
    pip3 install --user ansible
fi

ansible-playbook playbook.yml

sudo mkdir -p /etc/resolver
echo -e "domain rcntec.com\nnameserver 10.210.146.241\nnameserver 10.210.146.242\nnameserver 10.210.146.243\nnameserver 10.210.146.244\n" | sudo tee /etc/resolver/rcntec.com
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4\n" | sudo tee /etc/resolver/go.rcntec.com
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4\n" | sudo tee /etc/resolver/vpn.rcntec.com

#!/bin/bash

set -e

if [[ ! -x /usr/bin/gcc ]]; then
	echo "Installing Command Line Tools..."
	xcode-select --install
fi

tmutil addexclusion ~/Downloads
tmutil addexclusion ~/Music
tmutil addexclusion ~/Movies
tmutil addexclusion ~/Pictures
tmutil addexclusion ~/VirtualBox\ VMs
tmutil addexclusion ~/tmp
tmutil addexclusion ~/.go
tmutil addexclusion ~/go
tmutil addexclusion ~/.vim

find ~/Projects -type d -name tmp -maxdepth 5 -prune -exec tmutil addexclusion {} \; > /dev/null
find ~/Projects -type d -name node_modules -maxdepth 5 -prune -exec tmutil addexclusion {} \; > /dev/null

if [[ ! -x /usr/local/bin/brew ]]; then
	echo "Installing Homebrew..."
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update
brew doctor
brew bundle

if [[ ! -x /usr/local/bin/ansible ]]; then
	echo "Installing ansible..."
	pip3 install --user ansible
fi

ansible-playbook playbook.yml --ask-become-pass

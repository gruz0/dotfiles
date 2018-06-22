#!/bin/bash

set -e

if [[ ! -x /usr/bin/gcc ]]; then
    echo "Installing Command Line Tools..."
    xcode-select --install
fi

if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update
fi

if [[ ! -x /usr/local/bin/ansible ]]; then
    echo "Installing ansible..."
    brew install ansible
fi

ansible-playbook playbook.yml

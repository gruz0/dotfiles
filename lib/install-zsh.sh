#!/usr/bin/env bash
# Install zsh and oh-my-zsh with plugins
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Installing zsh and oh-my-zsh..."

# Check if zsh is installed
if ! command_exists zsh; then
    die "zsh is not installed. Please install it via your package manager first."
fi

# Install oh-my-zsh
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    log_info "oh-my-zsh already installed, updating..."
    git -C "${HOME}/.oh-my-zsh" pull || log_warn "Failed to update oh-my-zsh"
else
    log_info "Installing oh-my-zsh..."
    if command_exists git; then
        # Use git clone instead of the install script to avoid automatic zsh switch
        git clone https://github.com/ohmyzsh/ohmyzsh.git "${HOME}/.oh-my-zsh"
    else
        die "git is required to install oh-my-zsh"
    fi
fi

# Install zsh-autosuggestions plugin
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
if [[ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]]; then
    log_info "zsh-autosuggestions already installed, updating..."
    git -C "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" pull || log_warn "Failed to update zsh-autosuggestions"
else
    log_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi

# Install zsh-docker plugin (if not already present)
if [[ -d "${ZSH_CUSTOM}/plugins/docker" ]]; then
    log_info "docker plugin already installed"
else
    log_info "docker plugin will be provided by oh-my-zsh"
fi

# Add zsh to /etc/shells if not already there
ZSH_PATH="$(command -v zsh)"
if ! grep -q "^${ZSH_PATH}$" /etc/shells 2>/dev/null; then
    log_info "Adding zsh to /etc/shells (requires sudo)..."
    if ask_yes_no "Add zsh to /etc/shells?"; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
    else
        log_warn "Skipping /etc/shells update"
    fi
fi

# Optionally change default shell to zsh
if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    log_info "Current shell: $SHELL"
    if ask_yes_no "Change default shell to zsh? (requires logout to take effect)"; then
        chsh -s "$ZSH_PATH" || log_warn "Failed to change shell. You may need to run: chsh -s $ZSH_PATH"
    fi
fi

log_success "zsh and oh-my-zsh installation complete!"
log_info "Restart your terminal or run: exec zsh"

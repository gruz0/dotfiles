#!/usr/bin/env bash
# Install Homebrew, CLI packages and GUI apps (Apple Silicon Macs)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

if ! command_exists brew && [[ ! -x /opt/homebrew/bin/brew ]]; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    log_success "Homebrew already installed"
fi

# A fresh install is not on PATH yet
eval "$(/opt/homebrew/bin/brew shellenv)"

log_info "Updating Homebrew..."
brew update

log_info "Running brew doctor..."
brew doctor || log_warn "Homebrew doctor found issues (non-fatal)"

log_info "Installing Homebrew formulae..."
while IFS= read -r package; do
    if brew list "$package" &>/dev/null; then
        log_info "Already installed: $package"
    else
        log_info "Installing $package..."
        brew install "$package" || log_warn "Failed to install $package"
    fi
done < <(read_package_list "${DOTFILES_DIR}/packages/macos-brew.txt")

log_info "Installing Homebrew casks..."
while IFS= read -r cask; do
    if brew list --cask "$cask" &>/dev/null; then
        log_info "Already installed: $cask"
    else
        log_info "Installing $cask..."
        brew install --cask "$cask" || log_warn "Failed to install $cask"
    fi
done < <(read_package_list "${DOTFILES_DIR}/packages/macos-casks.txt")

log_success "Homebrew setup complete!"

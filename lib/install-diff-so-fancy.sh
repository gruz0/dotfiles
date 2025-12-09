#!/usr/bin/env bash
# Install diff-so-fancy via npm
# Based on: https://www.npmjs.com/package/diff-so-fancy
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Installing diff-so-fancy..."

# Check if npm is installed
if ! command_exists npm; then
    log_error "npm is not installed"
    log_info "Please install nodejs and npm first:"
    log_info "  sudo apt install nodejs npm"
    die "npm is required to install diff-so-fancy"
fi

# Check if diff-so-fancy is already installed globally
if command_exists diff-so-fancy; then
    DIFF_SO_FANCY_VERSION="$(diff-so-fancy --version 2>/dev/null || echo "unknown")"
    log_info "diff-so-fancy is already installed: $DIFF_SO_FANCY_VERSION"
    if ask_yes_no "Do you want to reinstall/upgrade diff-so-fancy?"; then
        log_info "Proceeding with installation..."
    else
        log_info "Skipping diff-so-fancy installation"
        exit 0
    fi
fi

# Install diff-so-fancy globally via npm
log_info "Installing diff-so-fancy globally via npm..."
npm install -g diff-so-fancy || die "Failed to install diff-so-fancy"

# Verify installation
if command_exists diff-so-fancy; then
    DIFF_SO_FANCY_VERSION="$(diff-so-fancy --version 2>/dev/null || echo "installed")"
    log_success "diff-so-fancy installed successfully: $DIFF_SO_FANCY_VERSION"

    # Show usage information
    log_info ""
    log_info "To use diff-so-fancy with git, configure it:"
    log_info "  git config --global core.pager \"diff-so-fancy | less --tabs=4 -RFX\""
    log_info ""
    log_info "Or set it up as a git diff tool:"
    log_info "  git config --global diff.tool diff-so-fancy"
else
    die "diff-so-fancy installation completed but 'diff-so-fancy' command not found"
fi

log_success "diff-so-fancy installation complete!"


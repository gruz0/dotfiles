#!/usr/bin/env bash
# Install RVM (Ruby Version Manager)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Installing RVM (Ruby Version Manager)..."

# Check for required commands
check_command curl
check_command gpg

# Check if RVM is already installed
if [[ -d "${HOME}/.rvm" ]]; then
    log_info "RVM is already installed"
    # Try to update RVM
    if [[ -f "${HOME}/.rvm/bin/rvm" ]]; then
        log_info "Updating RVM..."
        "${HOME}/.rvm/bin/rvm" get stable || log_warn "Failed to update RVM"
    fi
else
    # Import GPG keys for RVM
    log_info "Importing RVM GPG keys..."
    gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || log_warn "Failed to import some GPG keys (non-fatal)"

    # Install RVM
    log_info "Installing RVM..."
    curl -sSL https://get.rvm.io | bash -s stable

    # Source RVM scripts
    if [[ -f "${HOME}/.rvm/scripts/rvm" ]]; then
        # shellcheck source=/dev/null
        source "${HOME}/.rvm/scripts/rvm"
    fi
fi

log_success "RVM installation complete!"
log_info "To use RVM, restart your terminal or run: source ~/.rvm/scripts/rvm"
log_info "To install a Ruby version, run: rvm install 3.2.0 (or your preferred version)"

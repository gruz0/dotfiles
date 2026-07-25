#!/usr/bin/env bash
# Install Rust toolchain via rustup
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

# Check if rustup is already installed (check early to avoid unnecessary work)
if [[ -x "${HOME}/.cargo/bin/rustup" ]]; then
    log_info "rustup is already installed at ${HOME}/.cargo"
    if ask_yes_no "Do you want to update the Rust toolchain?"; then
        log_info "Updating Rust toolchain..."
        "${HOME}/.cargo/bin/rustup" update || log_warn "Failed to update Rust toolchain"
        log_success "Rust update complete!"
    else
        log_info "Skipping Rust update"
    fi
    exit 0
fi

log_info "Installing Rust (via rustup)..."

# Check for required commands
check_command curl

# Warn about Debian's rustc/cargo packages: rustup installs to ~/.cargo/bin, which
# shadows /usr/bin, so having both means two toolchains and a confusing PATH.
if is_debian && dpkg -l rustc 2>/dev/null | grep -q "^ii"; then
    log_warn "Debian's rustc/cargo packages are installed and will be shadowed by rustup"
    log_warn "Consider removing them: sudo apt-get purge cargo rustc && sudo apt-get autoremove"
fi

# Install rustup with the default profile and stable toolchain, no prompts
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

# Source cargo environment so rustc/cargo are usable in this session
if [[ -f "${HOME}/.cargo/env" ]]; then
    # shellcheck source=/dev/null
    source "${HOME}/.cargo/env"
fi

log_success "Rust installation complete!"
log_info "To use Rust, restart your terminal or run: source ~/.cargo/env"
log_info "Installed: $(rustc --version 2>/dev/null || echo 'run rustc --version after restarting your shell')"

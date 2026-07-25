#!/usr/bin/env bash
# Install Bun (JavaScript runtime and package manager)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

BUN_INSTALL="${HOME}/.bun"

# Check if Bun is already installed (check early to avoid unnecessary work)
if [[ -x "${BUN_INSTALL}/bin/bun" ]]; then
    log_info "Bun is already installed at ${BUN_INSTALL} ($("${BUN_INSTALL}/bin/bun" --version 2>/dev/null))"
    if ask_yes_no "Do you want to upgrade Bun?"; then
        log_info "Upgrading Bun..."
        "${BUN_INSTALL}/bin/bun" upgrade || log_warn "Failed to upgrade Bun"
        log_success "Bun upgrade complete!"
    else
        log_info "Skipping Bun upgrade"
    fi
    exit 0
fi

log_info "Installing Bun..."

# Check for required commands
check_command curl
check_command unzip

# The installer appends PATH and completion lines to shell rc files when it
# recognizes $SHELL. Those lines are managed in assets/.zshrc and
# assets/.bash_profile instead, so hide the shell to opt out. Note the override
# belongs on the piped-to shell, not on curl, or the installer still sees $SHELL.
export BUN_INSTALL
curl -fsSL https://bun.sh/install | SHELL=/bin/false bash

# Opting out above also skips completions, so generate them here. Redirecting
# stdout makes 'bun completions' print the script instead of editing rc files.
log_info "Generating zsh completions..."
SHELL=zsh "${BUN_INSTALL}/bin/bun" completions >"${BUN_INSTALL}/_bun" ||
    log_warn "Failed to generate Bun completions"

log_success "Bun installation complete!"
log_info "To use Bun, restart your terminal or run: export PATH=\"\$HOME/.bun/bin:\$PATH\""

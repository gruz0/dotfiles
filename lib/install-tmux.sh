#!/usr/bin/env bash
# Install tmux plugin manager (TPM) and plugins
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Setting up tmux and TPM..."

# Check if tmux is installed
if ! command_exists tmux; then
    die "tmux is not installed. Please install it via your package manager first."
fi

# Install TPM (Tmux Plugin Manager)
TPM_DIR="${HOME}/.tmux/plugins/tpm"
if [[ -d "$TPM_DIR" ]]; then
    log_info "TPM already installed, updating..."
    git -C "$TPM_DIR" pull || log_warn "Failed to update TPM"
else
    log_info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

log_success "tmux and TPM setup complete!"
log_info "To install tmux plugins, start tmux and press: prefix + I (capital i)"
log_info "Default prefix is Ctrl+b, or check your .tmux.conf for custom prefix"

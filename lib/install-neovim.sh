#!/usr/bin/env bash
# Install NeoVim plugins and setup
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Setting up NeoVim plugins..."

# Check if nvim is installed
if ! command_exists nvim; then
    die "NeoVim is not installed. Please install it via your package manager first."
fi

# Install vim-plug
VIM_PLUG_PATH="${HOME}/.local/share/nvim/site/autoload/plug.vim"
if [[ -f "$VIM_PLUG_PATH" ]]; then
    log_info "vim-plug already installed"
else
    log_info "Installing vim-plug..."
    ensure_dir "$(dirname "$VIM_PLUG_PATH")"
    curl -fLo "$VIM_PLUG_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install NeoVim plugins
log_info "Installing NeoVim plugins (this may take a while)..."
nvim --headless +PlugInstall +qall || log_warn "Some plugins may have failed to install"

# Install CoC extensions if CoC is configured
if nvim --headless +"call coc#util#has_preview()" +qall 2>/dev/null; then
    log_info "Installing CoC extensions..."
    # Note: CoC extensions are usually installed automatically or via init.vim
    log_info "CoC extensions will be installed on first NeoVim start"
fi

log_success "NeoVim setup complete!"
log_info "Open NeoVim and run :checkhealth to verify the installation"

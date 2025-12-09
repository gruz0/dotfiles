#!/usr/bin/env bash
# Debian 12 dotfiles installation script
set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/lib/utils.sh"

# Verify running on Debian
is_debian || die "This script must be run on Debian"

log_info "Starting Debian 12 dotfiles installation..."

# 1. Update package lists
log_info "Updating package lists..."
sudo apt update

# 2. Install packages from package list
log_info "Installing apt packages..."
while IFS= read -r package; do
    # Skip comments and empty lines
    [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && continue
    package="$(echo "$package" | xargs)"
    [[ -z "$package" ]] && continue

    if dpkg -l "$package" 2>/dev/null | grep -q "^ii"; then
        log_info "Already installed: $package"
    else
        log_info "Installing $package..."
        sudo apt install -y "$package" || log_warn "Failed to install $package"
    fi
done < "${SCRIPT_DIR}/packages/debian-apt.txt"

# 3. Run shared installation scripts
log_info "Installing zsh and oh-my-zsh..."
bash "${SCRIPT_DIR}/lib/install-zsh.sh"

log_info "Installing RVM and Ruby..."
bash "${SCRIPT_DIR}/lib/install-ruby.sh"

log_info "Setting up NeoVim..."
bash "${SCRIPT_DIR}/lib/install-neovim.sh"

log_info "Setting up tmux..."
bash "${SCRIPT_DIR}/lib/install-tmux.sh"

log_info "Installing Python tools..."
bash "${SCRIPT_DIR}/lib/install-python-tools.sh"

# 4. WSL-specific configurations
if is_wsl; then
    log_info "Detected WSL environment"
    log_info "Applying WSL-specific configurations..."
    # Add any WSL-specific settings here if needed
fi

# 5. Configure SSH settings (requires sudo)
log_info "SSH configuration..."
if ask_yes_no "Configure system-wide SSH settings? (requires sudo)"; then
    if ! sudo grep -q "^Host \*" /etc/ssh/ssh_config 2>/dev/null; then
        echo "Host *" | sudo tee -a /etc/ssh/ssh_config >/dev/null
    fi
    if ! sudo grep -q "Ciphers aes128-ctr" /etc/ssh/ssh_config 2>/dev/null; then
        echo "    Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc" | sudo tee -a /etc/ssh/ssh_config >/dev/null
    fi
    log_success "SSH settings configured"
else
    log_info "Skipping SSH configuration"
fi

# 6. Deploy configuration files
log_info "Deploying configuration files..."
bash "${SCRIPT_DIR}/lib/deploy-configs.sh"

# 7. Verify installation
log_info "Verifying installation..."
bash "${SCRIPT_DIR}/lib/verify-installation.sh" || log_warn "Some verification checks failed"

echo ""
echo "======================================"
log_success "Debian 12 dotfiles installation complete!"
echo "======================================"
log_info "Please restart your terminal or run: exec zsh"
log_info ""
log_info "Next steps:"
log_info "  - Review any warnings or errors above"
log_info "  - Open NeoVim and run :checkhealth"
log_info "  - Start tmux and press prefix + I to install plugins"
log_info "  - To install a Ruby version: rvm install 3.2.0"

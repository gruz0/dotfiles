#!/usr/bin/env bash
# macOS dotfiles installation script
set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/lib/utils.sh"

# Verify running on macOS
is_macos || die "This script must be run on macOS"

log_info "Starting macOS dotfiles installation..."

# 1. Install Command Line Tools
log_info "Checking for Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    log_info "Installing Command Line Tools..."
    xcode-select --install
    log_info "Waiting for Command Line Tools installation to complete..."
    log_info "Please complete the installation and press Enter to continue..."
    read -r
else
    log_success "Command Line Tools already installed"
fi

# 2. Configure Time Machine exclusions
log_info "Configuring Time Machine exclusions..."
tmutil addexclusion ~/Downloads 2>/dev/null || true
tmutil addexclusion ~/Music 2>/dev/null || true
tmutil addexclusion ~/Movies 2>/dev/null || true
tmutil addexclusion ~/Pictures 2>/dev/null || true

# Exclude common development directories
if [[ -d ~/Projects ]]; then
    find ~/Projects -type d -name tmp -maxdepth 5 -prune -exec tmutil addexclusion {} \; 2>/dev/null || true
    find ~/Projects -type d -name node_modules -maxdepth 5 -prune -exec tmutil addexclusion {} \; 2>/dev/null || true
fi

log_success "Time Machine exclusions configured"

# 3. Install Homebrew
if ! command_exists brew; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    log_success "Homebrew already installed"
fi

log_info "Updating Homebrew..."
brew update

log_info "Running brew doctor..."
brew doctor || log_warn "Homebrew doctor found issues (non-fatal)"

# 4. Install packages from package lists
log_info "Installing Homebrew formulae..."
while IFS= read -r package; do
    # Skip comments and empty lines
    [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && continue
    package="$(echo "$package" | xargs)"
    [[ -z "$package" ]] && continue

    if brew list "$package" &>/dev/null; then
        log_info "Already installed: $package"
    else
        log_info "Installing $package..."
        brew install "$package" || log_warn "Failed to install $package"
    fi
done < "${SCRIPT_DIR}/packages/macos-brew.txt"

log_info "Installing Homebrew casks..."
while IFS= read -r cask; do
    # Skip comments and empty lines
    [[ -z "$cask" || "$cask" =~ ^[[:space:]]*# ]] && continue
    cask="$(echo "$cask" | xargs)"
    [[ -z "$cask" ]] && continue

    if brew list --cask "$cask" &>/dev/null; then
        log_info "Already installed: $cask"
    else
        log_info "Installing $cask..."
        brew install --cask "$cask" || log_warn "Failed to install $cask"
    fi
done < "${SCRIPT_DIR}/packages/macos-casks.txt"

# 5. Run shared installation scripts
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

# 6. Apply macOS system settings
log_info "Applying macOS system settings..."

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show Finder quit option
defaults write com.apple.finder QuitMenuItem -bool true

# Use list view in Finder by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Dock settings
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide-delay -float 0

# Bottom right corner → Start screen saver
defaults write com.apple.dock wvous-br-corner -int 5
defaults write com.apple.dock wvous-br-modifier -int 0

# Menubar battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Disable network disk metadata
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Dark menu bar and dock
defaults write -g NSRequiresAquaSystemAppearance -bool false

log_success "macOS system settings applied"

log_info "Restarting affected applications..."
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true

# 7. Configure SSH settings (requires sudo)
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

# 8. Deploy configuration files
log_info "Deploying configuration files..."
bash "${SCRIPT_DIR}/lib/deploy-configs.sh"

# 9. Verify installation
log_info "Verifying installation..."
bash "${SCRIPT_DIR}/lib/verify-installation.sh" || log_warn "Some verification checks failed"

echo ""
echo "======================================"
log_success "macOS dotfiles installation complete!"
echo "======================================"
log_info "Please restart your terminal or run: exec zsh"
log_info ""
log_info "Next steps:"
log_info "  - Review any warnings or errors above"
log_info "  - Open NeoVim and run :checkhealth"
log_info "  - Start tmux and press prefix + I to install plugins"
log_info "  - To install a Ruby version: rvm install 3.2.0"

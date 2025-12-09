#!/usr/bin/env bash
# Install Python packages via pip
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Installing Python packages..."

# Check if python3 and pip3 are installed
if ! command_exists python3; then
    die "python3 is not installed. Please install it via your package manager first."
fi

if ! command_exists pip3; then
    die "pip3 is not installed. Please install python3-pip via your package manager first."
fi

# Python packages to install
PACKAGES=(
    "neovim"
    "ansible-vault"
)

# Install packages
for package in "${PACKAGES[@]}"; do
    log_info "Installing $package..."
    pip3 install --user "$package" || log_warn "Failed to install $package"
done

log_success "Python packages installation complete!"
log_info "Installed packages: ${PACKAGES[*]}"

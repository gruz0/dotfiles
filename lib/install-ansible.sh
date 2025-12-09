#!/usr/bin/env bash
# Install Ansible on Debian 12 via Ubuntu PPA
# Based on: https://docs.ansible.com/projects/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-debian
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Installing Ansible..."

# Check if running on Debian
if ! is_debian; then
    die "This script is designed for Debian systems"
fi

# Check if Ansible is already installed
if command_exists ansible; then
    ANSIBLE_VERSION="$(ansible --version | head -n 1)"
    log_info "Ansible is already installed: $ANSIBLE_VERSION"
    if ask_yes_no "Do you want to reinstall/upgrade Ansible?"; then
        log_info "Proceeding with installation..."
    else
        log_info "Skipping Ansible installation"
        exit 0
    fi
fi

# Determine Debian version and map to Ubuntu codename
DEBIAN_VERSION=""
if [[ -f /etc/os-release ]]; then
    # Try to get Debian version from /etc/os-release
    DEBIAN_VERSION="$(grep "^VERSION_ID=" /etc/os-release | cut -d'"' -f2 | cut -d'.' -f1 || echo "")"
fi

# Map Debian version to Ubuntu codename
# Debian 12 (Bookworm) -> Ubuntu 22.04 (Jammy)
# Debian 11 (Bullseye) -> Ubuntu 20.04 (Focal)
# Debian 10 (Buster) -> Ubuntu 18.04 (Bionic)
case "$DEBIAN_VERSION" in
    12)
        UBUNTU_CODENAME="jammy"
        log_info "Detected Debian 12 (Bookworm), using Ubuntu 22.04 (Jammy) PPA"
        ;;
    11)
        UBUNTU_CODENAME="focal"
        log_info "Detected Debian 11 (Bullseye), using Ubuntu 20.04 (Focal) PPA"
        ;;
    10)
        UBUNTU_CODENAME="bionic"
        log_info "Detected Debian 10 (Buster), using Ubuntu 18.04 (Bionic) PPA"
        ;;
    *)
        log_warn "Unable to detect Debian version, defaulting to Jammy (Ubuntu 22.04)"
        UBUNTU_CODENAME="jammy"
        ;;
esac

# Check for required commands
check_command wget
check_command gpg

# Ansible PPA signing key fingerprint
ANSIBLE_KEY_FINGERPRINT="6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367"
ANSIBLE_KEYRING="/usr/share/keyrings/ansible-archive-keyring.gpg"
ANSIBLE_SOURCES_LIST="/etc/apt/sources.list.d/ansible.list"

# Download and add the signing key
log_info "Downloading Ansible PPA signing key..."
if [[ -f "$ANSIBLE_KEYRING" ]]; then
    log_info "Ansible keyring already exists, skipping download"
else
    wget -O- "https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0x${ANSIBLE_KEY_FINGERPRINT}" | \
        sudo gpg --dearmour -o "$ANSIBLE_KEYRING" || \
        die "Failed to download and add Ansible signing key"
    log_success "Ansible signing key added"
fi

# Add the PPA repository
log_info "Adding Ansible PPA repository..."
if [[ -f "$ANSIBLE_SOURCES_LIST" ]]; then
    log_info "Ansible repository already configured"
else
    echo "deb [signed-by=${ANSIBLE_KEYRING}] http://ppa.launchpad.net/ansible/ansible/ubuntu ${UBUNTU_CODENAME} main" | \
        sudo tee "$ANSIBLE_SOURCES_LIST" > /dev/null || \
        die "Failed to add Ansible repository"
    log_success "Ansible repository added"
fi

# Update package lists
log_info "Updating package lists..."
sudo apt update || die "Failed to update package lists"

# Install Ansible
log_info "Installing Ansible..."
sudo apt install -y ansible || die "Failed to install Ansible"

# Verify installation
if command_exists ansible; then
    ANSIBLE_VERSION="$(ansible --version | head -n 1)"
    log_success "Ansible installed successfully: $ANSIBLE_VERSION"
else
    die "Ansible installation completed but 'ansible' command not found"
fi

log_success "Ansible installation complete!"

#!/usr/bin/env bash
# Install MacPorts and CLI packages (Intel Macs, which Homebrew no longer supports)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

# Keep in sync with packages/macos-ports.txt
PYTHON_PORT="python313"
PIP_PORT="pip313"

export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# Download and run the MacPorts installer that matches this macOS version
install_macports() {
    local os_version download_url tmp_dir

    # Installer names use "15" for Sequoia but "10.15" for Catalina and older
    os_version="$(sw_vers -productVersion | cut -d. -f1)"
    if [[ "$os_version" == "10" ]]; then
        os_version="$(sw_vers -productVersion | cut -d. -f1-2)"
    fi

    log_info "Looking up the latest MacPorts installer for macOS ${os_version}..."
    download_url="$(curl -fsSL https://api.github.com/repos/macports/macports-base/releases/latest \
        | grep -oE "https://[^\"]+/MacPorts-[0-9.]+-${os_version}-[A-Za-z]+\.pkg" \
        | head -n 1)" || true

    if [[ -z "$download_url" ]]; then
        die "No MacPorts installer found for macOS ${os_version}. Install it manually: https://www.macports.org/install.php"
    fi

    tmp_dir="$(mktemp -d)"
    log_info "Downloading ${download_url##*/}..."
    curl -fL --progress-bar -o "${tmp_dir}/MacPorts.pkg" "$download_url"

    log_info "Running the MacPorts installer (requires sudo)..."
    sudo installer -pkg "${tmp_dir}/MacPorts.pkg" -target /
    rm -rf "$tmp_dir"
}

if command_exists port; then
    log_success "MacPorts already installed"
else
    install_macports
fi

log_info "Updating MacPorts..."
sudo port -N selfupdate || log_warn "MacPorts selfupdate failed (non-fatal)"

log_info "Installing MacPorts packages..."
while IFS= read -r package; do
    if [[ "$(port installed "$package" 2>/dev/null)" == *"(active)"* ]]; then
        log_info "Already installed: $package"
    else
        log_info "Installing $package..."
        sudo port -N install "$package" || log_warn "Failed to install $package"
    fi
done < <(read_package_list "${DOTFILES_DIR}/packages/macos-ports.txt")

# MacPorts installs python3.13 and pip3.13 only; make python3 and pip3 point to them
log_info "Setting ${PYTHON_PORT} as the default python3..."
sudo port select --set python3 "$PYTHON_PORT" || log_warn "Failed to select python3"
sudo port select --set pip3 "$PIP_PORT" || log_warn "Failed to select pip3"

# MacPorts has no equivalent of Homebrew casks
log_warn "GUI apps and fonts are not installed on Intel Macs. Download them manually:"
while IFS= read -r app; do
    log_warn "  - ${app}"
done < <(read_package_list "${DOTFILES_DIR}/packages/macos-casks.txt")

log_success "MacPorts setup complete!"

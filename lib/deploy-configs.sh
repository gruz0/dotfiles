#!/usr/bin/env bash
# Deploy configuration files by symlinking from assets/ to $HOME
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
ASSETS_DIR="${DOTFILES_DIR}/assets"
SYMLINKS_FILE="${DOTFILES_DIR}/config/symlinks.txt"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Deploying configuration files..."

# Verify assets directory exists
[[ -d "$ASSETS_DIR" ]] || die "Assets directory not found: $ASSETS_DIR"

# Verify symlinks file exists
[[ -f "$SYMLINKS_FILE" ]] || die "Symlinks file not found: $SYMLINKS_FILE"

# Read symlinks file
while IFS= read -r rel_path; do
    # Skip comments and empty lines
    [[ -z "$rel_path" || "$rel_path" =~ ^[[:space:]]*# ]] && continue

    # Trim whitespace
    rel_path="$(echo "$rel_path" | xargs)"
    [[ -z "$rel_path" ]] && continue

    src="${ASSETS_DIR}/${rel_path}"
    dest="${HOME}/${rel_path}"

    # Verify source exists
    if [[ ! -e "$src" ]]; then
        log_warn "Source not found, skipping: $src"
        continue
    fi

    # Create parent directory if needed
    dest_dir="$(dirname "$dest")"
    ensure_dir "$dest_dir"

    # Check if symlink already points to correct target
    if symlink_correct "$dest" "$src"; then
        log_info "Already linked: $rel_path"
        continue
    fi

    # Backup existing file/directory
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        backup_file "$dest"
    elif [[ -L "$dest" ]]; then
        log_info "Removing existing symlink: $dest"
        rm "$dest"
    fi

    # Create symlink
    log_info "Linking: $rel_path"
    ln -sf "$src" "$dest"

done < "$SYMLINKS_FILE"

# Special handling for .ssh directory permissions
if [[ -d "${HOME}/.ssh" ]]; then
    log_info "Setting SSH directory permissions..."
    chmod 700 "${HOME}/.ssh"

    # Set permissions for private keys
    find "${HOME}/.ssh" -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \; 2>/dev/null || true

    # Set permissions for public keys
    find "${HOME}/.ssh" -type f -name "*.pub" -exec chmod 644 {} \; 2>/dev/null || true

    # Set permissions for config file
    if [[ -f "${HOME}/.ssh/config" ]]; then
        chmod 600 "${HOME}/.ssh/config"
    fi

    # Set permissions for known_hosts
    if [[ -f "${HOME}/.ssh/known_hosts" ]]; then
        chmod 644 "${HOME}/.ssh/known_hosts"
    fi
fi

log_success "Configuration deployment complete!"

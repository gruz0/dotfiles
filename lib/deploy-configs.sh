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

    # Set SSH directory permissions on source before symlinking (if it's .ssh)
    if [[ "$rel_path" == ".ssh" && -d "$src" ]]; then
        chmod 700 "$src" 2>/dev/null || true
        find "$src" -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \; 2>/dev/null || true
        find "$src" -type f -name "*.pub" -exec chmod 644 {} \; 2>/dev/null || true
        [[ -f "$src/config" ]] && chmod 600 "$src/config" 2>/dev/null || true
        [[ -f "$src/known_hosts" ]] && chmod 644 "$src/known_hosts" 2>/dev/null || true
    fi

    # Check if symlink already points to correct target
    if symlink_correct "$dest" "$src"; then
        log_info "Already linked: $rel_path"
        continue
    fi

    # Check if destination already exists as a non-symlink file/directory
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        die "Destination already exists and is not a symlink: $dest\nPlease manually manage this file first (move it to the repository or remove it), then run the deployment again."
    elif [[ -L "$dest" ]]; then
        log_info "Removing existing symlink: $dest"
        rm "$dest"
    fi

    # Create symlink
    log_info "Linking: $rel_path"
    ln -sf "$src" "$dest"

done < "$SYMLINKS_FILE"

# Special handling for .ssh directory permissions
# Note: chmod follows symlinks by default, so this works whether .ssh is a symlink or not
if [[ -e "${HOME}/.ssh" ]]; then
    log_info "Setting SSH directory permissions..."

    # Get the actual directory path (resolve symlink if needed)
    SSH_TARGET="${HOME}/.ssh"
    if [[ -L "${HOME}/.ssh" ]]; then
        # Resolve symlink to actual target directory
        SSH_TARGET=$(cd -P "${HOME}/.ssh" 2>/dev/null && pwd) || SSH_TARGET="${HOME}/.ssh"
    fi

    # Set permissions on the actual directory
    if [[ -d "$SSH_TARGET" ]]; then
        chmod 700 "$SSH_TARGET" || log_warn "Failed to set permissions on $SSH_TARGET"

        # Set permissions for private keys
        find "$SSH_TARGET" -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \; 2>/dev/null || true

        # Set permissions for public keys
        find "$SSH_TARGET" -type f -name "*.pub" -exec chmod 644 {} \; 2>/dev/null || true

        # Set permissions for config file
        if [[ -f "$SSH_TARGET/config" ]]; then
            chmod 600 "$SSH_TARGET/config"
        fi

        # Set permissions for known_hosts
        if [[ -f "$SSH_TARGET/known_hosts" ]]; then
            chmod 644 "$SSH_TARGET/known_hosts"
        fi
    fi

    # Also set permissions on source directory in assets (if it exists)
    # This ensures the source has correct permissions before symlinking
    SSH_SRC="${ASSETS_DIR}/.ssh"
    if [[ -d "$SSH_SRC" ]]; then
        chmod 700 "$SSH_SRC" || log_warn "Failed to set permissions on $SSH_SRC"
        find "$SSH_SRC" -type f -name "id_*" ! -name "*.pub" -exec chmod 600 {} \; 2>/dev/null || true
        find "$SSH_SRC" -type f -name "*.pub" -exec chmod 644 {} \; 2>/dev/null || true
        [[ -f "$SSH_SRC/config" ]] && chmod 600 "$SSH_SRC/config"
        [[ -f "$SSH_SRC/known_hosts" ]] && chmod 644 "$SSH_SRC/known_hosts"
    fi
fi

log_success "Configuration deployment complete!"

#!/usr/bin/env bash
# Install NeoVim plugins and setup
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Setting up NeoVim..."

NVIM_VERSION="0.10.4"

# Install NeoVim on Debian from GitHub release (Debian 12 has outdated version)
# Check if we need to install/upgrade NeoVim on Debian
INSTALL_NVIM=false
if is_debian; then
    if ! command_exists nvim; then
        INSTALL_NVIM=true
        log_info "Detected Debian - NeoVim not found, installing NeoVim 0.11.5 from GitHub release..."
    else
        # Check if installed version is too old (Debian 12 has 0.7.2)
        # Extract version number (e.g., "NVIM v0.7.2" -> "0.7.2")
        NVIM_VERSION_CURRENT="$(nvim --version 2>/dev/null | head -n 1 | sed -n 's/.*v\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p' || echo '')"
        if [[ -n "$NVIM_VERSION_CURRENT" ]]; then
            # Compare version numbers (simple numeric comparison for major.minor)
            MAJOR_CURRENT="$(echo "$NVIM_VERSION_CURRENT" | cut -d. -f1)"
            MINOR_CURRENT="$(echo "$NVIM_VERSION_CURRENT" | cut -d. -f2)"
            if [[ "$MAJOR_CURRENT" -lt 0 ]] || [[ "$MAJOR_CURRENT" -eq 0 && "$MINOR_CURRENT" -lt 11 ]]; then
                INSTALL_NVIM=true
                log_info "Detected Debian - current NeoVim version ($NVIM_VERSION_CURRENT) is outdated, upgrading to 0.11.5..."
            fi
        else
            # If we can't determine version, assume it needs upgrading
            INSTALL_NVIM=true
            log_info "Detected Debian - unable to determine NeoVim version, installing 0.11.5..."
        fi
    fi
fi

if [[ "$INSTALL_NVIM" == "true" ]]; then
    # Detect architecture
    ARCH="$(uname -m)"
    if [[ "$ARCH" == "x86_64" ]]; then
        NVIM_ARCH="x86_64"
    elif [[ "$ARCH" == "aarch64" ]] || [[ "$ARCH" == "arm64" ]]; then
        NVIM_ARCH="arm64"
    else
        die "Unsupported architecture: $ARCH"
    fi

    NVIM_TARBALL="nvim-linux-${NVIM_ARCH}.tar.gz"
    NVIM_URL="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${NVIM_TARBALL}"
    INSTALL_DIR="${HOME}/.local"
    NVIM_BIN_DIR="${INSTALL_DIR}/bin"
    TEMP_DIR="$(mktemp -d)"
    EXTRACTED_DIR="nvim-linux-${NVIM_ARCH}"

    # Ensure install directory exists
    ensure_dir "$NVIM_BIN_DIR"

    # Download and extract NeoVim
    log_info "Downloading NeoVim ${NVIM_VERSION}..."
    cd "$TEMP_DIR"
    curl -fL -o "$NVIM_TARBALL" "$NVIM_URL" || die "Failed to download NeoVim"

    log_info "Extracting NeoVim..."
    tar xzf "$NVIM_TARBALL" || die "Failed to extract NeoVim"

    # Check tarball structure
    if [[ ! -d "$EXTRACTED_DIR" ]]; then
        die "Unexpected tarball structure - $EXTRACTED_DIR not found"
    fi

    # Copy nvim binary to ~/.local/bin
    log_info "Installing NeoVim binary to ${NVIM_BIN_DIR}..."
    if [[ ! -f "$EXTRACTED_DIR/bin/nvim" ]]; then
        die "nvim binary not found in tarball"
    fi
    cp -f "$EXTRACTED_DIR/bin/nvim" "$NVIM_BIN_DIR/nvim" || die "Failed to copy nvim binary"
    chmod +x "$NVIM_BIN_DIR/nvim"

    # Copy runtime files - NeoVim needs its runtime files (syntax, lua modules, etc.)
    # The tarball contains share/nvim/runtime/ directory
    # We'll install to ~/.local/share/nvim/runtime and set VIMRUNTIME if needed
    if [[ -d "$EXTRACTED_DIR/share/nvim/runtime" ]]; then
        NVIM_RUNTIME_DIR="${INSTALL_DIR}/share/nvim/runtime"
        log_info "Installing NeoVim runtime files to ${NVIM_RUNTIME_DIR}..."
        ensure_dir "$NVIM_RUNTIME_DIR"
        cp -r "$EXTRACTED_DIR/share/nvim/runtime/"* "$NVIM_RUNTIME_DIR/" || die "Failed to copy runtime files"

        # Set VIMRUNTIME environment variable so NeoVim can find its runtime files
        # This will be exported for the current session and added to shell config
        export VIMRUNTIME="$NVIM_RUNTIME_DIR"
        log_info "Set VIMRUNTIME=${VIMRUNTIME}"
    else
        log_warn "Runtime directory not found in expected location, checking alternative structure..."
        # List what's actually in the tarball for debugging
        log_info "Tarball contents:"
        find "$EXTRACTED_DIR" -type d -name "runtime" -o -name "nvim" | head -10
        if [[ -d "$EXTRACTED_DIR/share/nvim" ]]; then
            # Try copying the entire share/nvim directory
            NVIM_SHARE_DIR="${INSTALL_DIR}/share/nvim"
            log_info "Copying entire share/nvim directory to ${NVIM_SHARE_DIR}..."
            ensure_dir "$NVIM_SHARE_DIR"
            cp -r "$EXTRACTED_DIR/share/nvim/"* "$NVIM_SHARE_DIR/" || die "Failed to copy nvim share files"
            export VIMRUNTIME="${NVIM_SHARE_DIR}/runtime"
        fi
    fi

    # Copy lib directory if it exists (may contain shared libraries)
    if [[ -d "$EXTRACTED_DIR/lib" ]]; then
        NVIM_LIB_DIR="${INSTALL_DIR}/lib/nvim"
        log_info "Installing NeoVim libraries to ${NVIM_LIB_DIR}..."
        ensure_dir "$NVIM_LIB_DIR"
        cp -r "$EXTRACTED_DIR/lib/"* "$NVIM_LIB_DIR/" 2>/dev/null || log_warn "Some library files may have failed to copy"
    fi

    # Cleanup
    cd - > /dev/null
    rm -rf "$TEMP_DIR"

    # Verify installation
    if [[ -x "$NVIM_BIN_DIR/nvim" ]]; then
        NVIM_VERSION_INSTALLED="$("$NVIM_BIN_DIR/nvim" --version | head -n 1)"
        log_success "NeoVim installed: $NVIM_VERSION_INSTALLED"

        # Check if ~/.local/bin is in PATH
        if [[ ":$PATH:" != *":${NVIM_BIN_DIR}:"* ]]; then
            log_warn "${NVIM_BIN_DIR} is not in PATH. Adding it temporarily for this session..."
            export PATH="${NVIM_BIN_DIR}:${PATH}"
            log_info "To make this permanent, add to your shell config:"
            log_info "  export PATH=\"\${HOME}/.local/bin:\${PATH}\""
        fi

        # Add VIMRUNTIME to shell config if it's set
        if [[ -n "${VIMRUNTIME:-}" ]]; then
            log_info "To make VIMRUNTIME permanent, add to your shell config:"
            log_info "  export VIMRUNTIME=\"\${HOME}/.local/share/nvim/runtime\""
        fi
    else
        die "Failed to install NeoVim binary"
    fi
elif ! command_exists nvim; then
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

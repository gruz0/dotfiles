#!/usr/bin/env bash
# Verify dotfiles installation
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
ASSETS_DIR="${DOTFILES_DIR}/assets"

# Source utilities
# shellcheck source=lib/utils.sh
source "${SCRIPT_DIR}/utils.sh"

log_info "Verifying installation..."

FAILED=0

# Check essential commands
COMMANDS=(
    "zsh"
    "nvim"
    "tmux"
    "git"
)

log_info "Checking essential commands..."
for cmd in "${COMMANDS[@]}"; do
    if command_exists "$cmd"; then
        log_success "✓ $cmd is installed"
    else
        log_error "✗ $cmd is NOT installed"
        ((FAILED++))
    fi
done

# Check oh-my-zsh
log_info "Checking oh-my-zsh..."
if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    log_success "✓ oh-my-zsh is installed"
else
    log_error "✗ oh-my-zsh is NOT installed"
    ((FAILED++))
fi

# Check RVM
log_info "Checking RVM..."
if [[ -d "${HOME}/.rvm" ]]; then
    log_success "✓ RVM is installed"
else
    log_warn "✗ RVM is NOT installed (optional)"
fi

# Check TPM
log_info "Checking TPM..."
if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
    log_success "✓ TPM is installed"
else
    log_warn "✗ TPM is NOT installed (optional)"
fi

# Check critical symlinks
log_info "Checking critical symlinks..."
CRITICAL_SYMLINKS=(
    ".zshrc"
    ".tmux.conf"
    ".gitconfig"
    ".config/nvim/init.vim"
)

for symlink in "${CRITICAL_SYMLINKS[@]}"; do
    if [[ -L "${HOME}/${symlink}" ]]; then
        log_success "✓ ${symlink} is symlinked"
    else
        log_error "✗ ${symlink} is NOT symlinked"
        ((FAILED++))
    fi
done

# Check SSH permissions
log_info "Checking SSH permissions..."
if [[ -d "${HOME}/.ssh" ]]; then
    SSH_PERMS=$(stat -f "%Lp" "${HOME}/.ssh" 2>/dev/null || stat -c "%a" "${HOME}/.ssh" 2>/dev/null || echo "unknown")
    if [[ "$SSH_PERMS" == "700" ]]; then
        log_success "✓ SSH directory permissions correct (700)"
    else
        log_warn "✗ SSH directory permissions: $SSH_PERMS (should be 700)"
    fi
else
    log_warn "✗ SSH directory does not exist"
fi

# Summary
echo ""
echo "======================================"
if [[ $FAILED -eq 0 ]]; then
    log_success "Verification complete! All critical checks passed."
    echo "======================================"
    exit 0
else
    log_error "Verification found $FAILED issue(s)."
    echo "======================================"
    exit 1
fi

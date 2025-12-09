#!/usr/bin/env bash
# Test script for Debian 12 installation
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "Testing Debian 12 installation scripts..."
echo ""

FAILED=0

# Test 1: Verify script files exist and are executable
echo "Test 1: Checking script files..."
if [[ -x "${DOTFILES_DIR}/install-debian12.sh" ]]; then
    echo "✓ install-debian12.sh is executable"
else
    echo "✗ install-debian12.sh is not executable"
    ((FAILED++))
fi

# Test 2: Verify all lib scripts exist
echo ""
echo "Test 2: Checking lib scripts..."
for script in utils install-zsh install-ruby install-neovim install-tmux install-python-tools deploy-configs verify-installation; do
    if [[ -f "${DOTFILES_DIR}/lib/${script}.sh" ]]; then
        echo "✓ lib/${script}.sh exists"
    else
        echo "✗ lib/${script}.sh not found"
        ((FAILED++))
    fi
done

# Test 3: Verify package files exist
echo ""
echo "Test 3: Checking package files..."
if [[ -f "${DOTFILES_DIR}/packages/debian-apt.txt" ]]; then
    echo "✓ packages/debian-apt.txt exists"
else
    echo "✗ packages/debian-apt.txt not found"
    ((FAILED++))
fi

# Test 4: Verify symlinks file exists
echo ""
echo "Test 4: Checking symlinks file..."
if [[ -f "${DOTFILES_DIR}/config/symlinks.txt" ]]; then
    echo "✓ config/symlinks.txt exists"
else
    echo "✗ config/symlinks.txt not found"
    ((FAILED++))
fi

# Test 5: Shellcheck on all scripts (if available)
echo ""
echo "Test 5: Running shellcheck (if available)..."
if command -v shellcheck &>/dev/null; then
    find "$DOTFILES_DIR" -name "*.sh" -type f -exec shellcheck {} \; && echo "✓ All scripts passed shellcheck" || {
        echo "✗ Some scripts failed shellcheck"
        ((FAILED++))
    }
else
    echo "⊘ shellcheck not installed, skipping"
fi

# Test 6: Syntax check all scripts
echo ""
echo "Test 6: Syntax checking bash scripts..."
SYNTAX_FAILED=0
find "$DOTFILES_DIR" -name "*.sh" -type f | while read -r script; do
    if bash -n "$script" 2>/dev/null; then
        echo "✓ $(basename "$script") syntax OK"
    else
        echo "✗ $(basename "$script") syntax error"
        SYNTAX_FAILED=$((SYNTAX_FAILED + 1))
    fi
done

if [[ $SYNTAX_FAILED -gt 0 ]]; then
    ((FAILED++))
fi

# Test 7: Verify assets directory
echo ""
echo "Test 7: Checking assets directory..."
if [[ -d "${DOTFILES_DIR}/assets" ]]; then
    echo "✓ assets directory exists"
else
    echo "✗ assets directory not found"
    ((FAILED++))
fi

# Summary
echo ""
echo "======================================"
if [[ $FAILED -eq 0 ]]; then
    echo "✓ All tests passed!"
    echo "======================================"
    exit 0
else
    echo "✗ $FAILED test(s) failed"
    echo "======================================"
    exit 1
fi

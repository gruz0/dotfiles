#!/usr/bin/env bash
# Utility functions for dotfiles installation scripts
# This file is sourced by other scripts and provides common functionality

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Exit with error message
die() {
    log_error "$*"
    exit 1
}

# Check if command exists
check_command() {
    local cmd="$1"
    if ! command -v "$cmd" &>/dev/null; then
        die "Required command not found: $cmd"
    fi
}

# Check if command exists (returns 0 if exists, 1 if not)
command_exists() {
    command -v "$1" &>/dev/null
}

# OS detection functions
is_macos() {
    [[ "$OSTYPE" == "darwin"* ]]
}

is_debian() {
    [[ -f /etc/debian_version ]]
}

is_wsl() {
    [[ -f /proc/version ]] && grep -qi microsoft /proc/version
}

# File operations
backup_file() {
    local file="$1"
    if [[ -e "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up: $file -> $backup"
        mv "$file" "$backup"
    fi
}

ensure_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        log_info "Creating directory: $dir"
        mkdir -p "$dir"
    fi
}

# User interaction
ask_yes_no() {
    local prompt="$1"
    local response
    while true; do
        read -rp "$prompt [y/N] " response
        case "$response" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            "" ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Check if a symlink points to the expected target
symlink_correct() {
    local link="$1"
    local target="$2"
    [[ -L "$link" ]] && [[ "$(readlink "$link")" == "$target" ]]
}

# Get dotfiles directory (parent of lib directory)
get_dotfiles_dir() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    dirname "$script_dir"
}

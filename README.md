# Dotfiles

Personal dotfiles for macOS and Debian 12 (WSL2) development environments.

## Features

- **Shell:** zsh with oh-my-zsh and plugins (autosuggestions, docker)
- **Editor:** NeoVim with vim-plug and CoC LSP
- **Terminal Multiplexer:** tmux with TPM
- **Version Managers:** RVM (Ruby)
- **Languages:** Ruby, Go, Node.js, Python, Deno
- **Development Tools:** Git, Docker, various CLI utilities

## Supported Platforms

- **macOS** (tested on Monterey, Ventura, Sonoma)
- **Debian 12** (WSL2 and native)

## Quick Start

### macOS Installation

```bash
# Clone the repository
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/gruz0/dotfiles.git
cd dotfiles

# Run installation
./install-macos.sh
```

The script will:
- Install Command Line Tools (if needed)
- Install/update Homebrew
- Install all packages and GUI applications
- Set up oh-my-zsh, RVM, NeoVim, and tmux
- Apply macOS system settings
- Symlink configuration files

### Debian 12 (WSL2) Installation

```bash
# Clone the repository
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/gruz0/dotfiles.git
cd dotfiles

# Run installation
./install-debian12.sh
```

The script will:
- Update apt repositories
- Install all CLI development tools
- Set up oh-my-zsh, RVM, NeoVim, and tmux
- Symlink configuration files

## What Gets Installed

### macOS

#### CLI Tools (via Homebrew)

**Languages:**
- Go, Node.js, Python, Deno

**Version Control:**
- Git, Subversion

**Editors & Tools:**
- NeoVim, tmux, zsh

**Development:**
- cmake, automake, pkg-config, shellcheck, hadolint, composer

**Utilities:**
- bat, jq, tree, wget, curl, diff-so-fancy, the_silver_searcher

#### GUI Applications (via Homebrew Casks)

**Browsers:**
- Chrome, Firefox, Brave, Edge, Opera

**Development:**
- Docker, iTerm2, DBeaver

**Productivity:**
- 1Password, Telegram, Zoom, TeamViewer

**Media:**
- OBS, Camtasia

**Utilities:**
- CleanMyMac, LibreOffice, The Unarchiver, Fira Code font

#### System Settings

- Faster key repeat, no press-and-hold
- Dock on left, auto-hide enabled
- Show hidden files in Finder
- List view as default in Finder
- Time Machine exclusions for Downloads, Music, Movies, Pictures, and development directories

### Debian 12 (WSL2)

#### Packages (via apt)

**Languages:**
- Go, Node.js, Python, Deno

**Version Control:**
- Git, Subversion

**Editors & Tools:**
- NeoVim, tmux, zsh

**Development:**
- cmake, automake, pkg-config, shellcheck, build-essential, composer

**Utilities:**
- bat, jq, tree, wget, curl, diff-so-fancy, silversearcher-ag

Note: GUI applications are not installed on Debian as it's designed for headless/WSL2 environments.

### Shared Installations (Both Platforms)

- **oh-my-zsh** with custom gruz0 theme and plugins
- **RVM** (Ruby Version Manager)
- **vim-plug** and NeoVim plugins
- **TPM** (tmux plugin manager)
- **Python packages:** neovim, ansible-vault (via pip)

## Configuration Files

All configuration files are symlinked from the `assets/` directory:

- `.zshrc` - zsh configuration with aliases and environment variables
- `.tmux.conf` - tmux configuration with custom key bindings
- `.config/nvim/init.vim` - NeoVim configuration
- `.config/nvim/coc-settings.json` - CoC LSP settings
- `.gitconfig` - Git configuration
- `.ssh/` - SSH configuration and keys
- `.editorconfig` - Editor indentation rules
- And more...

## Customization

### Adding Packages

**macOS:**
- Edit `packages/macos-brew.txt` for CLI tools
- Edit `packages/macos-casks.txt` for GUI applications

**Debian:**
- Edit `packages/debian-apt.txt`

Then re-run the installation script.

### Adding Configuration Files

1. Add your config file to the `assets/` directory
2. Add the relative path to `config/symlinks.txt`
3. Re-run the deployment: `./lib/deploy-configs.sh`

### Modifying Installation

All installation logic is in modular scripts under `lib/`:
- `lib/install-zsh.sh` - zsh and oh-my-zsh setup
- `lib/install-ruby.sh` - RVM and Ruby
- `lib/install-neovim.sh` - NeoVim and plugins
- `lib/install-tmux.sh` - tmux and TPM
- `lib/install-python-tools.sh` - Python packages
- `lib/deploy-configs.sh` - Symlink configurations

## Testing

Test the installation scripts without running them:

```bash
# Test macOS scripts
./tests/test-macos.sh

# Test Debian scripts
./tests/test-debian12.sh
```

These tests verify that all required files exist and scripts have valid syntax.

## Troubleshooting

### macOS: Command Line Tools Not Found

If you see errors about missing compilers:
```bash
xcode-select --install
```

### zsh: command not found after installation

Restart your terminal or run:
```bash
exec zsh
```

### NeoVim plugins not loading

Run the plugin install manually:
```bash
nvim +PlugInstall +qall
```

### Permission denied for SSH keys

Fix SSH permissions:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
chmod 600 ~/.ssh/config
```

### Homebrew not found (macOS)

Ensure Homebrew is in your PATH. Add to your shell:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
# or
eval "$(/usr/local/bin/brew shellenv)"     # Intel
```

## Architecture

This repository uses a modular bash script architecture:

```
dotfiles/
├── install-macos.sh        # macOS entry point
├── install-debian12.sh     # Debian entry point
├── lib/                    # Shared installation scripts
├── packages/               # Package lists by OS
├── config/                 # Installation configuration
└── assets/                 # Dotfiles to symlink
```

Each component is designed to be:
- **Idempotent:** Safe to run multiple times
- **Modular:** Independent scripts for each tool
- **Cross-platform:** Shared code works on both macOS and Debian
- **Verbose:** Clear logging with color-coded output

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch
3. Test your changes on both macOS and Debian if possible
4. Submit a pull request

## License

MIT

## Author

Created and maintained by gruz0

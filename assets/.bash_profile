[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Locale settings (LC_ALL overrides LANG, so only LC_ALL is needed)
export LC_ALL=en_US.UTF-8

# Rust (rustup) - see lib/install-rust.sh
[[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Bun (JavaScript runtime) - see lib/install-bun.sh
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL/bin" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

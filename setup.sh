#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Get the absolute path to the directory containing this script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "🚀 Starting macOS Bootstrap..."

# Ask for the administrator password upfront
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "🛠️ Installing macOS Tooling..."
if ! xcode-select -p &>/dev/null; then
    xcode-select --install
    echo "Wait for XCode tools to finish installing, then run this script again."
    exit 0
fi

if [[ $(sysctl -n machdep.cpu.brand_string) == *Apple* ]]; then
    echo "🍎 Apple Silicon detected. Installing Rosetta 2..."
    sudo softwareupdate --install-rosetta --agree-to-license
fi

echo "🍺 Installing Homebrew..."
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is in the PATH of the current script execution environment
if [ -f "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f "/usr/local/bin/brew" ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

brew update
brew upgrade

echo "📦 Restoring packages from Brewfile..."
brew bundle install --file="$DOTFILES_DIR/Brewfile"

echo "🔗 Symlinking Dotfiles..."
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

# Config directories to symlink (added git)
for app in nushell aerospace bat nvim gh raycast spicetify thefuck zellij git; do
    if [ -d "$DOTFILES_DIR/$app" ]; then
        rm -rf "$CONFIG_DIR/$app"
        ln -s "$DOTFILES_DIR/$app" "$CONFIG_DIR/$app"
        echo "Symlinked ~/.config/$app"
    fi
done

# Home directory files to symlink
ln -sf "$DOTFILES_DIR/starship.toml" "$CONFIG_DIR/starship.toml"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/neovide.lua" "$HOME/neovide.lua"
echo "Symlinked individual files."

echo "🖥️ Configuring iTerm2 to use settings from Dotfiles..."
if [ -d "$DOTFILES_DIR/iterm2" ]; then
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_DIR/iterm2"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    echo "iTerm2 configured to load preferences from $DOTFILES_DIR/iterm2"
else
    echo "⚠️ iTerm2 preferences directory not found in dotfiles!"
fi

echo "🐚 Generating Nushell integration cache files..."
# Create cache and config/env-specific directories
mkdir -p "$HOME/.cache/zoxide"
mkdir -p "$HOME/.cache/carapace"
mkdir -p "$HOME/.cache/atuin"
mkdir -p "$HOME/.cache/starship"
mkdir -p "$HOME/.cargo"

# Pre-generate Nushell scripts to prevent startup parse-time compile errors
zoxide init nushell > "$HOME/.cache/zoxide/init.nu"
carapace _carapace nushell > "$HOME/.cache/carapace/init.nu"
atuin init nu > "$HOME/.cache/atuin/init.nu"
starship init nu > "$HOME/.cache/starship/init.nu"

# Create a baseline cargo env script for Nushell
echo 'use std/util "path add"; path add $"($nu.home-dir)/.cargo/bin"' > "$HOME/.cargo/env.nu"
echo "Nushell integration cache files generated."

echo "🐚 Setting Nushell as default shell..."
NU_PATH=$(command -v nu || true)
if [ -n "$NU_PATH" ]; then
    if ! grep -q "$NU_PATH" /etc/shells; then
        echo "$NU_PATH" | sudo tee -a /etc/shells
    fi

    if [[ "$SHELL" != "$NU_PATH" ]]; then
        sudo chsh -s "$NU_PATH" "$USER"
    fi
else
    echo "⚠️ Nushell binary not found! Skipping default shell setup."
fi


echo "✨ Bootstrap Complete!"

read -p "Do you want to apply macOS system defaults? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    "$DOTFILES_DIR/macos.sh"
fi

echo "🚀 All set! Please restart your terminal."

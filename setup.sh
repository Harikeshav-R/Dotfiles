#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

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
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew update
brew upgrade

echo "📦 Restoring packages from Brewfile..."
brew bundle install --file=Brewfile

echo "🔗 Symlinking Dotfiles..."
DOTFILES_DIR="$HOME/Developer/Dotfiles"
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

# Config directories to symlink
for app in nushell aerospace bat nvim gh raycast spicetify thefuck zellij; do
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

echo "🐚 Setting Nushell as default shell..."
NU_PATH=$(which nu)
if ! grep -q "$NU_PATH" /etc/shells; then
    echo "$NU_PATH" | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "$NU_PATH" ]]; then
    chsh -s "$NU_PATH"
fi

echo "✨ Bootstrap Complete! Please restart your terminal."

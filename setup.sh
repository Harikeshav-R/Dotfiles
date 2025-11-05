#!/bin/sh

# Install XCode
sudo xcode-select --install

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Update brew
brew update

# Install brew formulae
brew install cmake fd gh git git-lfs lazygit neovim ninja node ripgrep uv zsh

# Install brew casks
brew install --cask docker-desktop dotnet-sdk font-fira-code-nerd-font font-jetbrains-mono-nerd-font iterm2 meta-quest-developer-hub microsoft-office-businesspro transmission unity-hub vlc whatsapp zoom 

# Harikeshav's Dotfiles

My automated dotfiles for setting up and bootstrapping a fresh macOS installation.

## Installation

Run the setup script to bootstrap the system:

```bash
./setup.sh
```

## What Gets Set Up

The `setup.sh` script automates the installation and configuration of the entire system:

### 1. System Tooling & Dependencies
- Installs **Xcode Command Line Tools**.
- Installs **Rosetta 2** (if running on Apple Silicon).
- Installs **Homebrew**.

### 2. Applications & Packages
- Restores all formulas, casks, and Mac App Store apps defined in the `Brewfile`.

### 3. Shell & Terminal Environment
- **Nushell**: Configured as the default shell, with integrations pre-compiled for **Zoxide** (smart cd), **Carapace** (completions), **Atuin** (shell history), and **Cargo**.
- **Starship**: Cross-shell prompt.
- **iTerm2**: Configured to load preferences automatically from the `iterm2/` directory.
- **Kitty**: Alternative GPU-accelerated terminal.

### 4. Window Management & Desktop UI
- **AeroSpace** / **Yabai**: Tiling window managers for macOS.
- **SKHD**: Simple hotkey daemon for window management shortcuts.
- **SketchyBar**: Custom macOS status bar.
- **Borders**: Window borders utility.

### 5. Editor & Development Environment
- **Neovim (Nvim)**: Fully configured text editor.
- **Neovide**: GUI for Neovim with custom `neovide.lua` settings.
- **Zellij**: Terminal multiplexer.
- **Git** & **GitHub CLI (gh)**: Global `.gitconfig` and CLI tool configs.

### 6. Utility Configurations
Dotfiles are automatically symlinked to `~/.config/` for:
- **Bat**: A `cat` clone with syntax highlighting.
- **Raycast**: Spotlight replacement.
- **Spicetify**: Spotify client customization.
- **TheFuck**: App which corrects your previous console command.

### 7. macOS System Defaults (`macos.sh`)
At the end of the bootstrap process, you have the option to apply personalized macOS defaults. This configures:
- **General UI**: Dark Mode, expanded save/print panels, disabled auto-correct/smart quotes.
- **Keyboard & Trackpad**: Tap-to-click, fast key repeat, disabled "natural" scrolling.
- **Finder**: Show file extensions, path bar, list view by default, and disable network `.DS_Store` files.
- **Dock**: Autohide enabled, small icon size, and optimized Mission Control animations.
- **Misc**: Screenshots saved as PNGs without shadows, and Activity Monitor visual tweaks.

## Backup and Restore

This repository also includes utilities for migrating machines:
- **`backup.sh`**: An interactive utility to back up developer directories, documents, shell histories, and local app configs to an external drive.
- **`restore.sh`**: A script to restore the backed-up data back into the correct locations on a fresh install.

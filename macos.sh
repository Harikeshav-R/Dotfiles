#!/bin/bash

# macOS System Defaults Script
# Customized based on current system settings on 2026-05-14

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "🚀 Setting macOS system defaults (personalized)..."

###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "  › General UI/UX"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Input (Keyboard/Trackpad)                                                   #
###############################################################################

echo "  › Input (Keyboard/Trackpad)"

# Trackpad: enable tap to click for this user and for the login screen
# [Current Setting: Enabled]
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Finder                                                                      #
###############################################################################

echo "  › Finder"

# Finder: show all filename extensions
# [Current Setting: Enabled]
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
# [Current Setting: Disabled]
defaults write com.apple.finder ShowStatusBar -bool false

# Finder: show path bar
defaults write com.apple.finder ShowPathBar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
# [Current Setting: SCcf]
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
# [Current Setting: Nlsv]
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Dock                                                                        #
###############################################################################

echo "  › Dock"

# Set the icon size of Dock items
# [Current Setting: 48]
defaults write com.apple.dock tilesize -int 48

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Automatically hide and show the Dock
# [Current Setting: Enabled]
defaults write com.apple.dock autohide -bool true

# Don’t show recent applications in Dock
# [Current Setting: Disabled]
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Screen                                                                      #
###############################################################################

echo "  › Screen"

# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

echo "✨ Applying changes (restarting affected apps)..."

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" > /dev/null 2>&1
done

echo "✅ Done. Note that some of these changes require a logout/restart to take effect."

#!/bin/bash

# macOS System Defaults Script
# Comprehensive Audit and Personalization for Harikeshav
# Generated on 2026-05-14

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "🚀 Setting macOS system defaults..."

###############################################################################
# General UI/UX                                                               #
###############################################################################

echo "  › General UI/UX"

# Appearance: Dark Mode
# [Current Setting: Dark]
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Input (Keyboard/Trackpad)                                                   #
###############################################################################

echo "  › Input (Keyboard/Trackpad)"

# Trackpad: enable tap to click for this user and for the login screen
# [Current Setting: Enabled]
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable “natural” (Lion-style) scrolling
# [Current Setting: Disabled (0)]
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Keyboard: Disable "Press and Hold" to allow for key repeat
# [Current Setting: Disabled (0)]
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Keyboard: Set a blazingly fast keyboard repeat rate
# (Standard values: 2 is fast, 15 is slow)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Keyboard: Use F1, F2, etc. keys as standard function keys
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

echo "  › Finder"

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: show all filename extensions
# [Current Setting: Enabled]
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
# [Current Setting: Disabled (0)]
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
# Dock & Mission Control                                                      #
###############################################################################

echo "  › Dock & Mission Control"

# Set the icon size of Dock items
# [Current Setting: 48]
defaults write com.apple.dock tilesize -int 48

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Automatically hide and show the Dock
# [Current Setting: Enabled]
defaults write com.apple.dock autohide -bool true

# Don’t show recent applications in Dock
# [Current Setting: Disabled]
defaults write com.apple.dock show-recents -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Group windows by application in Mission Control
# [Current Setting: Enabled (1)]
defaults write com.apple.dock "expose-group-apps" -bool true

# Don’t automatically rearrange Spaces based on most recent use
# [Current Setting: Disabled (0)]
defaults write com.apple.dock "mru-spaces" -bool false

###############################################################################
# Menu Bar Clock                                                              #
###############################################################################

echo "  › Menu Bar"

# Menu Bar: Show seconds in clock
# [Current Setting: Enabled (1)]
defaults write com.apple.menuextra.clock ShowSeconds -bool true

# Menu Bar: Don't show Day of Week
# [Current Setting: Disabled (0)]
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool false

###############################################################################
# Screen & Activity Monitor                                                   #
###############################################################################

echo "  › Screen & Apps"

# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Activity Monitor: Open main window on launch
# [Current Setting: Enabled (1)]
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Activity Monitor: Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

###############################################################################
# Kill affected applications                                                  #
###############################################################################

echo "✨ Applying changes (restarting affected apps)..."

for app in "Dock" "Finder" "SystemUIServer" "Activity Monitor"; do
    killall "$app" > /dev/null 2>&1
done

echo "✅ Done. Note that some of these changes require a logout/restart to take effect."

#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined variables, or pipe failure

# mac_settings.sh - Configure macOS for developer workflow

# Source shared logging utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils_logging.sh"

# Check if running on macOS
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        log_error "This script is designed for macOS only"
        exit 1
    fi
}

# Keyboard & Text Input Settings
configure_keyboard() {
    log_info "Configuring keyboard and text input settings..."

    # Disable automatic spelling correction
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable smart quotes
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable smart dashes
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable auto-capitalization
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    # Disable automatic period substitution
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

    # # Enable full keyboard access for all controls
    # defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    log_success "Keyboard settings configured"
}

# # Finder Settings
# configure_finder() {
#     log_info "Configuring Finder settings..."

#     # Show hidden files
#     defaults write com.apple.finder AppleShowAllFiles -bool true

#     # Show file extensions
#     defaults write NSGlobalDomain AppleShowAllExtensions -bool true

#     # Show path bar
#     defaults write com.apple.finder ShowPathbar -bool true

#     # Show status bar
#     defaults write com.apple.finder ShowStatusBar -bool true

#     # Search current folder by default
#     defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

#     # Disable warning when changing file extension
#     defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

#     # Use list view in all Finder windows
#     defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

#     # Show Library folder
#     chflags nohidden ~/Library

#     # Restart Finder
#     killall Finder

#     log_success "Finder settings configured"
# }

# # Dock Settings
# configure_dock() {
#     log_info "Configuring Dock settings..."

#     # Set Dock size
#     defaults write com.apple.dock tilesize -int 48

#     # Enable magnification
#     defaults write com.apple.dock magnification -bool true

#     # Set magnification size
#     defaults write com.apple.dock largesize -int 64

#     # Minimize windows into application icon
#     defaults write com.apple.dock minimize-to-application -bool true

#     # Show indicator lights for open applications
#     defaults write com.apple.dock show-process-indicators -bool true

#     # Don't show recent applications
#     defaults write com.apple.dock show-recents -bool false

#     # Automatically hide and show the Dock
#     defaults write com.apple.dock autohide -bool true

#     # Remove all default app icons from Dock
#     defaults write com.apple.dock persistent-apps -array

#     # Restart Dock
#     killall Dock

#     log_success "Dock settings configured"
# }

# # Trackpad Settings
# configure_trackpad() {
#     log_info "Configuring trackpad settings..."

#     # Enable tap to click
#     defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
#     defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

#     # Enable three finger drag
#     defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
#     defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

#     # Enable App Expose gesture
#     defaults write com.apple.dock showAppExposeGestureEnabled -bool true

#     log_success "Trackpad settings configured"
# }

# # Terminal & Development Settings
# configure_development() {
#     log_info "Configuring development settings..."

#     # Enable developer mode in Safari (if Safari is installed)
#     if [[ -d "/Applications/Safari.app" ]]; then
#         defaults write com.apple.Safari IncludeDevelopMenu -bool true
#         defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
#         defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
#     fi

#     # Show full path in Terminal title
#     defaults write com.apple.terminal ProxiesCommand -string "echo \$PWD"

#     # Don't prompt for confirmation when closing Terminal
#     defaults write com.apple.terminal SecureKeyboardEntry -bool true

#     log_success "Development settings configured"
# }

# # Screenshot Settings
# configure_screenshots() {
#     log_info "Configuring screenshot settings..."

#     # Save screenshots to Downloads folder
#     defaults write com.apple.screencapture location -string "${HOME}/Downloads"

#     # Save screenshots in PNG format
#     defaults write com.apple.screencapture type -string "png"

#     # Disable shadow in screenshots
#     defaults write com.apple.screencapture disable-shadow -bool true

#     # Include date in screenshot filename
#     defaults write com.apple.screencapture include-date -bool true

#     # Restart SystemUIServer
#     killall SystemUIServer

#     log_success "Screenshot settings configured"
# }

# # Security & Privacy Settings
# configure_security() {
#     log_info "Configuring security settings..."

#     # Require password immediately after sleep or screen saver
#     defaults write com.apple.screensaver askForPassword -int 1
#     defaults write com.apple.screensaver askForPasswordDelay -int 0

#     # Disable Siri
#     defaults write com.apple.Siri StatusMenuVisible -bool false
#     defaults write com.apple.Siri UserHasDeclinedEnable -bool true

#     # Disable analytics
#     defaults write com.apple.analytics KnowledgeStore -bool false

#     log_success "Security settings configured"
# }

# # Menu Bar Settings
# configure_menu_bar() {
#     log_info "Configuring menu bar settings..."

#     # Show battery percentage
#     defaults write com.apple.menuextra.battery ShowPercent -string "YES"

#     # Show Bluetooth in menu bar
#     defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

#     # Show Wi-Fi in menu bar
#     defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/AirPort.menu"

#     log_success "Menu bar settings configured"
# }

# Main function
main() {
    log_info "Starting macOS developer settings configuration..."

    # Check if running on macOS
    check_macos

    # Apply all configurations
    configure_keyboard
    # configure_finder
    # configure_dock
    # configure_trackpad
    # configure_development
    # configure_screenshots
    # configure_security
    # configure_menu_bar

    log_success "macOS developer settings configuration completed!"
    log_warning "Some changes may require a logout/restart to take effect"
}

# Run main function
main "$@"

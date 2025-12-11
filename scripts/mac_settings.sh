#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined variables, or pipe failure

# mac_settings.sh - Configure macOS for developer workflow
#
# Sections can be run selectively by passing names as arguments, e.g.:
#   ./mac_settings.sh keyboard dock screenshots
#
# Or by setting MAC_SETTINGS_SECTIONS as a space- or comma-separated list, e.g.:
#   MAC_SETTINGS_SECTIONS="keyboard finder" ./mac_settings.sh

# Source shared logging utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils_logging.sh"

# Check if running on macOS and that required tools exist
check_macos() {
    if [[ "${OSTYPE:-}" != darwin* ]]; then
        log_error "This script is designed for macOS only"
        exit 1
    fi

    if ! command -v defaults >/dev/null 2>&1; then
        log_error "'defaults' command not found - are you on macOS?"
        exit 1
    fi
}

# Keyboard & Text Input Settings
configure_keyboard() {
    log_info "Configuring keyboard and text input settings..."

    # Developer-friendly key repeat behavior
    # Use fast key repeat rates
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Disable press-and-hold in favor of key repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

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

    log_success "Keyboard settings configured"
}

# Finder Settings
configure_finder() {
    log_info "Configuring Finder settings..."

    # Show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show file extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Search current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Disable warning when changing file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Use list view in all Finder windows
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Open folders in tabs instead of new windows
    defaults write com.apple.finder FinderSpawnTab -bool true

    # Disable tags in Finder
    defaults write com.apple.finder ShowRecentTags -bool false

    # # Show Library folder
    # chflags nohidden ~/Library

    # Set default new window to home directory
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

    # Restart Finder
    killall Finder 2>/dev/null || true

    log_success "Finder settings configured"
}

# Dock Settings
configure_dock() {
    log_info "Configuring Dock settings..."

    # Set Dock size
    defaults write com.apple.dock tilesize -int 48

    # Enable magnification
    defaults write com.apple.dock magnification -bool true

    # Set magnification size
    defaults write com.apple.dock largesize -int 64

    # Set Minimized window effect to scale
    defaults write com.apple.dock mineffect -string "scale"

    # Set Window title bar double-click action to Fill
    defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Fill"

    # Minimize windows into application icon
    defaults write com.apple.dock minimize-to-application -bool true

    # Show indicator lights for open applications
    defaults write com.apple.dock show-process-indicators -bool true

    # Don't show recent applications
    defaults write com.apple.dock show-recents -bool false

    # Automatically hide and show the Dock
    defaults write com.apple.dock autohide -bool true

    # Instant Dock hiding
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -int 0

    # # Faster Dock hiding undo
    # defaults write com.apple.dock autohide-delay -float 0.5
    # defaults write com.apple.dock autohide-time-modifier -int 0.5

    # Make Hidden Apps Transparent
    defaults write com.apple.dock showhidden -bool true

    # Disable animate opening applications
    defaults write com.apple.dock launchAnimated -bool false

    # Group windows by application
    defaults write com.apple.dock expose-group-by-app -bool true

    # Remove all default app icons from Dock
    defaults write com.apple.dock persistent-apps -array

    # Restart Dock
    killall Dock 2>/dev/null || true

    log_success "Dock settings configured"
}

# Trackpad Settings
configure_trackpad() {
    log_info "Configuring trackpad settings..."

    # Enable tap to click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

    # Enable three finger drag
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

    # Enable App Expose gesture
    defaults write com.apple.dock showAppExposeGestureEnabled -bool true

    log_success "Trackpad settings configured"
}

# Terminal & Development Settings
configure_development() {
    log_info "Configuring development settings..."

    # Enable developer mode in Safari (if Safari is installed)
    if [[ -d "/Applications/Safari.app" ]]; then
        defaults write com.apple.Safari IncludeDevelopMenu -bool true
        defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
        defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
    fi

    # Enable secure keyboard entry in Terminal
    defaults write com.apple.terminal SecureKeyboardEntry -bool true

    log_success "Development settings configured"
}

# Screenshot Settings
configure_screenshots() {
    log_info "Configuring screenshot settings..."

    # Save screenshots in jpg format
    defaults write com.apple.screencapture type -string "jpg"

    # Save screenshots to ~/Pictures/screenshots
    mkdir -p "${HOME}/Pictures/screenshots"
    defaults write com.apple.screencapture location -string "${HOME}/Pictures/screenshots"

    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true

    # Include date in screenshot filename
    defaults write com.apple.screencapture include-date -bool true

    # Restart SystemUIServer
    killall SystemUIServer 2>/dev/null || true

    log_success "Screenshot settings configured"
}

# Security & Privacy Settings
configure_security() {
    log_info "Configuring security settings..."

    # Require password immediately after sleep or screen saver
    defaults write com.apple.screensaver askForPassword -int 1
    defaults write com.apple.screensaver askForPasswordDelay -int 0

    # Disable Siri
    defaults write com.apple.Siri StatusMenuVisible -bool false
    defaults write com.apple.Siri UserHasDeclinedEnable -bool true

    # # Allow accessories to connect
    # defaults write /Library/Preferences/com.apple.Bluetooth.plist BluetoothAutoSeekPointingDevice -bool true

    # # Ask for new accessories
    # defaults write /Library/Preferences/com.apple.Bluetooth.plist BluetoothAutoSeekKeyboard -bool true

    log_success "Security settings configured"
}

# Menu Bar Settings
configure_menu_bar() {
    log_info "Configuring menu bar settings..."

    # Show battery percentage
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"

    log_success "Menu bar settings configured"
}

# Software Update Settings
configure_updates() {
    log_info "Configuring automatic updates settings..."

    # Download new updates when available
    defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true

    # Install macOS updates
    defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticSecurityUpdates -bool true

    # Install security responses and system files
    defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

    log_success "Automatic updates settings configured"
}

run_section() {
    local section=$1
    case "$section" in
        keyboard)
            configure_keyboard
            ;;
        finder)
            configure_finder
            ;;
        dock)
            configure_dock
            ;;
        trackpad)
            configure_trackpad
            ;;
        development)
            configure_development
            ;;
        screenshots)
            configure_screenshots
            ;;
        security)
            configure_security
            ;;
        menu_bar|menubar|menu-bar)
            configure_menu_bar
            ;;
        updates)
            configure_updates
            ;;
        *)
            log_warning "Unknown section '$section' - skipping"
            ;;
    esac
}

# Main function
main() {
    log_info "Starting macOS developer settings configuration..."

    # Check if running on macOS
    check_macos

    # Determine which sections to run
    local -a sections=()

    if [[ $# -gt 0 ]]; then
        # Use positional arguments as explicit section list
        sections=("$@")
    elif [[ -n "${MAC_SETTINGS_SECTIONS:-}" ]]; then
        # Split MAC_SETTINGS_SECTIONS on commas and/or spaces
        local raw_sections="${MAC_SETTINGS_SECTIONS}"
        local IFS=', '
        read -r -a sections <<< "$raw_sections"
    fi

    if [[ ${#sections[@]} -eq 0 ]]; then
        # Default: run all sections
        sections=(
            keyboard
            finder
            dock
            trackpad
            development
            screenshots
            security
            menu_bar
            updates
        )
    fi

    for section in "${sections[@]}"; do
        run_section "$section"
    done

    log_success "macOS developer settings configuration completed!"
    log_warning "Some changes may require a logout/restart to take effect"
}

# Run main function
main "$@"

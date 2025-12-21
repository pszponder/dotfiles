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

    # Fast keyboard key repeat
    defaults write -g InitialKeyRepeat -int 15
    defaults write -g KeyRepeat -int 1

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

    # Always show file extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Always search current folder
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Show path bar and status bar
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder ShowPathbar -bool true

    # Devices for the sidebar
    defaults write com.apple.sidebarlists systemitems -dict-add ShowServers -int 1
    defaults write com.apple.sidebarlists systemitems -dict-add ShowRemovable -int 1
    defaults write com.apple.sidebarlists systemitems -dict-add ShowHardDisks -int 1
    defaults write com.apple.sidebarlists systemitems -dict-add ShowEjectables -int 1

    # Items to display on the desktop (0 = hide, 1 = show)
    defaults write com.apple.finder ShowHardDrivesOnDesktop -int 0
    defaults write com.apple.finder ShowMountedServersOnDesktop -int 0
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -int 0
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -int 0

    # Disable warning when changing file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # List view by default
    # Possible values: `icnv` (icon), `clmv` (column), `Flwv` (flow), `Nlsv` (list)
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Open folders in tabs instead of new windows
    defaults write com.apple.finder FinderSpawnTab -bool true

    # Disable tags in Finder
    defaults write com.apple.finder ShowRecentTags -bool false

    # Open home in new window
    defaults write com.apple.finder NewWindowTarget -string "PfHm"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

    # Show the ~/Library folder
    chflags nohidden ~/Library

    # Restart Finder
    killall Finder 2>/dev/null || true

    log_success "Finder settings configured"
}

# Dock Settings
configure_dock() {
    log_info "Configuring Dock settings..."

    # Set Dock size (larger icons) (max is 128)
    defaults write com.apple.dock tilesize -int 48

    # Enable magnification
    defaults write com.apple.dock magnification -bool true

    # Set magnification size to maximum (128 is macOS limit)
    defaults write com.apple.dock largesize -int 128

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

    # Remove autohide delay for instant response
    defaults write com.apple.dock autohide-delay -float 0

    # Faster animation for showing/hiding Dock
    defaults write com.apple.dock autohide-time-modifier -float 0

    # Make Hidden Apps Transparent
    defaults write com.apple.dock showhidden -bool true

    # Disable animate opening applications
    defaults write com.apple.dock launchAnimated -bool false

    # Group windows by application
    defaults write com.apple.dock expose-group-by-app -bool true

    # Define list of apps to pin to Dock
    local -a pinned_apps=(
        # "/System/Library/CoreServices/Finder.app"
        "/System/Applications/Mail.app"
        "/Applications/Safari.app"
        "/Applications/Brave Browser.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Obsidian.app"
        "/Applications/Ghostty.app"
        "/Applications/Warp.app"
        "/Applications/Bitwarden.app"
        "/Applications/Discord.app"
    )
    # Remove all default app icons from Dock
    defaults write com.apple.dock persistent-apps -array

    if command -v dockutil >/dev/null 2>&1; then
        log_info "Using dockutil to configure Dock..."

        # Remove all existing persistent apps via dockutil (more reliable)
        dockutil --remove all --no-restart || true

        # Add pinned applications via dockutil
        for app in "${pinned_apps[@]}"; do
            if [[ -d "$app" ]]; then
                dockutil --add "$app" --no-restart || log_warning "dockutil failed to add: $app"
                log_info "Pinned: $(basename "$app")"
            else
                log_warning "App not found: $app"
            fi
        done
    else
        # Fallback to defaults-based approach
        log_warning "dockutil not found; using defaults fallback"
        for app in "${pinned_apps[@]}"; do
            if [[ -d "$app" ]]; then
                # Use a fully qualified file URL with trailing slash and URL-encoded spaces
                local file_url="file://${app// /%20}/"
                defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-type</key><string>file-tile</string><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${file_url}</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>"
                log_info "Pinned: $(basename "$app")"
            else
                log_warning "App not found: $app"
            fi
        done
    fi

    # Restart Dock
    killall Dock 2>/dev/null || true

    log_success "Dock settings configured"
}

# Trackpad Settings
configure_trackpad() {
    log_info "Configuring trackpad settings..."

    # Trackpad: Enable tap to click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
    defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Trackpad: Two-finger tap for right-click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

    # Increase tracking speed (range: 0-3, 2.5 = fast but not maximum)
    defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5

    # Set scroll speed to maximum
    defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 1

    # Disable three finger drag (conflicts with 3-finger swipe for spaces)
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false

    # Enable 3-finger swipe between fullscreen apps/spaces
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 2

    # Enable App Expose gesture
    defaults write com.apple.dock showAppExposeGestureEnabled -bool true

    log_success "Trackpad settings configured"
}

# Terminal & Development Settings
configure_development() {
    log_info "Configuring development settings..."

    # # Enable developer mode in Safari (if Safari is installed)
    # if [[ -d "/Applications/Safari.app" ]]; then
    #     # Safari uses a sandbox container that can't be modified externally
    #     # Try using osascript to enable developer menu through Safari's preferences
    #     log_info "Attempting to enable Safari developer menu..."

    #     if osascript -e 'tell application "Safari" to activate' \
    #                   -e 'tell application "System Events" to tell process "Safari"' \
    #                   -e 'tell menu bar 1' \
    #                   -e 'tell menu bar item "Safari"' \
    #                   -e 'tell menu "Safari"' \
    #                   -e 'click menu item "Settings…"' \
    #                   -e 'end tell' \
    #                   -e 'end tell' \
    #                   -e 'end tell' \
    #                   -e 'delay 1' \
    #                   -e 'tell window 1' \
    #                   -e 'click button "Advanced" of toolbar 1' \
    #                   -e 'delay 0.5' \
    #                   -e 'tell group 1 of group 1' \
    #                   -e 'set checkboxValue to value of checkbox "Show features for web developers"' \
    #                   -e 'if checkboxValue is 0 then click checkbox "Show features for web developers"' \
    #                   -e 'end tell' \
    #                   -e 'end tell' \
    #                   -e 'end tell' \
    #                   -e 'tell application "Safari" to quit' 2>/dev/null; then
    #         log_success "Safari developer menu enabled"
    #     else
    #         log_warning "Could not automatically enable Safari developer menu. Please enable manually:"
    #         log_warning "  Safari → Settings → Advanced → Show features for web developers"
    #     fi
    # fi

    # Enable secure keyboard entry in Terminal
    defaults write com.apple.terminal SecureKeyboardEntry -bool true

    # Enable key repeat in VS Code
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

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

# System Preferences & UI Settings
configure_system_preferences() {
    log_info "Configuring system preferences..."

    # Scroll bars
    # Possible values: "WhenScrolling", "Automatic", "Always"
    defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

    # Right click for magic mouse
    defaults write com.apple.AppleMultitouchMouse MouseButtonMode -string TwoButton

    # Different spaces for different displays
    defaults write com.apple.spaces spans-displays -int 0

    # Don't automatically rearrange Spaces based on most recent use
    defaults write com.apple.dock mru-spaces -int 0

    log_success "System preferences configured"
}

# Hot Corners Settings
configure_hot_corners() {
    log_info "Configuring hot corners..."

    # Hot corner values:
    # 0 = no-op
    # 2 = Mission Control
    # 3 = Show application windows
    # 4 = Desktop
    # 5 = Start screen saver
    # 6 = Disable screen saver
    # 7 = Dashboard
    # 10 = Put display to sleep
    # 11 = Launchpad
    # 12 = Notification Center
    # 13 = Look up & data detectors
    # 14 = Smart zoom
    # 15 = Increase contrast
    # 16 = Reduce motion
    # 17 = Lock screen
    # 18 = Quick Note (Notes app)

    # Modifier key values:
    # 0 = no modifier
    # 131072 = Shift (⇧)
    # 262144 = Control (⌃)
    # 524288 = Option (⌥)
    # 1048576 = Command (⌘)

    # Top-left: Mission Control (requires Option)
    defaults write com.apple.dock wvous-tl-corner -int 2
    defaults write com.apple.dock wvous-tl-modifier -int 524288

    # Top-right: Desktop (requires Option)
    defaults write com.apple.dock wvous-tr-corner -int 4
    defaults write com.apple.dock wvous-tr-modifier -int 524288

    # Bottom-left: Show application windows (requires Option)
    defaults write com.apple.dock wvous-bl-corner -int 3
    defaults write com.apple.dock wvous-bl-modifier -int 524288

    # Bottom-right: Quick Note (requires Option)
    defaults write com.apple.dock wvous-br-corner -int 14
    defaults write com.apple.dock wvous-br-modifier -int 524288

    # Restart Dock to apply changes
    killall Dock 2>/dev/null || true

    log_success "Hot corners configured (all require Option): TL=Mission Control, TR=Desktop, BL=App Windows, BR=Quick Note"
}

# Menu Bar Settings
configure_menu_bar() {
    log_info "Configuring menu bar settings..."

    # Always show the menu bar (disable autohide)
    # defaults write NSGlobalDomain AppleMenuBarVisible -bool true
    # defaults write NSGlobalDomain _HIHideMenuBar -bool false

    # Disable Spotlight search icon in menu bar
    defaults write com.apple.Spotlight MenuItemHidden -bool true

    # Show battery percentage
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"

    log_success "Menu bar settings configured"
}

# Accessibility Settings
configure_accessibility() {
    log_info "Configuring accessibility permissions..."

    # List of apps that need accessibility permissions
    local -a accessibility_apps=(
        "/Applications/Ghostty.app"
        "/Applications/Raycast.app"
        "/Applications/Warp.app"
    )

    # Check if apps are installed and need accessibility permissions
    local needs_manual_action=false
    for app in "${accessibility_apps[@]}"; do
        if [[ -d "$app" ]]; then
            local app_name=$(basename "$app" .app)
            log_info "Checking accessibility permissions for: $app_name"

            # Check if app has accessibility permissions
            # Note: This requires the app to have requested permissions at least once
            if ! osascript -e "tell application \"System Events\" to get name of processes" >/dev/null 2>&1; then
                log_warning "Unable to verify accessibility status programmatically"
            fi

            log_info "App found: $app_name"
            needs_manual_action=true
        else
            log_warning "App not found: $app"
        fi
    done

    if [[ "$needs_manual_action" == true ]]; then
        log_warning "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        log_warning "  Manual action required: Grant Accessibility permissions"
        log_warning "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        log_warning ""
        log_warning "  1. Open System Settings > Privacy & Security > Accessibility"
        log_warning "  2. Click the lock icon and authenticate"
        log_warning "  3. Click the '+' button to add apps"
        log_warning "  4. Navigate to Applications directory to find the apps"
        log_warning "  5. Enable the following apps:"
        for app in "${accessibility_apps[@]}"; do
            if [[ -d "$app" ]]; then
                log_warning "     • $(basename "$app" .app)"
            fi
        done
        log_warning ""
        log_warning "  Opening System Settings now..."
        log_warning ""

        # Open Accessibility settings pane
        open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"

        log_info "Waiting for you to grant permissions (press Enter when done)..."
        read -r
    fi

    log_success "Accessibility configuration completed"
}

# Software Update Settings
configure_updates() {
    log_info "Configuring automatic updates settings..."

    # Enable automatic check for updates
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

    # Download new updates when available
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true

    # Install macOS updates automatically
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true

    # Install security updates automatically
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticSecurityUpdates -bool true

    # Install system data files and security updates automatically
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true

    # Install critical security responses and system files
    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

    # Auto-install App Store app updates
    sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true

    log_success "Automatic updates settings configured"
}

# Wallpaper Settings
configure_wallpaper() {
    log_info "Configuring desktop wallpaper..."

    local wallpaper_path="$HOME/Pictures/wallpaper/catppuccin-mocha.png"

    if [[ ! -f "$wallpaper_path" ]]; then
        log_warning "Wallpaper not found: $wallpaper_path"
        return 1
    fi

    if osascript <<EOF
tell application "System Events"
    tell every desktop
        set picture to POSIX file "$wallpaper_path"
    end tell
end tell
EOF
    then
        log_success "Wallpaper set to: $wallpaper_path"
    else
        log_error "Failed to set wallpaper"
        return 1
    fi
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
        system_preferences|system-preferences|preferences)
            configure_system_preferences
            ;;
        hot_corners|hot-corners|corners)
            configure_hot_corners
            ;;
        menu_bar|menubar|menu-bar)
            configure_menu_bar
            ;;
        accessibility)
            configure_accessibility
            ;;
        updates)
            configure_updates
            ;;
        wallpaper)
            configure_wallpaper
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
            system_preferences
            hot_corners
            menu_bar
            accessibility
            updates
            wallpaper
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

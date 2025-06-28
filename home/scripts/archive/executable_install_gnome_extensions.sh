#!/bin/bash

# Script to install and enable GNOME Shell extensions.
# Supports modern GNOME (40+) via 'gnome-extensions' CLI.
# Provides guidance for older GNOME versions.
#
# Usage:
#   ./install-gnome-extension.sh                    # Installs all hardcoded extensions from the list (DEFAULT)
#   ./install-gnome-extension.sh <extension_id_or_zip_path> [optional_gnome_version]
#   ./install-gnome-extension.sh --install-all [optional_gnome_version]
#   ./install-gnome-extension.sh --help | -h
#
# Examples:
#   ./install-gnome-extension.sh                  # Installs all hardcoded extensions
#   ./install-gnome-extension.sh 3628             # Installs 'ArcMenu' by ID
#   ./install-gnome-extension.sh ~/Downloads/myextension.zip # Installs from a local .zip file
#   ./install-gnome-extension.sh --install-all 44 # Installs all extensions, specifically for GNOME 44

# --- Configuration ---
# Standard user-local extension directory
EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"
METADATA_FILE="metadata.json"

# HARDCODED LIST OF EXTENSIONS TO INSTALL
# Add extension IDs (numbers from extensions.gnome.org URL) here.
# I've looked up the IDs for your requested extensions:
EXTENSIONS_TO_INSTALL=(
    "3733"  # Tiling Assistant
    "615"   # AppIndicator and KStatusNotifierItem Support
    "6"     # Apps Menu
    "3193"  # Blur my Shell
    "517"   # Caffeine
    "307"   # Dash to Dock
    "1319"  # GSConnect
    "1184"  # Logo Menu
    "7"     # Places Status Indicator
    "5440"  # Search Light
)


# --- Functions ---

log_info() {
    echo -e "\e[32mINFO:\e[0m $1"
}

log_warn() {
    echo -e "\e[33mWARN:\e[0m $1" >&2
}

log_error() {
    echo -e "\e[31mERROR:\e[0m $1" >&2
}

# Function to display help message
show_help() {
    echo "Usage: $(basename "$0")"
    echo "       $(basename "$0") <extension_id_or_zip_path> [optional_gnome_version]"
    echo "       $(basename "$0") --install-all [optional_gnome_version]"
    echo "       $(basename "$0") --help | -h"
    echo ""
    echo "This script helps install and enable GNOME Shell extensions."
    echo "If run without arguments, it defaults to installing the hardcoded list."
    echo ""
    echo "Arguments:"
    echo "  <extension_id_or_zip_path> : Can be:"
    echo "                               - An Extension ID (number from extensions.gnome.org URL, e.g., 3628 for ArcMenu)."
    echo "                                 (Best supported for GNOME 40+ with 'gnome-extensions' CLI)."
    echo "                               - A path to a local .zip file containing the extension."
    echo "  --install-all              : Explicitly triggers installation of the hardcoded list of extensions defined in the script."
    echo "                               (This is the default behavior if no other arguments are provided)."
    echo "  [optional_gnome_version]   : Manually specify your GNOME Shell version (e.g., 44, 3.38)."
    echo "                               This is used when downloading by ID to get the correct versioned zip."
    echo                               "If not provided, script attempts to auto-detect."
    echo ""
    echo "Installation Methods:"
    echo "  - For GNOME 40+ (with 'gnome-extensions' CLI): Uses 'gnome-extensions install <ID_or_ZIP>' and 'enable'."
    echo "  - For older GNOME (or if 'gnome-extensions' is missing): Requires a .zip file path."
    echo "    It will extract the zip to '$EXTENSIONS_DIR/<UUID>/' and enable via 'gsettings'."
    echo ""
    echo "Important Notes:"
    echo "  - This script will SKIP installation of extensions that appear to be already installed."
    echo "    (If the extension's directory exists under '$EXTENSIONS_DIR')."
    echo "  - After installation/enabling, you might need to restart GNOME Shell (Alt+F2 then 'r' then Enter)"
    echo "    or log out/in for changes to take full effect."
    echo "  - Ensure you have 'unzip', 'curl' (if downloading), and 'jq' (if parsing JSON) installed."
    echo "  - Extensions.gnome.org API might change, affecting direct download by ID."
    echo "  - Ensure extensions are compatible with your specific GNOME Shell version!"
    exit 0
}

# Get GNOME Shell version
get_gnome_shell_version() {
    local version=""
    local manual_ver_override="$1" # This function now accepts an override

    if [ -n "$manual_ver_override" ]; then
        echo "$manual_ver_override"
        return 0
    fi

    # Try gnome-shell --version (most reliable)
    if command -v gnome-shell &> /dev/null; then
        version=$(gnome-shell --version 2>&1 | grep -oP '(?<=Shell )\d+\.\d+' | cut -d'.' -f1) # Get major version like '44'
        if [ -z "$version" ]; then
            version=$(gnome-shell --version 2>&1 | grep -oP '(?<=Shell )\d+\.\d+') # Full version if major only fails
        fi
    fi

    if [ -z "$version" ]; then
        log_warn "Could not reliably determine GNOME Shell version using 'gnome-shell --version'."
        # Fallback to check gsettings for schema version, less direct
        if command -v gsettings &> /dev/null; then
             version=$(gsettings get org.gnome.shell version | tr -d "'")
        fi
    fi

    if [ -z "$version" ]; then
        log_error "Failed to detect GNOME Shell version. Please provide it manually as the second argument."
        return 1 # Indicate failure
    fi
    echo "$version"
    return 0 # Indicate success
}

# Function to download extension from extensions.gnome.org by ID
download_extension_by_id() {
    local ext_id="$1"
    local gnome_ver="$2"
    local download_url=""
    local zip_file="/tmp/gnome-extension-${ext_id}.zip"

    log_info "Attempting to download extension ID $ext_id for GNOME Shell $gnome_ver..."

    if ! command -v curl &> /dev/null; then
        log_error "'curl' command not found. Cannot download extension from extensions.gnome.org."
        return 1
    fi
    if ! command -v jq &> /dev/null; then
        log_error "'jq' command not found. Cannot parse JSON API response to get download URL."
        return 1
    fi

    # Query the API to get the correct download URL for the specific GNOME Shell version
    local api_response=$(curl -s "https://extensions.gnome.org/extension-info/?pk=$ext_id&shell_version=$gnome_ver")

    # Check if API response is valid JSON and contains necessary info
    if echo "$api_response" | jq -e 'has("download_url") and has("uuid")' >/dev/null; then
        download_url="https://extensions.gnome.org$(echo "$api_response" | jq -r '.download_url')"
        local uuid=$(echo "$api_response" | jq -r '.uuid')

        log_info "Downloading from: $download_url"
        curl -L -o "$zip_file" "$download_url" || { log_error "Failed to download extension zip."; return 1; }

        # Verify downloaded file
        if [ ! -f "$zip_file" ]; then
            log_error "Downloaded file not found at $zip_file."
            return 1
        fi

        echo "$zip_file:$uuid" # Return zip file path and UUID
        return 0
    else
        log_error "Could not find download URL for extension ID $ext_id for GNOME Shell version $gnome_ver."
        log_error "This might mean the extension is not compatible with your GNOME version, or the ID is wrong."
        # log_error "API Response: $api_response" # Uncomment for debugging API responses
        return 1
    fi
}

# Extract UUID from a local zip file
get_uuid_from_zip() {
    local zip_path="$1"
    local uuid=""

    if ! command -v unzip &> /dev/null; then
        log_error "'unzip' command not found. Cannot extract metadata.json."
        return 1
    fi

    # Extract metadata.json from the zip to a temporary location
    local temp_dir=$(mktemp -d)
    unzip -q -j "$zip_path" "$METADATA_FILE" -d "$temp_dir" || { log_error "Failed to extract metadata.json from $zip_path"; rm -rf "$temp_dir"; return 1; }

    # Read UUID from metadata.json
    uuid=$(jq -r '.uuid' "$temp_dir/$METADATA_FILE" 2>/dev/null)
    rm -rf "$temp_dir"

    if [ -z "$uuid" ] || [ "$uuid" == "null" ]; then
        log_error "Could not find 'uuid' in '$METADATA_FILE' within '$zip_path'."
        return 1
    fi
    echo "$uuid"
    return 0
}

# Function to install and enable a single extension
install_and_enable_extension() {
    local ext_input="$1"
    local gnome_shell_ver="$2" # Pass the detected/manual GNOME version here
    local is_success=0

    log_info "--- Processing Extension: $ext_input ---"

    local IS_EXTENSION_ID=false
    local INSTALL_ZIP_PATH=""
    local EXT_UUID=""

    # Case 1: Input is a local .zip file
    if [[ "$ext_input" == *.zip ]]; then
        log_info "Input is a local .zip file: $ext_input"
        if [ ! -f "$ext_input" ]; then
            log_error "Zip file not found: $ext_input"
            return 1
        fi
        INSTALL_ZIP_PATH="$ext_input"
        EXT_UUID=$(get_uuid_from_zip "$INSTALL_ZIP_PATH")
        if [ $? -ne 0 ]; then
            log_error "Could not get UUID from zip file. Skipping."
            return 1
        fi

    # Case 2: Input is an Extension ID (number)
    elif [[ "$ext_input" =~ ^[0-9]+$ ]]; then
        log_info "Input is an Extension ID: $ext_input"
        IS_EXTENSION_ID=true

        # We need the UUID to check if installed *before* full download
        # First, try to just get the UUID via API (downloading the zip temporarily)
        local TEMP_DOWNLOAD_RESULT=$(download_extension_by_id "$ext_input" "$gnome_shell_ver")
        if [ $? -ne 0 ]; then
            log_error "Failed to get UUID for extension ID $ext_input. Skipping."
            return 1
        fi
        INSTALL_ZIP_PATH=$(echo "$TEMP_DOWNLOAD_RESULT" | cut -d':' -f1) # This path will be used later if we proceed
        EXT_UUID=$(echo "$TEMP_DOWNLOAD_RESULT" | cut -d':' -f2)

    else
        log_error "Invalid input '$ext_input'. Please provide an Extension ID (number) or a path to a .zip file."
        return 1
    fi

    # --- NEW CHECK: Don't install if already present ---
    local EXTENSION_INSTALL_PATH="$EXTENSIONS_DIR/$EXT_UUID"
    if [ -d "$EXTENSION_INSTALL_PATH" ]; then
        log_warn "Extension with UUID '$EXT_UUID' appears to be already installed at '$EXTENSION_INSTALL_PATH'."
        log_warn "Skipping re-installation of '$ext_input'."
        log_info "If you wish to update, please remove it manually first (e.g., using GNOME Extensions app or by deleting the folder)."
        # Clean up the downloaded zip if it was just downloaded for this check
        if [ "$IS_EXTENSION_ID" = true ] && [ -f "$INSTALL_ZIP_PATH" ]; then
            rm -f "$INSTALL_ZIP_PATH"
        fi
        return 0 # Indicate success as it's already "installed"
    fi

    # --- Installation Logic (only runs if not already installed) ---

    # Prefer 'gnome-extensions' CLI for modern GNOME
    if command -v gnome-extensions &> /dev/null && [ "$gnome_shell_ver" -ge 40 ]; then
        log_info "Using 'gnome-extensions' CLI for installation (GNOME $gnome_shell_ver)."

        # Install the extension
        log_info "Installing extension from '$INSTALL_ZIP_PATH'..."
        gnome-extensions install "$INSTALL_ZIP_PATH" || { log_error "Failed to install extension via 'gnome-extensions'."; is_success=1; }

        # Enable the extension using its UUID
        if [ "$is_success" -eq 0 ]; then # Only try to enable if installation seemed okay
            log_info "Enabling extension with UUID: $EXT_UUID"
            gnome-extensions enable "$EXT_UUID" || { log_warn "Failed to enable extension with UUID: $EXT_UUID. It might already be enabled or there's another issue."; }
        fi

        log_info "Cleaning up downloaded zip file: $INSTALL_ZIP_PATH"
        rm -f "$INSTALL_ZIP_PATH"

        if [ "$is_success" -eq 0 ]; then
            log_info "Extension '$EXT_UUID' installed and enabled successfully."
        else
            log_error "Extension '$EXT_UUID' installation or enabling failed."
        fi

    # Fallback for older GNOME or missing 'gnome-extensions' CLI
    else
        log_warn "'gnome-extensions' CLI not found or GNOME Shell version is below 40. Using manual extraction."
        if [ -z "$INSTALL_ZIP_PATH" ]; then
            log_error "Cannot install by ID on older GNOME or without 'gnome-extensions'. Please download the .zip file manually and provide its path. Skipping."
            return 1
        fi

        # Ensure unzip is available
        if ! command -v unzip &> /dev/null; then
            log_error "'unzip' command not found. Please install it (e.g., sudo apt install unzip). Skipping."
            return 1
        fi

        local EXT_TARGET_DIR="$EXTENSIONS_DIR/$EXT_UUID"
        log_info "Extracting '$INSTALL_ZIP_PATH' to '$EXT_TARGET_DIR'..."
        mkdir -p "$EXTENSIONS_DIR" || { log_error "Failed to create extensions directory. Skipping."; return 1; }
        unzip -o "$INSTALL_ZIP_PATH" -d "$EXT_TARGET_DIR" || { log_error "Failed to unzip extension. Skipping."; return 1; }

        log_info "Enabling extension via gsettings with UUID: $EXT_UUID"
        if ! command -v gsettings &> /dev/null; then
            log_error "'gsettings' command not found. Cannot enable extension. Please install 'dconf-cli'. Skipping."
            return 1
        fi

        # Get current enabled extensions
        local CURRENT_ENABLED=$(gsettings get org.gnome.shell enabled-extensions 2>/dev/null)
        if [ -z "$CURRENT_ENABLED" ] || [ "$CURRENT_ENABLED" == "@as []" ]; then
            CURRENT_ENABLED="[]" # Initialize if not set or empty array representation
        fi

        if [[ "$CURRENT_ENABLED" == *"'$EXT_UUID'"* ]]; then
            log_info "Extension '$EXT_UUID' is already listed as enabled."
        else
            # Add the new UUID to the list if not already present
            # Use sed to append before the final ']'
            local NEW_ENABLED=$(echo "$CURRENT_ENABLED" | sed "s/]$/, '$EXT_UUID']/")
            log_info "Adding '$EXT_UUID' to enabled extensions list: $NEW_ENABLED"
            gsettings set org.gnome.shell enabled-extensions "$NEW_ENABLED" || log_warn "Failed to update enabled-extensions gsettings key."
        fi

        log_info "Cleaning up downloaded zip file: $INSTALL_ZIP_PATH"
        rm -f "$INSTALL_ZIP_PATH"

        log_info "Extension '$EXT_UUID' installed successfully (manual method)."
        log_info "You MUST restart GNOME Shell (Alt+F2 then 'r' then Enter) or log out/in."
    fi

    echo "" # Newline for readability between extensions
    return 0 # Indicate success for this specific extension
}


# --- Main Script Logic ---

# Check for help argument first
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
fi

# Determine installation mode based on arguments
INSTALL_MODE="single" # Default mode is single
MAIN_ARG="$1"         # Capture the first argument
OPTIONAL_GNOME_VERSION="$2" # Capture the second argument

if [ -z "$MAIN_ARG" ]; then
    # No arguments provided at all, so default to installing the hardcoded list
    INSTALL_MODE="list"
    # OPTIONAL_GNOME_VERSION would be empty here, as no args were given
elif [ "$MAIN_ARG" == "--install-all" ]; then
    # Explicitly requested to install the hardcoded list
    INSTALL_MODE="list"
    # OPTIONAL_GNOME_VERSION is already captured as $2
fi
# If neither of the above, INSTALL_MODE remains "single" and $MAIN_ARG is the extension input.


# Get GNOME Shell version for the entire run
# Use the captured optional version for the run, if provided.
GNOME_SHELL_VER=$(get_gnome_shell_version "$OPTIONAL_GNOME_VERSION")
if [ $? -ne 0 ]; then
    log_error "Aborting script due to unresolvable GNOME Shell version."
    exit 1
fi
log_info "GNOME Shell Version detected for this run: $GNOME_SHELL_VER"


if [ "$INSTALL_MODE" == "list" ]; then
    if [ ${#EXTENSIONS_TO_INSTALL[@]} -eq 0 ]; then
        log_warn "No extensions hardcoded in the EXTENSIONS_TO_INSTALL list. Nothing to do."
        exit 0
    fi
    log_info "Attempting to install all hardcoded extensions from the list."
    for ext_id in "${EXTENSIONS_TO_INSTALL[@]}"; do
        install_and_enable_extension "$ext_id" "$GNOME_SHELL_VER"
    done
    log_info "All listed extensions processed. Review logs above for individual results."
    log_info "Remember to restart GNOME Shell (Alt+F2 then 'r' then Enter) or log out and back in."

elif [ "$INSTALL_MODE" == "single" ]; then
    # In single mode, MAIN_ARG holds the extension ID/path
    install_and_enable_extension "$MAIN_ARG" "$GNOME_SHELL_VER"
    log_info "Single extension installation process completed."

fi

log_info "Script finished."
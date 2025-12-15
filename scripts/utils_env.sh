#!/usr/bin/env bash


get_config_env_file() {
    # Allow override at runtime; otherwise default to scripts/config.env next to the script.
    if [[ -n "${CONFIG_ENV_FILE:-}" ]]; then
        printf '%s' "$CONFIG_ENV_FILE"
        return 0
    fi

    # Prefer SCRIPT_DIR if the caller defined it.
    if [[ -n "${SCRIPT_DIR:-}" ]]; then
        printf '%s' "$SCRIPT_DIR/config.env"
        return 0
    fi

    # Fallback: resolve relative to this helper.
    local helper_dir
    helper_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    printf '%s' "$helper_dir/config.env"
}

load_config_env() {
    # Sources the config env file if it exists.
    #
    # If you need CLI env vars to override config values, you can add preservation
    # logic later; for now we keep this intentionally straightforward.
    local cfg_file
    cfg_file="$(get_config_env_file)"

    [[ -f "$cfg_file" ]] || return 0

    # shellcheck source=/dev/null
    source "$cfg_file"
}

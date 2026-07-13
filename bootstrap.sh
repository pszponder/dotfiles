#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "mac"
            ;;
        Linux)
            echo "linux"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            echo "windows"
            ;;
        *)
            echo "unsupported"
            ;;
    esac
}

main() {
    local os
    local bootstrap_script

    os="$(detect_os)"
    bootstrap_script="$SCRIPTS_DIR/bootstrap_${os}.sh"

    if [[ "$os" == "unsupported" ]]; then
        echo "Unsupported operating system: $(uname -s)" >&2
        exit 1
    fi

    if [[ ! -f "$bootstrap_script" ]]; then
        echo "Bootstrap script not found: $bootstrap_script" >&2
        exit 1
    fi

    echo "Detected operating system: $os"
    echo "Running: $bootstrap_script"

    bash "$bootstrap_script"
}

main "$@"
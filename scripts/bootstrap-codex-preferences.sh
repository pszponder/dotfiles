#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
preferences="$script_dir/../config/codex-preferences.toml"
codex_home=${CODEX_HOME:-${HOME:?HOME must be set}/.codex}
config="$codex_home/config.toml"

if [[ -L $codex_home || -L $config ]]; then
	printf 'Refusing to update symlink: %s\n' "$config" >&2
	exit 1
fi

taplo lint --no-auto-config --no-schema "$preferences"
if [[ -e $config ]]; then
	taplo lint --no-auto-config --no-schema "$config"
	if taplo get --file-path "$config" --output-format json tui.status_line >/dev/null 2>&1; then
		printf 'Keeping existing Codex status bar: %s\n' "$config"
		exit 0
	fi
fi

mkdir -p -- "$codex_home"
temporary=$(mktemp "$codex_home/.config-XXXXXX.toml")
trap 'rm -f -- "$temporary"' EXIT

# Extract the managed key with a TOML parser; do not copy arbitrary settings.
status_line=$(taplo get --file-path "$preferences" --output-format toml tui.status_line)
if [[ -e $config ]]; then
	# Insert into a conventional [tui] table, preserving the original text.
	# If absent, append the table. Validation below rejects unsupported layouts
	# (such as an inline tui table) without changing the existing file.
	awk -v preference="status_line = $status_line" '
		{ print }
		/^[ \t]*\[[ \t]*(tui|"tui"|\047tui\047)[ \t]*\][ \t]*(#.*)?$/ {
			print preference
			inserted = 1
		}
		END {
			if (!inserted) {
				print "\n[tui]"
				print preference
			}
		}
	' "$config" >"$temporary"
else
	printf '[tui]\nstatus_line = %s\n' "$status_line" >"$temporary"
fi

taplo lint --no-auto-config --no-schema "$temporary"
mv -- "$temporary" "$config"
printf 'Added missing Codex preferences: %s\n' "$config"

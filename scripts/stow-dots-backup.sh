#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo=$(cd -- "$script_dir/.." && pwd)
target=${HOME:?HOME must be set}
target=$(cd -- "$target" && pwd -P)
# shellcheck source=scripts/logging.sh
source "$script_dir/logging.sh"

run_stow_simulation() {
	local diagnostics=$1

	stow --simulate --verbose=2 --target="$target" --dir="$repo" dots >"$diagnostics" 2>&1
}

parse_conflicts() {
	local diagnostics=$1

	mapfile -t conflicts < <(
		sed -n \
			-e 's/.*existing target is not owned by stow: //p' \
			-e 's/.* over existing target \(.*\) since neither a link nor a directory and --adopt not specified/\1/p' \
			"$diagnostics" | sort -u
	)
	if ((${#conflicts[@]} == 0)); then
		while IFS= read -r line; do
			log_error "$line"
		done <"$diagnostics"
		log_error "Could not identify Stow conflicts; nothing was moved."
		return 1
	fi
	log_warn "Found ${#conflicts[@]} Stow conflict(s)."
}

normalize_conflict_path() {
	local path=$1
	local absolute

	path=${path#\'}
	path=${path%\'}
	path=${path#\`}
	path=${path%\`}
	path=${path#\"}
	path=${path%\"}

	if [[ $path == /* ]]; then
		absolute=$path
	else
		absolute="$target/$path"
	fi
	if [[ $absolute != "$target"/* ]]; then
		log_error "Refusing conflict path outside target: $path"
		return 1
	fi
	case "/$path/" in
	*/../* | */./*)
		log_error "Refusing non-normal conflict path: $path"
		return 1
		;;
	esac
	if [[ ! -e $absolute && ! -L $absolute ]]; then
		log_error "Conflict path no longer exists: $absolute"
		return 1
	fi

	printf '%s\n' "$absolute"
}

validate_conflicts() {
	local index
	local normalized

	for index in "${!conflicts[@]}"; do
		normalized=$(normalize_conflict_path "${conflicts[index]}") || return 1
		conflicts[index]=$normalized
	done
}

backup_conflicts() {
	local backup_root="$target/.dotfiles-backup"
	local backup
	local source
	local relative
	local destination

	mkdir -p -- "$backup_root"
	backup=$(mktemp -d -- "$backup_root/$(date +%Y%m%d-%H%M%S)-XXXXXX")

	for source in "${conflicts[@]}"; do
		relative=${source#"$target"/}
		destination="$backup/$relative"
		mkdir -p -- "$(dirname -- "$destination")"
		mv -- "$source" "$destination"
		log_success "Backed up $source -> $destination"
	done
	log_info "Backups are stored in $backup."
}

stow_dots() {
	stow --target="$target" --dir="$repo" dots
}

main() {
	diagnostics=$(mktemp)
	trap 'rm -f -- "$diagnostics"' EXIT

	if run_stow_simulation "$diagnostics"; then
		log_info "No conflicts; creating dotfile symlinks."
		stow_dots
		log_success "Dotfiles stowed."
		return
	fi

	parse_conflicts "$diagnostics"
	validate_conflicts
	backup_conflicts
	stow_dots
	log_success "Dotfiles stowed."
}

main "$@"

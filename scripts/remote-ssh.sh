#!/usr/bin/env bash
set -euo pipefail

url=$(git remote get-url origin)

case "$url" in
git@*:* | ssh://*)
	printf 'origin already uses SSH: %s\n' "$url"
	exit 0
	;;
esac

if [[ $url =~ ^https?://([^/@:]+)/(.*[^/])/?$ ]]; then
	ssh_url="git@${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
else
	printf 'Cannot convert origin URL to SSH: %s\n' "$url" >&2
	exit 1
fi

git remote set-url origin "$ssh_url"
printf 'origin now uses SSH: %s\n' "$ssh_url"

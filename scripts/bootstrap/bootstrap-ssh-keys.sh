#!/bin/sh
set -eu

SSHKEYGEN="$HOME/.local/bin/sshkeygen"

if [ ! -x "$SSHKEYGEN" ]; then
  printf '%s\n' "$SSHKEYGEN not found. Ensure it has been applied by chezmoi." >&2
  exit 1
fi

DEFAULT_KEYS="
ed25519|$HOME/.ssh|default|default key
ed25519|$HOME/.ssh/github/pszponder|personal|github pszponder
"

printf '%s\n' "$DEFAULT_KEYS" | while IFS='|' read -r key_type key_dir key_name key_comment; do
  [ -n "$key_type" ] || continue
  key_path="${key_dir}/${key_name}"

  if [ -f "$key_path" ]; then
    printf '%s\n' "Skipping existing key: $key_path"
    continue
  fi

  "$SSHKEYGEN" -t "$key_type" -d "$key_dir" -n "$key_name" -c "$key_comment" -a
done
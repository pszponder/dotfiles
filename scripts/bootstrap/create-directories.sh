#!/bin/sh
set -eu

DEFAULT_DIRS="
$HOME/repos/github/pszponder
$HOME/resources/courses
$HOME/resources/books
$HOME/resources/datasets
$HOME/resources/cheatsheets
$HOME/resources/notes
$HOME/scratch
"

printf '%s\n' "$DEFAULT_DIRS" | while IFS= read -r directory; do
  [ -n "$directory" ] || continue
  mkdir -p "$directory"
done
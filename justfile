set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Show available recipes when just is run without arguments.
default:
    @just --list

# Switch origin from HTTP(S) to SSH.
remote-ssh:
    git remote set-url origin git@github.com:pszponder/dotfiles.git

# Create the default home directory layout.
bootstrap-dirs:
    scripts/bootstrap-dirs.sh

# Generate the default SSH keys without replacing any existing key files.
bootstrap-ssh:
    scripts/bootstrap-ssh.sh

# Add missing Codex preferences while preserving local settings.
bootstrap-codex-preferences:
    bash scripts/bootstrap-codex-preferences.sh

# Set up the home directories, SSH keys, and Codex preferences.
bootstrap: bootstrap-dirs bootstrap-ssh bootstrap-codex-preferences

# Back up conflicting home paths, then create the dotfile symlinks.
stow:
    scripts/stow-dots-backup.sh

# Recreate symlinks for the files in "dots".
restow:
    stow -R dots

# Unlink all files in the "dots" directory.
unstow:
    stow -D dots

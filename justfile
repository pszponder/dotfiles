set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Show available recipes when just is run without arguments.
default:
    @just --list

# Create the default home directory layout.
bootstrap-dirs:
    scripts/bootstrap-dirs.sh

# Generate the default SSH keys without replacing any existing key files.
bootstrap-ssh:
    scripts/bootstrap-ssh.sh

# Set up the home directories and SSH keys.
bootstrap: bootstrap-dirs bootstrap-ssh

# Back up conflicting home paths, then create the dotfile symlinks.
stow:
    scripts/stow-dots-backup.sh

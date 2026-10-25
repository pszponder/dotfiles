set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

# Show available recipes when just is run without arguments.
default:
    @just --list

# Create the default home directory layout from docs/home-directory-structure.md.
bootstrap-dirs:
    mkdir -p ~/repos/github ~/resources ~/scratch

# Generate the default SSH keys without replacing any existing key files.
bootstrap-ssh:
    mkdir -p ~/.ssh/github/pszponder
    chmod 700 ~/.ssh ~/.ssh/github ~/.ssh/github/pszponder
    if [[ ! -e ~/.ssh/default && ! -e ~/.ssh/default.pub ]]; then \
        ssh-keygen -t ed25519 -f ~/.ssh/default -C "default"; \
    else \
        echo "Skipping ~/.ssh/default: a key file already exists"; \
    fi
    if [[ ! -e ~/.ssh/github/pszponder/personal && ! -e ~/.ssh/github/pszponder/personal.pub ]]; then \
        ssh-keygen -t ed25519 -f ~/.ssh/github/pszponder/personal -C "personal-github"; \
    else \
        echo "Skipping ~/.ssh/github/pszponder/personal: a key file already exists"; \
    fi

# Set up the home directories and SSH keys.
bootstrap: bootstrap-dirs bootstrap-ssh

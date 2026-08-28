_default:
    @just --list

_confirm PACKAGE:
    @printf 'Install {{ PACKAGE }}? [y/N] ' >&2; read -r response; case "$response" in [yY]|[yY][eE][sS]) ;; *) printf '%s\n' 'Installation cancelled' >&2; exit 1;; esac

# Install Homebrew and its required system prerequisites.
brew-install:
    @just _confirm Homebrew
    sh scripts/cli/brew_install.sh
    just brew-sync

# Remove Homebrew while preserving the managed Brewfile.
brew-uninstall:
    @just _confirm Homebrew
    sh scripts/cli/brew_uninstall.sh

# Apply the managed ~/.config/homebrew/Brewfile through Homebrew Bundle.
brew-sync:
    sh scripts/cli/brew_sync.sh

# Install Flatpak and configure the Flathub remote on Linux.
flatpak-install:
    @just _confirm Flatpak
    sh scripts/cli/flatpak_install.sh
    just flatpak-sync

# Remove Flatpak, its installed applications, and the Flathub remote.
flatpak-uninstall:
    @just _confirm Flatpak
    sh scripts/cli/flatpak_uninstall.sh

# Install the applications in the managed Flatpak manifest.
flatpak-sync:
    sh scripts/cli/flatpak_sync.sh

# Download the managed Nerd Fonts without requiring Homebrew.
nerd-fonts-install:
    @just _confirm "Nerd Fonts"
    sh scripts/cli/nerd_fonts_install.sh

# Install mise through Homebrew when available, otherwise from mise.run.
mise-install:
    @just _confirm mise
    sh scripts/cli/mise_install.sh
    just mise-sync

# Remove mise while preserving its managed configuration.
mise-uninstall:
    @just _confirm mise
    sh scripts/cli/mise_uninstall.sh

# Install and reshim the runtimes in the managed mise configuration.
mise-sync:
    sh scripts/cli/mise_sync.sh
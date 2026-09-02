.DEFAULT_GOAL := help

.PHONY: help \
	brew-install brew-uninstall brew-sync \
	flatpak-install flatpak-uninstall flatpak-sync \
	nerd-fonts-install \
	mise-install mise-uninstall mise-sync \
	_confirm

help:
	@awk 'BEGIN {FS = ":.##"; printf "Available targets:\n"} /^[a-zA-Z0-9_-]+:.##/ {printf " %-22s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

_confirm:
	@printf 'Install $(PACKAGE)? [y/N] ' >&2; \
	read -r response; \
	case "$$response" in \
		[yY]|[yY][eE][sS]) ;; \
		*) printf '%s\n' 'Installation cancelled' >&2; exit 1 ;; \
	esac

brew-install: ## Install Homebrew and its required system prerequisites.
	@$(MAKE) _confirm PACKAGE=Homebrew
	sh scripts/cli/brew_install.sh
	$(MAKE) brew-sync

brew-uninstall: ## Remove Homebrew while preserving the managed Brewfile.
	@$(MAKE) _confirm PACKAGE=Homebrew
	sh scripts/cli/brew_uninstall.sh

brew-sync: ## Apply the managed ~/.config/homebrew/Brewfile through Homebrew Bundle.
	sh scripts/cli/brew_sync.sh

flatpak-install: ## Install Flatpak and configure the Flathub remote on Linux.
	@$(MAKE) _confirm PACKAGE=Flatpak
	sh scripts/cli/flatpak_install.sh
	$(MAKE) flatpak-sync

flatpak-uninstall: ## Remove Flatpak, its installed applications, and the Flathub remote.
	@$(MAKE) _confirm PACKAGE=Flatpak
	sh scripts/cli/flatpak_uninstall.sh

flatpak-sync: ## Install the applications in the managed Flatpak manifest.
	sh scripts/cli/flatpak_sync.sh

nerd-fonts-install: ## Download the managed Nerd Fonts without requiring Homebrew.
	@$(MAKE) _confirm PACKAGE="Nerd Fonts"
	sh scripts/cli/nerd_fonts_install.sh

mise-install: ## Install mise through Homebrew when available, otherwise from mise.run.
	@$(MAKE) _confirm PACKAGE=mise
	sh scripts/cli/mise_install.sh
	$(MAKE) mise-sync

mise-uninstall: ## Remove mise while preserving its managed configuration.
	@$(MAKE) _confirm PACKAGE=mise
	sh scripts/cli/mise_uninstall.sh

mise-sync: ## Install and reshim the runtimes in the managed mise configuration.
	sh scripts/cli/mise_sync.sh
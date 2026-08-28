## Features
- [ ] Add applications
    - [ ] handy (speech to text)
    - [ ] [sbx](https://www.docker.com/products/docker-sandboxes/)
    - [ ] [nubjs](https://nubjs.com/)
    - [ ] Ghostty terminal on linux
    - [ ] [Claude Powerline](https://www.npmjs.com/package/@owloops/claude-powerline)
  - [ ] [postcard - email client](https://postcard.gxanshu.in/)
- Review comments in codebase, the comments seem pretty wordy, can they be simplified in places without loosing meaning?
- [ ] Add a utility script into ./scripts directory for logging (copy the logging template in `.chezmoitemplates`)
- [ ] Add Ghostty [Quick Terminal](https://dbushell.com/2025/04/11/ghostty-macos-quick-terminal/) (do I need quick terminal If using hyprland, can I just toggle a floating scratchpad terminal instead?)

## Omarchy
- [ ] Changing the Global Omarchy Font changes the `font-family` in Ghostty config (this is due to `bin/omarchy-font-set` script from omarchy)
  - [ ] This maybe is ok? I can set the global font to anything I want (it also works for fonts installed through pacman)
  - [ ] How will this dynamic overwrite affect my chezmoi dotfiles though? Maybe if on omarchy, just don't set the font?
- [ ] Changing the Global Omarchy Text Size also changes the Ghostty config's `font-size` (this is due to `bin/omarchy-display-text-size` script from omarchy)
- [ ] [Dotfiles — The Omarchy Manual](https://omarchy.org/manual/dotfiles/)
- [ ] [Common tweaks — The Omarchy Manual](https://omarchy.org/manual/common-tweaks/)
- [ ] [Branding — The Omarchy Manual](https://omarchy.org/manual/branding/)
- [ ] [Web Apps — The Omarchy Manual](https://omarchy.org/manual/web-apps/)
- [ ] [Commercial apps/services — The Omarchy Manual](https://omarchy.org/manual/commercial-apps-services/)
- [ ] [GUIs — The Omarchy Manual](https://omarchy.org/manual/guis/)
- [ ] [Browsers — The Omarchy Manual](https://omarchy.org/manual/browsers/)
- [ ] Install nerd fonts
- [ ] Configure window switching with alt-tab
- [ ] Are my dotfiles compatible with Omarchy? If not, what changes are needed to make them compatible?
- [ ] [typecraft - You installed Omarchy, Now What?](https://www.youtube.com/watch?v=d23jFJmcaMI)
    - [ ] [typecraft-dev/omarchy-supplement](https://github.com/typecraft-dev/omarchy-supplement)
- [ ] Add Omarchy Debloat script(s)
- [ ] Create a bootstrap script for omarchy and use the `omarchy pkg add` or `omarchy pkg-aur-add` to install  system level / global packages
- [ ] Think about installing system level / global packages (like eza, fzf, just, etc.) using the system package manager and mise on project-level packages
  - [ ] Should we add another `config.omarchy.toml.tmpl` file to only run if Omarchy is detected? This would allow us to have Omarchy-specific configuration that only runs when Omarchy is detected, and not on other systems. Or maybe if not omarchy-specific, arch-specific
- [ ] Review the default dotfiles omarchy adds to `~/.config` and determine if I want to incorporate them into my dotfiles
  - [ ] [bashrc](https://github.com/basecamp/omarchy/blob/quattro/default/bashrc)
  - [ ] btop
  - [ ] ghostty
    - [ ] Turn config into config.tmpl and check if on omarchy or not to set color theme
  - [ ] git
  - [ ] herdr
  - [ ] hypr (should we overwrite or merge with our own hyprland config?)
  - [ ] kitty
  - [ ] lazygit
  - [ ] obsidian
  - [ ] opencode
  - [ ] tmux
  - [ ] starship
  - [ ]

```
chezmoi has no built-in "is this Omarchy" detection — Omarchy isn't a distro, it's an Arch layer, so .chezmoi.osRelease will just report Arch (ID=arch), not Omarchy. But you can easily detect it yourself in a chezmoi template or script, since Omarchy leaves clear markers:

- Env var: {{ if env "OMARCHY_PATH" }} — set by the uwsm session, present whenever you're actually in an Omarchy session.
- Filesystem: check for /usr/share/omarchy or run test -d /usr/share/omarchy in a run_onchange_/template — works even outside a live session (e.g. during provisioning before login).
- Command presence: {{ if lookPath "omarchy" }} (chezmoi template function) or shell out to omarchy-cmd-present omarchy.

Most practical pattern for your dotfiles repo: use .chezmoi.toml.tmpl to set a custom template variable like {{ $isOmarchy := (stat "/usr/share/omarchy") }} or check the env var, then gate Omarchy-specific config blocks (hyprland, waybar/quickshell configs, theme templates, etc.) behind that variable so the same chezmoi source works on non-Omarchy machines too.
```

- [ ] Review the omarchy update script, how does it update mise?
- [ ] Omarchy CLI commands can be found here: [omarchy/bin at quattro](https://github.com/basecamp/omarchy/tree/quattro/bin)
- [ ] Omarchy config files (copied to `~/.config`) can be found here: [omarchy/config at quattro](https://github.com/basecamp/omarchy/tree/quattro/config)
- [ ] Review omarchy `~/.local/bin/` to understand mise stubs [AI — The Omarchy Manual](https://omarchy.org/manual/ai/)
- [ ] Understand what `omarchy-mise-install <package> [command-name]` works
    - [ ] Omarchy's `omarchy-mise-install` creates a script which will install a package using mise with `MISE_MINIMUM_RELEASE_AGE=0`. This actually is removing a safety built into mise so when di want to install packages with mise, it's better to just run `mise install -g ...` or `mise install` and reference a `~/.config/mise/config.toml`
- [ ] Search omarchy repo and find the agent skills for omarchy to add to my dotfiles repo
- [ ] omawrite, add line numbers?
- [ ] Bug in Omawrite, when opening or saving, the file explorer is opened on the side, with part of the explorer not even on the screen, and I have to use the mouse to move it to the center
- [ ] Invert mouse scrolling
- [ ] Get rid of spacing between windows
- [ ] Rounded corners?
- [ ] [omarchy/bin/omarchy-remove-preinstalls](https://github.com/basecamp/omarchy/blob/quattro/bin/omarchy-remove-preinstalls)
    - [ ] which items are uninstalled?
        - [ ] Uninstalls all TUIs ([TUIs — The Omarchy Manual](https://omarchy.org/manual/tuis/))
        - [ ] Uninstalls all Webapps ([Web Apps — The Omarchy Manual](https://omarchy.org/manual/web-apps/))
    - [ ] I could also use this as a base for my debloat script (only remove things that I really don't want)
        - [ ] HEY
        - [ ] Basecamp
        - [ ] WhatsApp
        - [ ] OBS Studio
        - [ ] Kdenlive
- [ ] [The Top Bar — The Omarchy Manual](https://omarchy.org/manual/the-top-bar/)
    - [ ] Auto-hide top menu bar?
    - [ ] Add currently active window description in top menu bar
    - [ ] Enable transparency
- [ ] add "omarchy update" to the "up" alias?
- [ ] Setup night light to turn on [automatically](https://omarchy.org/manual/toggles-idle-screensaver/#night-light)?
- [ ] Change direction of scrolling (natural scrolling?) [Keyboard, Mouse, Trackpad — The Omarchy Manual](https://omarchy.org/manual/keyboard-mouse-trackpad/)
- [ ] Incoporate Tmux layout functions into dotfiles
- [ ] Set nvim alias as n
    - [ ] only use one nvim config
- [ ] Port omarchy nvim into dotfiles?
- [ ] Figure out how to use [Neovim for sudo edits](https://omarchy.org/manual/neovim/#using-neovim-for-sudo-edits)
- [ ] alias fzf to ff
- [ ] review eza aliases
    - [ ] lt for 2-level tree
    - [ ] lsa for listing everything, including hidden files
    - [ ] lta for nested listing with hidden files
- [ ] Install [GitHub - tobi/try: fresh directories for every vibe · GitHub](https://github.com/tobi/try)
- [ ] Add shell functions to dotfiles: [Shell Functions — The Omarchy Manual](https://omarchy.org/manual/shell-functions/)
- [ ] [Common tweaks — The Omarchy Manual](https://omarchy.org/manual/common-tweaks/)
- [ ] Setup [CLIAMP — Terminal Music Player](https://www.cliamp.stream/) with my preferred youtube / youtube music / spotify channels, etc.

- [ ] create a new branch in dotfiles which clones the main branch (call it the nix branch)
    - [ ] Move nix todos to it's own TODOS_nix.md
- [ ] Then switch back to the main branch and remove all references to NIX

## Bugfixes

## Uncategorized

- [ ] Use AI to review [TheBlackDon - Bazzite: You are WRONG its not Restricted at all!](https://gitlab.com/theblackdon/dcli-bootc) and extract how to create a custom image (make my own version so that I understand it) should this be part of my dotfiles / justfiles?
- [ ] https://cadu.dev/running-neovim-on-devcontainers/
- [ ] https://www.youtube.com/watch?v=rqpiVgWZBOg&t=130s
- [ ] https://github.com/rio/dotfiles
- [ ] distrobox?
- [ ] [From Dotfiles to Portable Dev Environments](https://dakaiser.substack.com/p/from-dotfiles-to-portable-dev-environments)
- [ ] Review [archinstall](https://nickjanetakis.com/blog/walking-through-a-minimal-arch-linux-set-up-with-archinstall)
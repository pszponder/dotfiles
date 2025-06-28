# Chezmoi - Dotfiles Manager

## Installing Chezmoi

**NOTE:** If you already have a dotfiles repo using chezmoi on GitHub at `https://github.com/$GITHUB_USERNAME/dotfiles`, then you can install chezmoi and your dotfiles with a single command, refer to the next section

```sh
sh -c "$(curl -fsLS get.chezmoi.io)"
```

## Initialize Dotfiles w/ Chezmoi

Use **chezmoi** to clone down your dotfiles repo.
- You can use the **--source** option to specify the source directory chezmoi will use on your local machine
- If you don't specify a source directory, **chezmoi** defaults to `~/.local/share/chezmoi`

```sh
chezmoi init --source ~/repos/github/pszponder/dotfiles git@github.com:pszponder/dotfiles.git
```

If you don't yet have **chezmoi** installed, use the below code snippet instead to install **chezmoi** and clone down your dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --source ~/repos/github/pszponder/dotfiles git@github.com:pszponder/dotfiles.git
```

Now, to apply the dotfiles using **chezmoi**, use `chezmoi apply`

## Making edits to dotfiles

**NOTE**: If you want to make changes to files managed by chezmoi, make sure to make the changes from within the chezmoi repo (`chezmoi cd`)

## Commonly Used Chezmoi Commands

- **chezmoi doctor** - View health / status of chezmoi application
- **chezmoi source-path** - View the source directory used by chezmoi to manage dotfiles
- **chezmoi cd** - cd into the chezmoi source directory
- **chezmoi add** -
- **chezmoi diff** -
- **chezmoi apply** - Applies dotfiles from chezmoi source directory and applies them to your system
- **chezmoi managed** - View a list of files managed by chezmoi

## Resources / References

- [chezmoi](https://www.chezmoi.io/)
- [chezmoi - application order](https://www.chezmoi.io/reference/application-order/)
- [Bootstrap config for chezmoi](https://github.com/twpayne/chezmoi/discussions/4415)
- [running a script within run_once_before script](https://github.com/twpayne/chezmoi/discussions/4421)
- [Chris Titus - Easily moving Linux installs](https://christitus.com/chezmoi/)
- [Automating Development Environments w/ Ansible & Chezmoi](https://www.youtube.com/watch?v=P4nI1VhoN2Y)
- [Conf42 - chezmoi - Dotfiles Manager across multiple machines](https://www.youtube.com/watch?v=JrCMCdvoMAw)
- [typecraft - Automate your dotfiles w/ chezomoi](https://typecraft.dev/tutorial/our-place-chezmoi)
- [Code is Everything - The ultimate dotfiles setup](https://www.youtube.com/watch?v=-RkANM9FfTM)

Dotfile Examples w/ chezmoi
- [twpayne/dotfiles](https://github.com/twpayne/dotfiles)
- [kahowell/dotfiles](https://github.com/kahowell/dotfiles)
- [logandonley/dotfiles](https://github.com/logandonley/dotfiles)
- [felipecrs/dotfiles](https://github.com/felipecrs/dotfiles)
- [songkg7/dotfiles](https://github.com/songkg7/dotfiles)
- [lockszmith/dotfiles](https://code.lksz.me/lksz/dotfiles)
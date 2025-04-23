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
chezmoi init [--source ~/repos/github/pszponder] git@github.com:pszponder/dotfiles.git
```

If you don't yet have **chezmoi** installed, use the below code snippet instead to install **chezmoi** and clone down your dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply --source ~/repos/github/pszponder git@github.com:pszponder/dotfiles.git
```

Now, to apply the dotfiles using **chezmoi**, use `chezmoi apply`

## Commonly Used Chezmoi Commands

- **chezmoi apply** - Applies dotfiles from chezmoi source directory and applies them to your system
- **chezmoi managed** - View a list of files managed by chezmoi

## Resources / References

- [chezmoi](https://www.chezmoi.io/)
- [Chris Titus - Easily moving Linux installs](https://christitus.com/chezmoi/)
- [Automating Development Environments w/ Ansible & Chezmoi](https://www.youtube.com/watch?v=P4nI1VhoN2Y)
- [Conf42 - chezmoi - Dotfiles Manager across multiple machines](https://www.youtube.com/watch?v=JrCMCdvoMAw)
- [typecraft - Automate your dotfiles w/ chezomoi](https://typecraft.dev/tutorial/our-place-chezmoi)
- [Code is Everything - The ultimate dotfiles setup](https://www.youtube.com/watch?v=-RkANM9FfTM)
- [twpayne/dotfiles](https://github.com/twpayne/dotfiles)
- [kahowell/dotfiles](https://github.com/kahowell/dotfiles)
- [logandonley/dotfiles](https://github.com/logandonley/dotfiles)
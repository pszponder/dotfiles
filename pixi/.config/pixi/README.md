# Pixi Package Manager

## Install & Update Global Packages Using pixi

### Installing Global Packages

```bash
# use pixi global install <package1> [<package2>, ... <packageN>]
pixi global install starship
```

Use the below global bash command to install a set of packages used by this dotenv

```bash
pixi global install \
	bat \
	dotnet \
	deno \
	eza \
	fd-find \
	fzf \
	go \
	gh \
	git \
	git-delta \
	httpie \
	just \
	jq \
	lazygit \
	neovim \
	nodejs \
	python \
	ripgrep \
	ruff \
	rust \
	sd \
	starship \
	stow \
	tmux \
	zoxide
```

### Updating Global Packages

```bash
pixi global upgrade-all
```

### Removing Global packages

```bash
pixi global remove <package>
```

```bash
pixi global remove \
	bat \
	dotnet \
	deno \
	eza \
	fd-find \
	fzf \
	go \
	gh \
	git \
	git-delta \
	httpie \
	just \
	jq \
	lazygit \
	neovim \
	nodejs \
	python \
	ripgrep \
	ruff \
	rust \
	sd \
	starship \
	stow \
	tmux \
	zoxide
```


## Resources / References
- [prefix.dev](https://prefix.dev/)
- [pixi installation](https://pixi.sh/latest/)
- [pixi basic usage](https://pixi.sh/latest/basic_usage/)
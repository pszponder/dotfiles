# --------------------------
# File system navigation
# --------------------------
alias l = eza -1 --icons=auto
alias ls = eza --icons=auto
alias ll = eza -lh --group-directories-first --icons=auto
alias la = eza -lha --group-directories-first --icons=auto
alias fd = fdfind
alias cd = z

# Tool shortcuts
alias g = git
alias lzg = lazygit
alias lzd = lazydocker
alias k = kubectl
alias tf = terraform
alias serve = python3 -m http.server

# --------------------------
# Editors
# --------------------------
# Neovim lazy function
def nvim-lazy [] {
    with-env [NVIM_APPNAME="nvim-lazyvim"] { command nvim }
}

# Shortcuts
def nviml [] { nvim-lazy }
def nl [] { nvim-lazy }

# Neovim kickstart function
def nvim-kickstart [] {
    with-env [NVIM_APPNAME="nvim-kickstart"] { command nvim }
}
def nvimk [] { nvim-kickstart }
def nk [] { nvim-kickstart }

# Default nvim
def n [] { nvim-lazy }
def v [] { n }
def vim [] { n }

# Other editors
def svi [] { sudo vi }
def vis [] { nvim +set si }
def spico [] { sudo pico }
def snano [] { sudo nano }


# --------------------------
# Git aliases (Oh My Zsh style)
# --------------------------
alias gst = git status
alias g = git
alias ga = git add
alias gaa = git add --all
alias gapa = git add --patch
alias gau = git add --update
alias gav = git add --verbose
alias gap = git apply
alias gco = git checkout
alias gcb = git checkout -b
alias gb = git branch
alias gba = git branch -a
alias gbd = git branch -d
alias gbD = git branch -D
alias gbl = git blame -b -w
alias gbdnm = git branch --no-merged
alias gbr = git branch --remote
alias gc = git commit -v
alias gc! = git commit -v --amend
alias gca = git commit -v -a
alias gca! = git commit -v -a --amend
alias gcam = git commit -a -m
alias gcas = git commit -a -s
alias gd = git diff
alias gds = git diff --staged
alias gpp = git push
alias gl = git pull
alias gpr = git pull --rebase
alias gprv = git pull --rebase -v
alias ggpush = git push origin "$(git_current_branch)"
alias ggpull = git pull origin "$(git_current_branch)"
alias gstl = git stash list
alias gsta = git stash push
alias gstaa = git stash apply
alias gstp = git stash pop
alias gcl = git clone --recursive
alias gcf = git config --list

# --------------------------
# Docker / Podman
# --------------------------
alias d = docker
alias dc = docker compose
alias p = podman
def docker-clean [] {
    docker container prune -f;
    docker image prune -f;
    docker network prune -f;
    docker volume prune -f
}

# --------------------------
# Misc
# --------------------------
alias cat = bat --paging=never
alias less = bat --paging=always
alias reload = exec $nu.shell-path -l
alias cl = clear
alias cp = cp -i
alias mv = mv -i
alias rm = trash -v
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
alias zmux = zellij -l welcome
alias drink = brew update && brew upgrade && brew cleanup

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
def nvim [] { nvim-lazy }
def n [] { nvim-lazy }
def v [] { nvim-lazy }
def vim [] { nvim-lazy }

# Other editors
def svi [] { sudo vi }
def vis [] { nvim +set si }
def spico [] { sudo pico }
def snano [] { sudo nano }

# --------------
# 🛠 Git aliases
# --------------

# Basic Git Commands
alias g = git
alias gs = git status

alias ga = git add
alias gaa = git add .
alias gap = git add --patch

# Diffing
alias gd = git diff --output-indicator-new=  --output-indicator-old=
alias gds = git diff --staged
alias gdc = git diff --cached
alias gdcw = git diff --cached --word-diff

# Committing
alias gc = git commit
alias gcv = git commit -v
alias gcve = git commit -v --amend

# Commit with message argument
def gcm [message] { git commit --message $message }

alias gcam = git commit -a -m
alias gcad = git commit -a --amend
alias gca = git commit --amend --no-edit
alias gce = git commit --amend

# Branching and Checking Out
alias gb = git branch
alias gba = git branch --all
alias gbr = git branch --remote
alias gbd = git branch -d
alias gbD = git branch -D
alias gbn = git checkout -b

alias gco = git checkout
alias gcb = git checkout -b

alias gsw = git switch
alias gswc = git switch -c

# Show / Logging
alias gl = git log --oneline --graph --decorate --all
alias glog = git log --oneline -1
alias gll = git log --graph --all --pretty=format:%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n
alias glp = git log -p

alias gsh = git show
alias gss = git shortlog
alias gblame = git blame

# Fetch/Pull/Push
alias gf = git fetch

alias gp = git push
alias gpo = git push origin
alias gpof = git push origin --force

alias gu = git pull
alias gur = git pull --rebase

# Stash
alias gst = git stash
alias gstl = git stash list
alias gsts = git stash save
alias gstp = git stash pop
alias gsta = git stash apply
alias gstd = git stash drop

# Remote
alias gr = git remote
alias gra = git remote add
alias grv = git remote -v

# Tagging
alias gt = git tag
alias gts = git tag -s

# Reset/Revert
alias grh = git reset HEAD
alias grhh = git reset --hard HEAD
alias grm = git revert

# Merge/Rebase
alias gm = git merge
alias gmt = git mergetool

alias grb = git rebase
alias grbi = git rebase -i

# Cherry-pick
alias gcp = git cherry-pick

# Clean
alias gcl = git clean -fd

# Misc
alias gcf = git config --list
alias gg = git gui
alias ggi = git gui citool
alias gcount = git shortlog -sn
alias gwho = git shortlog -sn --all
alias gclo = git clone --recursive
alias gi = git init


# # --------------------------
# # Git aliases (Oh My Zsh style)
# # --------------------------
# alias gst = git status
# alias g = git
# alias ga = git add
# alias gaa = git add --all
# alias gapa = git add --patch
# alias gau = git add --update
# alias gav = git add --verbose
# alias gap = git apply
# alias gco = git checkout
# alias gcb = git checkout -b
# alias gb = git branch
# alias gba = git branch -a
# alias gbd = git branch -d
# alias gbD = git branch -D
# alias gbl = git blame -b -w
# alias gbdnm = git branch --no-merged
# alias gbr = git branch --remote
# alias gc = git commit -v
# alias gc! = git commit -v --amend
# alias gca = git commit -v -a
# alias gca! = git commit -v -a --amend
# alias gcam = git commit -a -m
# alias gcas = git commit -a -s
# alias gd = git diff
# alias gds = git diff --staged
# alias gpp = git push
# alias gl = git pull
# alias gpr = git pull --rebase
# alias gprv = git pull --rebase -v
# alias ggpush = git push origin "$(git_current_branch)"
# alias ggpull = git pull origin "$(git_current_branch)"
# alias gstl = git stash list
# alias gsta = git stash push
# alias gstaa = git stash apply
# alias gstp = git stash pop
# alias gcl = git clone --recursive
# alias gcf = git config --list

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
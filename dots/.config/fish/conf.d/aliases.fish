# 🗂 File system navigation
alias l='eza -1 --icons=auto'
alias ls='eza --icons=auto'
alias ll='eza -lh --group-directories-first --icons=auto'
alias la='eza -lha --group-directories-first --icons=auto'

# alias lt='eza --tree --level=2 --long --icons --git'
function lt
    # Set default level to 2 if no argument is provided
    set -l level 2
    if test (count $argv) -ge 1
        set level $argv[1]
    end

    eza --tree --level=$level --long --icons --git
end

alias lta='lt -a'
# alias fd='fdfind'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias mkdir='mkdir -pv'
alias cd='z'

# 📂 Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ..2='cd ../..'
alias ....='cd ../../..'
alias ..3='cd ../../..'
alias .....='cd ../../../..'
alias ..4='cd ../../../..'
alias ..5='cd ../../../../..'
alias ..6='cd ../../../../../..'

alias s='rg --smart-case'
alias sa='rg --smart-case --hidden --no-ignore'  # search all
alias search='rg --smart-case --pretty'

# 🧰 Tool shortcuts
alias g='git'
alias lzg='lazygit'
alias lzd='lazydocker'
alias k='kubectl'
alias tf='terraform'
alias serve='python3 -m http.server'
alias drink='brew update && brew upgrade && brew cleanup'

# Editors
alias nvim-lazy='NVIM_APPNAME=nvim-lazyvim command nvim'
alias nviml='nvim-lazy'
alias nl='nvim-lazy'
alias nvim-kickstart='NVIM_APPNAME=nvim-kickstart command nvim'
alias nvimk='nvim-kickstart'
alias nk='nvim-kickstart'
# alias nvim='NVIM_APPNAME=nvim command nvim'
alias nvim='nviml'
alias n='nviml'
alias v='nviml'
alias vim='nviml'
# alias se='sudo EDITOR=/home/linuxbrew/.linuxbrew/bin/nvim sudoedit'
# alias snvim=se
# alias sv=se
alias svi='sudo vi'
alias vis='nvim "+set si"'
alias spico='sudo pico'
alias snano='sudo nano'

# --------------
# 🛠 Git aliases
# --------------

# Basic Git Commands
alias g='git'
alias gs='git status'

alias ga='git add'
alias gaa='git add .'
alias gap='git add --patch'

# Diffing
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='git diff --staged'
alias gdc='git diff --cached'
alias gdcw='git diff --cached --word-diff'

# Committing
alias gc='git commit'
alias gcv='git commit -v'
alias gcve='git commit -v --amend'
function gcm
    git commit --message "$argv"
end
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'

# Branching and Checking Out
alias gb='git branch'
alias gba='git branch --all'
alias gbr='git branch --remote'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbn='git checkout -b'  # new branch

alias gco='git checkout'
alias gcb='git checkout -b'

alias gsw='git switch'
alias gswc='git switch -c'

# Show / Logging
alias gl='git log --oneline --graph --decorate --all'
alias glog='git log --oneline -1'
alias gll='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias glp='git log -p'

alias gsh='git show'
alias gss='git shortlog'
alias gblame='git blame'

# Fetch/Pull/Push
alias gf='git fetch'

alias gp='git push'
alias gpo='git push origin'
alias gpof='git push origin --force'

alias gu='git pull'
alias gur='git pull --rebase'

# Stash
alias gst='git stash'
alias gstl='git stash list'
alias gsts='git stash save'
alias gstp='git stash pop'
alias gsta='git stash apply'
alias gstd='git stash drop'

# Remote
alias gr='git remote'
alias gra='git remote add'
alias grv='git remote -v'

# Tagging
alias gt='git tag'
alias gts='git tag -s'

# Reset/Revert
alias gr='git reset'
alias grh='git reset HEAD'
alias grhh='git reset --hard HEAD'
alias grm='git revert'

# Merge/Rebase
alias gm='git merge'
alias gmt='git mergetool'

alias grb='git rebase'
alias grbi='git rebase -i'

# Cherry-pick
alias gcp='git cherry-pick'

# Clean
alias gcl='git clean -fd'

# Misc
alias gcf='git config --list'
alias gg='git gui'
alias ggi='git gui citool'
alias gcount='git shortlog -sn'
alias gwho='git shortlog -sn --all'
alias gcl='git clone --recursive'
alias gi='git init'


# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# 🌐 Networking
alias ports='lsof -i -P -n | grep LISTEN'
alias openports='netstat -nape --inet'
alias ip='ip -c a'
alias ping='ping -c 10'
alias wget='wget -c'

# Safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Docker / Podman
alias d='docker'
alias dc='docker compose'
# alias docker='podman'
alias p='podman'
# Cleanup unused docker containers, images, networks, and volumes
alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '

# ⚙️ Miscellaneous
alias cat='bat --paging=never'
alias less='bat --paging=always'
alias reload='exec $SHELL -l'
alias cl='clear'
alias da='date "+%Y-%m-%d %A %T %Z"'
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias ps='ps auxf'
alias up='topgrade -y'

# Retry last command with sudo
function '!!'
    eval commandline -rp | string escape --style=script | xargs sudo fish -c
end

# 🐙 GitHub CLI aliases
alias ghst='gh status'
alias ghissues='gh issue list'
alias ghprs='gh pr list'

# List repositories
alias ghls='gh repo list'                          # List your repos
alias ghlsp='gh repo list --source'                # List only source repos (no forks)
alias ghlsf='gh repo list --fork'                  # List only forked repos
alias ghlspub='gh repo list --visibility public'   # List only public repos
alias ghlspriv='gh repo list --visibility private' # List only private repos

# Create new GitHub repo from current directory and push
function ghnew
    set -l repo_name (basename (pwd))
    if test (count $argv) -ge 1
        set repo_name $argv[1]
    end
    echo "Creating public GitHub repo: $repo_name"
    gh repo create $repo_name --public --source=. --remote=origin --push
end

# Create new private GitHub repo from current directory and push
function ghnewp
    set -l repo_name (basename (pwd))
    if test (count $argv) -ge 1
        set repo_name $argv[1]
    end
    echo "Creating private GitHub repo: $repo_name"
    gh repo create $repo_name --private --source=. --remote=origin --push
end

# Clone repo and cd into it
function ghclone
    if test (count $argv) -eq 0
        echo "Usage: ghclone <repo>"
        return 1
    end
    gh repo clone $argv[1]
    set -l repo_name (basename $argv[1])
    cd $repo_name
end

# Fork a repo and clone it
function ghfork
    if test (count $argv) -eq 0
        echo "Usage: ghfork <repo>"
        return 1
    end
    gh repo fork $argv[1] --clone
    set -l repo_name (basename $argv[1])
    cd $repo_name
end

# Create pull request
function ghpr
    if test (count $argv) -eq 0
        gh pr create --web
    else
        gh pr create --title "$argv[1]" --web
    end
end

# Open current repo in browser
alias ghview='gh repo view --web'
alias ghopen='gh repo view --web'
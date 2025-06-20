# 🗂 File system navigation
alias l='eza -1 --icons=auto'
alias ls='eza --icons=auto'
alias ll='eza -lh --group-directories-first --icons=auto'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias fd='fdfind'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
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

# 🧰 Tool shortcuts
alias n='nvim'
alias g='git'
alias d='docker'
alias dc='docker compose'
alias bat='batcat'
alias lzg='lazygit'
alias lzd='lazydocker'
alias k='kubectl'
alias tf='terraform'
alias serve='python3 -m http.server'

# 🛠 Git aliases
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias gca='git commit --amend --no-edit'
alias gpl='git pull'
alias gp='git push'
alias gstash='git stash'
alias gpop='git stash pop'

# ⬆️ Updates
alias up='~/.local/bin/up.sh'

# 🌐 Networking
alias ports='lsof -i -P -n | grep LISTEN'
alias ip='ip -c a'
alias ping='ping -c 5'
alias wget='wget -c'

# ⚙️ Miscellaneous
alias cat='bat --paging=never'
alias less='bat --paging=always'
alias docker='podman'
alias reload='exec $SHELL -l'
alias cl='clear'

# Retry last command with sudo
function please
    # Only works interactively — grab last history line
    set -l last_cmd (history --max=1 | string trim | string split \n | head -n1)
    if test -n "$last_cmd"
        echo "Running with sudo: $last_cmd"
        eval sudo $last_cmd
    end
end

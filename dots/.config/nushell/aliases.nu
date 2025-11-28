# 🗂 File system navigation
alias l = eza -1 --icons=auto
alias ls = eza --icons=auto
alias ll = eza -lh --group-directories-first --icons=auto
alias la = eza -lha --group-directories-first --icons=auto
alias lta = lt -a
alias fd = fdfind
alias ff = fzf --preview 'bat --style=numbers --color=always {}'
alias mkdir = 'mkdir -pv'
alias cd = z

# 📂 Directory navigation
alias .. = cd ..
alias ... = cd ../..
alias ..2 = cd ../..
alias .... = cd ../../..
alias ..3 = cd ../../..
alias ..... = cd ../../../..
alias ..4 = cd ../../../..
alias ..5 = cd ../../../../..
alias ..6 = cd ../../../../../..

alias s = rg --smart-case
alias sa = rg --smart-case --hidden --no-ignore
alias search = rg --smart-case --pretty

# 🧰 Tool shortcuts
alias g = git
alias lzg = lazygit
alias lzd = lazydocker
alias k = kubectl
alias tf = terraform
alias serve = python3 -m http.server

# Editors
alias n = nvim
alias v = nvim
alias vim = nvim
alias se = sudo EDITOR=/home/linuxbrew/.linuxbrew/bin/nvim sudoedit
alias snvim = se
alias sv = se
alias svi = sudo vi
alias vis = nvim "+set si"
alias spico = sudo pico
alias snano = sudo nano

# 🛠 Git aliases
alias gs = git status
alias ga = git add
alias gaa = git add .
alias gb = git branch
alias gco = git checkout
alias gcb = git checkout -b
alias gl = git log --oneline --graph --decorate
alias gd = git diff
alias gds = git diff --staged
alias gcm = git commit -m
alias gcam = git commit -a -m
alias gcad = git commit -a --amend
alias gca = git commit --amend --no-edit
alias gpl = git pull
alias gp = git push
alias gstash = git stash
alias gpop = git stash pop

# chmod aliases
alias mx = chmod a+x
alias 000 = chmod -R 000
alias 644 = chmod -R 644
alias 666 = chmod -R 666
alias 755 = chmod -R 755
alias 777 = chmod -R 777

# 🌐 Networking
alias ports = lsof -i -P -n | grep LISTEN
alias openports = netstat -nape --inet
alias ip = ip -c a
alias ping = ping -c 10
alias wget = wget -c

alias rebootsafe = sudo shutdown -r now
alias rebootforce = sudo shutdown -r -n now

alias diskspace = du -S | sort -n -r | more
alias folders = du -h --max-depth=1
alias folderssort = find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn
alias tree = tree -CAhF --dirsfirst
alias treed = tree -CAFd
alias mountedinfo = df -hT

# Archives
alias mktar = tar -cvf
alias mkbz2 = tar -cvjf
alias mkgz = tar -cvzf
alias untar = tar -xvf
alias unbz2 = tar -xvjf
alias ungz = tar -xvzf

alias logs = sudo find /var/log -type f | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f

# Docker / Podman
alias d = docker
alias dc = docker compose
# alias docker = podman
alias p = podman
alias docker-clean = do {
  docker container prune -f;
  docker image prune -f;
  docker network prune -f;
  docker volume prune -f
}

# ⚙️ Miscellaneous
alias cat = bat --paging=never
alias less = bat --paging=always
alias reload = exec $nu.shell-path -l
alias cl = clear
alias da = date "+%Y-%m-%d %A %T %Z"
alias cp = cp -i
alias mv = mv -i
alias rm = trash -v
alias ps = ps auxf

# IP
alias whatismyip = whatsmyip
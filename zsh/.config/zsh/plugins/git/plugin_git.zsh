#!/usr/bin/env zsh

# Based from: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

# +-----------+
# | FUNCTIONS |
# +-----------+

# Abort current changes and reset to HEAD
# Cancel any rebase in progress
# USAGE: gnah
# https://laravel-news.com/the-ultimate-git-nah-alias?ref=dailydev
function gnah() {
	git reset --hard
	git clean -df
	if [ -d ".git/rebase-apply" ] || [ -d ".git/rebase-merge" ]; then
			git rebase --abort
	fi
}

# Rename the current branch (local and remote)
# USAGE: grename <old_branch_name> <new_branch_name>
function grename() {
	if [[ -z "$1" || -z "$2" ]]; then
		echo "Usage: $0 old_branch new_branch"
		return 1
	fi

	# Rename branch locally
	git branch -m "$1" "$2"
	# Rename branch in origin remote
	if git push origin :"$1"; then
		git push --set-upstream origin "$2"
	fi
}

# Function `current_branch`:
# Retrieves the name of the current Git branch.
# Usage:
# Call this function to get the name of the current branch.
# Example:
#   branch_name=$(current_branch)
function current_branch() {
  git_current_branch
}

# Function `git_develop_branch`:
# Checks for the existence of develop or similarly named branches in the Git repository.
# Returns the name of the develop branch if found, or "develop" as a fallback.
# Usage:
# Call this function to determine the name of the develop branch.
# Example:
#   develop_branch=$(git_develop_branch)
function git_develop_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in dev devel develop development; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return 0
    fi
  done

  echo develop
  return 1
}

# Function `git_main_branch`:
# Checks for the existence of main or similarly named branches in the Git repository.
# Returns the name of the main branch if found, or "master" as a fallback.
# Usage:
# Call this function to determine the name of the main branch.
# Example:
#   main_branch=$(git_main_branch)
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done

  # If no main branch was found, fall back to master but return error
  echo master
  return 1
}

# Function `ggpnp`:
# Simplify the process of pulling and pushing changes in a Git repository.
# When called without arguments, it performs both pull and push for the current branch.
# When called with arguments, it performs pull and push for the specified branch(es).
# Usage Examples:
# 1. Pull and push changes for the current branch:
#    ggpnp
# 2. Pull and push changes for a specific branch or branches:
#    ggpnp <branch_name>
#    ggpnp <branch_name_a> <branch_name_b> <branch_name_c> ...
function ggpnp() {
    if [[ "$#" == 0 ]]; then
        # If no arguments are provided, perform both pull and push for the current branch.
        ggl && ggp
    else
        # If one or more arguments are provided, perform pull and push for the specified branch(s).
        ggl "${*}" && ggp "${*}"
    fi
}
compdef _git ggpnp=git-checkout

# Function `ggl`:
# Pull changes from a remote Git repository for a specified branch or the current branch.
# If no branch is provided, it defaults to the current branch.
# Usage Example:
# 1. Pull changes for the current branch:
#    ggl
# 2. Pull changes for a specific branch:
#    ggl <branch_name>
function ggl() {
    if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
        # If one or more arguments are provided, pull changes for the specified branch(s).
        git pull origin "${*}"
    else
        # If no arguments are provided, attempt to pull changes for the current branch.
        # If the current branch is not found, it uses the argument as the branch name.
        [[ "$#" == 0 ]] && local b="$(git_current_branch)"
        git pull origin "${b:=$1}"
    fi
}
compdef _git ggl=git-checkout

# Function `ggp`:
# Push changes to a remote Git repository for a specified branch or the current branch.
# If no branch is provided, it defaults to the current branch.
# Usage Example:
# 1. Push changes for the current branch:
#    ggp
# 2. Push changes for a specific branch:
#    ggp <branch_name>
function ggp() {
    if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
        # If one or more arguments are provided, push changes for the specified branch(s).
        git push origin "${*}"
    else
        # If no arguments are provided, attempt to push changes for the current branch.
        # If the current branch is not found, it uses the argument as the branch name.
        [[ "$#" == 0 ]] && local b="$(git_current_branch)"
        git push origin "${b:=$1}"
    fi
}
compdef _git ggp=git-checkout

# Function `ggu`:
# Simplify the process of pulling and rebasing changes from a remote Git repository.
# When called with an argument, it specifies the branch to pull and rebase from.
# When called without an argument, it defaults to the current branch.
# Usage Example:
# 1. Pull and rebase changes for the current branch:
#    ggu
# 2. Pull and rebase changes for a specific branch:
#    ggu branch_name
function ggu() {
    # Check the number of arguments provided. If not equal to 1, assume the current branch.
    [[ "$#" != 1 ]] && local b="$(git_current_branch)"

    # Perform a pull with rebase from the specified branch or the current branch.
    git pull --rebase origin "${b:=$1}"
}
compdef _git ggu=git-checkout

# Function `work_in_progress`:
# Checks if the current Git branch is a Work-In-Progress (WIP) branch by searching for "--wip--" in the commit message.
# If the branch is a WIP, it displays a warning message.
# Usage:
# Call this function to check if the current branch is a WIP branch.
# Example:
#   work_in_progress
function work_in_progress() {
  # Run a Git command to retrieve the latest commit message from the current branch.
  # The '-c log.showSignature=false' option is used to hide GPG signatures if present.
  # The '-n 1' option fetches only the latest commit.
  # Redirect any error messages to /dev/null.
  command git -c log.showSignature=false log -n 1 2>/dev/null |
    # Use `grep` to search for "--wip--" in the commit message.
    # The '-q' option makes `grep` quiet, so it doesn't output matching lines.
    grep -q -- "--wip--" &&
    # If "--wip--" is found, echo a warning message indicating that it's a WIP branch.
    echo "WIP!!"
}

# Function `gunwip`:
# Prompts the user to remove the "--wip--" marker from the last commit message and perform a force push if desired.
# Usage:
# Call this function to interactively remove "--wip--" from the last commit message and choose whether to force push.
# Example:
#   gunwip  # Prompt to remove "--wip--" and perform a force push if desired
function gunwip() {
  # Check if the last commit message contains "--wip--"
  if git log -1 --pretty=%B | grep -q -- "--wip--"; then
    echo "The last commit message contains '--wip--'."
    read -p "Do you want to remove it (y/N)? " remove_wip

    if [[ "$remove_wip" == "y" || "$remove_wip" == "Y" ]]; then
      # Replace "--wip--" with an empty string in the last commit message
      git commit --amend -m "$(git log -1 --pretty=%B | sed 's/--wip--//g')"

      read -p "Do you want to perform a force push (y/N)? " force_push
      if [[ "$force_push" == "y" || "$force_push" == "Y" ]]; then
        # Forcefully push the changes to the remote repository
        git push --force-with-lease
        echo "The '--wip--' marker has been removed from the last commit, and changes have been pushed forcefully."
      else
        echo "The '--wip--' marker has been removed from the last commit. To push the changes forcefully, run 'git push --force-with-lease'."
      fi
    else
      echo "No changes were made."
    fi
  else
    echo "The last commit message does not contain '--wip--'."
  fi
}

# Function `gunwipall`:
# Recursively removes the "--wip--" marker from commit messages in your branch's commit history
# up to the last commit without "--wip--" while preserving the changes. Prompts for a force push.
# Usage:
# Call this function to rewrite commit messages and remove "--wip--" markers.
# Example:
#   gunwipall
function gunwipall() {
  # Check if there are any commits with "--wip--" in their messages
  if git log --grep="^--wip--" | grep -q "^commit"; then
    # Prompt the user to confirm the removal of "--wip--" messages
    read -p "There are commits with '--wip--' messages. Do you want to remove them (y/N)? " remove_wip

    if [[ "$remove_wip" != "y" && "$remove_wip" != "Y" ]]; then
      echo "No changes have been made."
      return
    fi
  fi

  # Use `git log` to find the last commit without "--wip--" in its message
  last_non_wip_commit=$(git log --reverse --format="%H" --grep="^--wip--" | tail -n 1)

  # Use `git filter-branch` to rewrite commit messages up to the last non-wip commit
  if [ -n "$last_non_wip_commit" ]; then
    git filter-branch --msg-filter 'sed "s/--wip--//g"' --tag-name-filter cat -- $last_non_wip_commit^..HEAD
  else
    echo "No commit without '--wip--' found in the history."
  fi

  # Prompt the user for a force push
  read -p "Do you want to force push the changes to the remote repository (y/N)? " force_push

  if [[ "$force_push" == "y" || "$force_push" == "Y" ]]; then
    # Forcefully push the changes to the remote repository
    git push --force-with-lease
    echo "Changes have been pushed forcefully."
  else
    echo "Changes have been rewritten. To push the changes forcefully, run 'git push --force-with-lease'."
  fi
}

# Function `gbda`:
# Deletes local Git branches that have been merged into the current branch, excluding main and develop branches.
# This helps to clean up old feature or topic branches that are no longer needed.
# Usage:
# Call this function to remove merged branches:
#   gbda
function gbda() {
  # List all local branches that are merged into the current branch,
  # excluding the main and develop branches.
  git branch --no-color --merged | \
    command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | \
    command xargs git branch --delete 2>/dev/null
}

# Function `gbds`:
# Deletes local Git branches that have been merged into the default branch (main or develop).
# This function checks if a branch has been merged by comparing its commit history to the default branch.
# If a branch has been merged, it will be deleted to keep the repository clean.
# Usage:
# Call this function to remove merged branches based on the default branch (main or develop).
# Example:
#   gbds  # Remove merged branches based on the default branch
function gbds() {
  # Determine the default branch, either main or develop, and set it as the reference for branch comparisons.
  local default_branch=$(git_main_branch)
  (( ! $? )) || default_branch=$(git_develop_branch)

  # Iterate through all local branches and check if they have been merged into the default branch.
  # If a branch has been merged, delete it to clean up the repository.
  git for-each-ref refs/heads/ "--format=%(refname:short)" | \
    while read branch; do
      local merge_base=$(git merge-base $default_branch $branch)

      # Use `git cherry` to check if a branch has been merged.
      if [[ $(git cherry $default_branch $(git commit-tree $(git rev-parse $branch\^{tree}) -p $merge_base -m _)) = -* ]]; then
        git branch -D $branch
      fi
    done
}

# Function `gccd`:
# Clone a Git repository, automatically handling various URL formats and submodule cloning.
# This function parses the repository URL from arguments, supports multiple URL formats,
# and handles the cloning of submodules if present in the repository.
# After cloning, it changes the current directory to the target directory.
# Usage:
# Call this function with a Git repository URL to clone it.
# Example:
#   gccd https://github.com/username/repo.git  # Clone a Git repository
#   gccd git@github.com/username/repo.git  # Clone a Git repository
function gccd() {
  # Enable local options and extended globbing for parsing the repository URL.
  setopt localoptions extendedglob

  # Extract the repository URL from the arguments based on valid formats.
  # The regular expression used here supports common Git repository URL formats.
  local repo="${${@[(r)(ssh://*|git://*|ftp(s)#://*|http(s)#://*|*@*)(.git/#)#]}:-$_}"

  # Clone the Git repository and its submodules, if present.
  # Exit if the cloning process fails.
  command git clone --recurse-submodules "$@" || return

  # Determine the target directory for the cloned repository.
  # If the last argument passed was a directory, that's where the repo was cloned.
  # Otherwise, parse the repo URL and use the last part as the directory.
  if [[ -d "$_" ]]; then
    cd "$_"
  else
    cd "${${repo:t}%.git/#}"
  fi
}
compdef _git gccd=git-clone

# +---------+
# | ALIASES |
# +---------+
alias g='git'

# Navigate (cd) to the root of the current git repository
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# ======
# STATUS
# ======
alias gst='git status'
alias gss='git status --short'
alias gssb='git status --short --branch'

# ============
# ADDING FILES
# ============
alias ga='git add'
alias gaa='git add --all' # Add all files
alias gap='git add --patch' # Add file interactively
alias gau='git add --update' # Only add changes made to already tracked files
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip--"' # Add all unstaged files and commit with "--wip--"

# ========
# BRANCHES
# ========

# +------------------+
# | Listing Branches |
# +------------------+
alias gb='git branch' # List all branches (local), or create a new branch (by passing a new branch name)
alias gbr='gb --remote' # List all branches (remote)
alias gba='gb --all' # List all branches (local and remote)
alias gblnr='LANG=C git branch -vv | grep ": gone\]"' # List local branches that have been deleted on the remote repository
alias gbnm='git branch --no-merged' # list branches that have not been merged into the current branch

# +-------------------------------+
# | Creating / Switching Branches |
# +-------------------------------+
alias gbs='git switch' # Switch to a branch
alias gbsc='gbs -c' # Create a new branch and switch to it
alias gbsd='git switch $(git_develop_branch)' # Switch to the default development branch (e.g., 'develop' or 'main')
alias gbco='git checkout' # Checkout a Git branch
alias gbcor='git checkout --recurse-submodules' # Checkout a branch and its submodules
alias gbcod='git checkout $(git_develop_branch)' # Checkout the default development branch (e.g., 'develop' or 'main')
# alias gsw='git switch'
# alias gswc='git switch --create'
# alias gswd='git switch $(git_develop_branch)'
# alias gswm='git switch $(git_main_branch)'

# +----------------------------+
# | Moving / Renaming Branches |
# +----------------------------+
alias gbm='gb --move' # Move / rename git branch (pass in current and new branch names)

# +-------------------+
# | Deleting Branches |
# +-------------------+
alias gbld='gb --delete' # Delete a local branch
alias gblD='gb --delete --force' # Force delete a local branch
alias gblnrd='LANG=C git branch --no-color -vv | grep ": gone\]" | awk '"'"'{print $1}'"'"' | xargs git branch -d' # Delete local branches that are no longer available on the remote repository
alias gblnrD='LANG=C git branch --no-color -vv | grep ": gone\]" | awk '"'"'{print $1}'"'"' | xargs git branch -D' # Forcefully delete local branches that are no longer available on the remote repository

# +------------------------+
# | Misc Branch Operations |
# +------------------------+
alias gwipcheck="work_in_progress" # Check if the current branch is a WIP branch
alias gbsup='git branch --set-upstream-to=origin/$(git_current_branch)' # Setup upstream tracking for current branch to origin/<current_branch>
alias gbclean='git clean --interactive -d' # Interactively clean untracked files and directories from the working directory

# ==========
# COMMITTING
# ==========
# NOTE: aliases ending w/ ! will overwrite the previous commit (amend)
alias gc="git commit -v" # Commit with verbose messaging
alias gca="gc --all" # Commit all staged/unstaged changes
alias "gca!"="gca --amend" # Amend previous commit w/ all staged/unstaged changes
alias gcm="gc --message" # Commit with commit message
alias "gcm!"="gc --amend --message" # Amend previous commit w/ new commit message
alias gcam="gca --message" # Commit all staged/unstaged changes with commit message
alias "gcam!"=" gca --amend --message" # Amend previous commit w/ new commit message
alias "gcn!"="gc --no-edit" # Amend previous commit w/ same commit message
alias "gcan!"="gca --no-edit" # Amend previous commit w/ same commit message and all staged/unstaged changes

# +------------------------+
# | Cherry Picking Commits |
# +------------------------+
alias gcp='git cherry-pick' # Cherry-pick a commit onto the current branch
alias gcpa='git cherry-pick --abort' # Abort a cherry-pick operation
# Continue a cherry-pick operation after resolving conflicts
alias gcpc='git cherry-pick --continue' # Continue a cherry-pick operation after resolving conflicts

# ====
# DIFF
# ====
alias gd='git diff' # Show unstaged changes between your index and working directory
alias gdca='git diff --cached' # Show changes between commits, commit and working tree, etc
alias gdcw='git diff --cached --word-diff' # Show changes between commits, commit and working tree, etc with word-level granularity
alias gds='git diff --staged' # Show changes between the index and the HEAD(which is the last commit on this branch)
alias gdw='git diff --word-diff' # Show changes between the index and the HEAD(which is the last commit on this branch) with word-level granularity
alias gdup='git diff @{upstream}' # Alias to view Git diff with the upstream branch
alias gdt='git diff-tree --no-commit-id --name-only -r' # Alias to view Git diff-tree

# Function to view Git diff with word-level granularity
gdv() {
  git diff -w "$@" | view -
}
compdef _git gdv=git-diff

# Function to view Git diff excluding specific files
gdnolock() {
  git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
}
compdef _git gdnolock=git-diff

# =========
# RESETTING
# =========
# alias grh='git reset'
# alias gru='git reset --'
# alias grhh='git reset --hard'
# alias grhk='git reset --keep'
# alias grhs='git reset --soft'
# alias gpristine='git reset --hard && git clean --force -dfx'
# alias groh='git reset origin/$(git_current_branch) --hard'

# ===========
# PULL / PUSH
# ===========
# alias gl='git pull'
# alias ggpull='git pull origin "$(git_current_branch)"'

# alias gluc='git pull upstream $(git_current_branch)'
# alias glum='git pull upstream $(git_main_branch)'
# alias gp='git push'
# alias gpd='git push --dry-run'

# function ggf() {
# 	[[ "$#" != 1 ]] && local b="$(git_current_branch)"
# 	git push --force origin "${b:=$1}"
# }
# compdef _git ggf=git-checkout

# alias gpf!='git push --force'
# is-at-least 2.30 "$git_version" \
# 	&& alias gpf='git push --force-with-lease --force-if-includes' \
# 	|| alias gpf='git push --force-with-lease'

# function ggfl() {
# 	[[ "$#" != 1 ]] && local b="$(git_current_branch)"
# 	git push --force-with-lease origin "${b:=$1}"
# }
# compdef _git ggfl=git-checkout

# alias gpsup='git push --set-upstream origin $(git_current_branch)'
# is-at-least 2.30 "$git_version" \
# 	&& alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes' \
# 	|| alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease'
# alias gpv='git push --verbose'
# alias gpoat='git push origin --all && git push origin --tags'
# alias gpod='git push origin --delete'
# alias ggpush='git push origin "$(git_current_branch)"'

# alias gpu='git push upstream'

# alias gpr='git pull --rebase'
# alias gprv='git pull --rebase -v'
# alias gpra='git pull --rebase --autostash'
# alias gprav='git pull --rebase --autostash -v'

# function ggu() {
# 	[[ "$#" != 1 ]] && local b="$(git_current_branch)"
# 	git pull --rebase origin "${b:=$1}"
# }
# compdef _git ggu=git-checkout

# alias gprom='git pull --rebase origin $(git_main_branch)'
# alias gpromi='git pull --rebase=interactive origin $(git_main_branch)'

# =====
# FETCH
# =====
alias gf='git fetch' # Fetch from remote repository
alias gfa='gf --all --prune --jobs=10' # Fetch from all remotes and prune stale branches
alias gfo='gf origin' # Fetch from origin remote

# =======
# MERGING
# =======
# alias gm='git merge'
# alias gma='git merge --abort'
# alias gms="git merge --squash"
# alias gmom='git merge origin/$(git_main_branch)'
# alias gmum='git merge upstream/$(git_main_branch)'
# alias gmtl='git mergetool --no-prompt'
# alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'

# ========
# REBASING
# ========
# alias grb='git rebase'
# alias grba='git rebase --abort'
# alias grbc='git rebase --continue'
# alias grbi='git rebase --interactive'
# alias grbo='git rebase --onto'
# alias grbs='git rebase --skip'
# alias grbd='git rebase $(git_develop_branch)'
# alias grbm='git rebase $(git_main_branch)'
# alias grbom='git rebase origin/$(git_main_branch)'

# =======
# LOGGING
# =======
# alias glg='git log --graph'
# alias glga='git log --graph --decorate --all'
# alias glgm='git log --graph --max-count=10'
# alias glods='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'
# alias glod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'
# alias glola='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'
# alias glols='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'
# alias glol='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'
# alias glo='git log --oneline --decorate'
# alias glog='git log --oneline --decorate --graph'
# alias gloga='git log --oneline --decorate --graph --all'

# # Pretty log messages
# function _git_log_prettily(){
# 	if ! [ -z $1 ]; then
# 		git log --pretty=$1
# 	fi
# }
# compdef _git _git_log_prettily=git-log

# alias glp='_git_log_prettily'
# alias glg='git log --stat'
# alias glgp='git log --stat --patch'

# ========
# STASHING
# ========
# alias gstall='git stash --all'
# alias gstaa='git stash apply'
# alias gstc='git stash clear'
# alias gstd='git stash drop'
# alias gstl='git stash list'
# alias gstp='git stash pop'
# # use the default stash push on git 2.13 and newer
# is-at-least 2.13 "$git_version" \
# 	&& alias gsta='git stash push' \
# 	|| alias gsta='git stash save'
# alias gsts='git stash show --patch'

# ====
# MISC
# ====
alias gcf='git config --list'

# ============================================================
# ============================================================
# ============================================================
# ============================================================
# ============================================================

# alias gignored='git ls-files -v | grep "^[[:lower:]]"'
# alias gfg='git ls-files | grep'

# alias gr='git remote'
# alias grv='git remote --verbose'
# alias gra='git remote add'
# alias grrm='git remote remove'
# alias grmv='git remote rename'
# alias grset='git remote set-url'
# alias grup='git remote update'
# alias grs='git restore'
# alias grss='git restore --source'
# alias grst='git restore --staged'
# alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
# alias grev='git revert'
# alias grm='git rm'
# alias grmc='git rm --cached'
# alias gcount='git shortlog --summary --numbered'
# alias gsh='git show'
# alias gsps='git show --pretty=short --show-signature'
# alias gsi='git submodule init'
# alias gsu='git submodule update'
# alias gsd='git svn dcommit'
# alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'
# alias gsr='git svn rebase'
# alias gta='git tag --annotate'
# alias gts='git tag --sign'
# alias gtv='git tag | sort -V'
# alias gignore='git update-index --assume-unchanged'
# alias gunignore='git update-index --no-assume-unchanged'
# alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
# alias gwt='git worktree'
# alias gwta='git worktree add'
# alias gwtls='git worktree list'
# alias gwtmv='git worktree move'
# alias gwtrm='git worktree remove'
# alias gstu='gsta --include-untracked'
# alias gtl='gtl(){ git tag --sort=-v:refname -n --list "${1}*" }; noglob gtl'
# alias gk='\gitk --all --branches &!'
# alias gke='\gitk --all $(git log --walk-reflogs --pretty=%h) &!'

#============================================================================
# alias ga='git add'
# alias gap='git add -p' # Stage specified file(s) and select hunks to stage
# alias gp='git push'
# alias gpraise='git blame'
# alias gpo='git push origin'
# alias gpt='git push --tag'
# alias gtd='git tag --delete'
# alias gtdr='git tag --delete origin'
# alias grb='git branch -r'                                                                           # display remote branch
# alias gplo='git pull origin'
# alias gb='git branch '
# alias gc='git commit'
# alias gcm='git commit -m'
# alias gd='git diff'
# alias gds='git diff --cached' # View changes to staged files compared against previous commit
# alias gco='git checkout '
# # alias gl='git log --pretty=oneline'
# alias gl1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
# alias gl2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
# alias gl="gl2"
# alias glol='git log --graph --abbrev-commit --oneline --decorate'
# alias gr='git remote'
# alias grs='git remote show'
# alias gclean="git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 git branch -d" # Delete local branch merged with master
# alias gblog="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:red)%(refname:short)%(color:reset) - %(color:yellow)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:blue)%(committerdate:relative)%(color:reset))'"                                                             # git log for each branches
# alias gsub="git submodule update --remote"                                                        # pull submodules
# alias gj="git-jump"                                                                               # Open in vim quickfix list files of interest (git diff, merged...)
# alias dif="git diff --no-index"                                                                   # Diff two files even if not in git repo! Can add -w (don't diff whitespaces)
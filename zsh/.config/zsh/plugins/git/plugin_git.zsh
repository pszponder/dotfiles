#!/usr/bin/env zsh

# Based from: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh

# +-----------+
# | FUNCTIONS |
# +-----------+

# Create a new GitHub repository from the command line
# NOTE: Requires the GitHub CLI (gh) to be installed and authenticated
function gcreate {
	# Prompt for the new repository name
	read -p "Enter the new repository name: " repo_name

	# Create a new directory with the repository name
	mkdir "$repo_name"
	cd "$repo_name"

	# Initialize a local Git repository
	git init

	# Create a sample file (e.g., README.md)
	touch README.md

	# Add and commit the initial file
	git add .
	git commit -m "first commit"

	# Prompt for repository visibility (public or private)
	read -p "Make the new repository public? (y/n): " is_public

	if [[ "$is_public" == "y" || "$is_public" == "Y" ]]; then
		visibility="--public"
	else
		visibility="--private"
	fi

	# Authenticate with GitHub using gh CLI (ensure you're logged in)
	gh auth status

	# Create a GitHub repository with the specified visibility
	gh repo create "$repo_name" $visibility

	# Set the remote repository URL
	remote_url=$(gh repo view "$repo_name" --json=html_url --jq=".html_url" -q ".html_url")

	# Add the remote and push to GitHub
	git remote add origin "$remote_url"
	git branch -M main  # Use 'main' or 'master' based on your default branch name
	git push -u origin main

	# Open the GitHub repository in the default web browser
	gh repo view "$repo_name" --web
}


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
# Navigate (cd) to the root of the current git repository
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# ======
# STATUS
# ======
alias gs='git status'
alias gss='git status --short'
alias gssb='git status --short --branch'

# ============
# ADDING FILES
# ============
alias ga='git add'
alias gaa='git add --all' # Add all files
alias gap='git add --patch' # Add file(s) interactively & select hunks to stage
alias gau='git add --update' # Only add changes made to already tracked files
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip--"' # Add all unstaged files and commit with "--wip--"

# ========
# BRANCHES
# ========

# +------------------+
# | Listing Branches |
# +------------------+
alias gb='git branch' # List all branches (local), or create a new branch (by passing a new branch name)
alias gbr='git branch --remote' # List all branches (remote)
alias gba='git branch --all' # List all branches (local and remote)
alias gblnr='LANG=C git branch -vv | grep ": gone\]"' # List local branches that have been deleted on the remote repository
alias gbnm='git branch --no-merged' # list branches that have not been merged into the current branch

# +-------------------------------+
# | Creating / Switching Branches |
# +-------------------------------+
alias gbs='git switch' # Switch to a branch
alias gbsc='git switch --create' # Create a new branch and switch to it
alias gbsd='git switch $(git_develop_branch)' # Switch to the default development branch (e.g., 'develop' or 'main')
alias gbsm='git switch $(git_main_branch)' # Switch to the default main branch (e.g., 'develop' or 'main')
alias gbco='git checkout' # Checkout a Git branch
alias gbcor='git checkout --recurse-submodules' # Checkout a branch and its submodules
alias gbcod='git checkout $(git_develop_branch)' # Checkout the default development branch (e.g., 'develop' or 'main')
alias gsw='git switch'
alias gswc='git switch --create'
alias gswd='git switch $(git_develop_branch)'
alias gswm='git switch $(git_main_branch)'

# +----------------------------+
# | Moving / Renaming Branches |
# +----------------------------+
alias gbm='git branch --move' # Move / rename git branch (pass in current and new branch names)

# +-------------------+
# | Deleting Branches |
# +-------------------+
alias gbld='git branch --delete' # Delete a local branch
alias gblD='git branch --delete --force' # Force delete a local branch
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
alias gca="git commit --all" # Commit all staged/unstaged changes
alias "gca!"="git commit --all --amend" # Amend previous commit w/ all staged/unstaged changes
alias gcm="git commit --message" # Commit with commit message
alias "gcm!"="git commit --all --message" # Amend previous commit w/ new commit message
alias gcam="git commit --all --message" # Commit all staged/unstaged changes with commit message
alias "gcam!"=" git commit --all --amend --message" # Amend previous commit w/ new commit message
alias "gcn!"="git commit --no-edit" # Amend previous commit w/ same commit message
alias "gcan!"="git commit --all --no-edit" # Amend previous commit w/ same commit message and all staged/unstaged changes

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
# Resetting is the act of moving the current branch pointer to a different commit, effectively changes the current state of your working directory and staging area
alias grh='git reset' # Reset the current HEAD to the specified state
alias gru='git reset --' # Reset the current HEAD to the specified state, but keep the changes in the staging area
alias grhh='git reset --hard' # Reset the current HEAD to the specified state, and discard all changes in the working directory and staging area
alias grhk='git reset --keep' # Reset the current HEAD to the specified state, and keep the changes in the working directory but discard all changes in the staging area
alias grhs='git reset --soft' # Reset the current HEAD to the specified state, and keep all changes in the working directory and staging area
alias gpristine='git reset --hard && git clean --force -dfx' # Reset the current HEAD to the specified state, and discard all changes in the working directory and staging area, and remove all untracked files and directories
alias groh='git reset origin/$(git_current_branch) --hard' # Reset the current HEAD to the state of the remote origin branch (discarding all changes)

# ===================
# PULL / PUSH / FETCH
# ===================

# +-----------------+
# | Fetching / Sync |
# +-----------------+

# +---------+
# | Pulling |
# +---------+
# NOTE: Pull fetches the remote branch and merges it into the current branch

# Git Pull
# Pull changes from the 'origin' remote for the current branch
# Merge pulled changes from the 'origin' remote into the current branch
# OPTIONAL: Specify a remote branch name to pull from instead of the current branch
alias gpull='git pull'

# Git Pull Verbose
# Pull changes from 'origin' remote for the current branch with verbose output
alias gpullv='git pull -v'

# Git Pull Origin
# Pull changes from the 'origin' remote for the current branch
# Merge pulled changes from the 'origin' remote into the current branch
# OPTIONAL: Specify a remote branch name to pull from instead of the current branch
alias gpullo='git pull origin'

# Git Pull Origin Current Branch
# Pull changes from the 'origin' remote for the current local branch
# Merge pulled changes from the 'origin' remote into the current local branch
alias gpulloc='git pull origin "$(git_current_branch)"'

# Git Pull Origin Main Branch
# Pull changes from the 'origin' remote for the default main branch
# Merge pulled changes from the 'origin' remote into the default main branch
alias gpullom='git pull origin $(git_main_branch)'

# Git Pull Upstream
# Pull changes from the 'origin' remote for the current branch
# Merge pulled changes from the 'origin' remote into the current branch
# OPTIONAL: Specify a remote branch name to pull from instead of the current local branch
# NOTE: "upstream" refers to orignally forked repository
alias gpullu='git pull upstream'

# Git Pull Upstream Current Branch
# Pull changes from the 'upstream' remote for the current branch
# Merge pulled changes from the 'upstream' remote into the current branch
# NOTE: "upstream" refers to orignally forked repository
alias gpulluc='git pull upstream $(git_current_branch)'

# Git Pull Upstream Main Branch
# Pull changes from the 'upstream' remote for the default main branch
# Merge pulled changes from the 'upstream' remote into the default main branch
# NOTE: "upstream" refers to orignally forked repository
alias gpullum='git pull upstream $(git_main_branch)'

# Git Pull Rebase
# Perform a 'git pull' with rebasing instead of merging.
alias gpullr='git pull --rebase'

# Git Pull Rebase Verbose
# Perform a 'git pull' with rebasing and display verbose output.
alias gpullrv='git pull --rebase -v'

# Git Pull Rebae Auto Stash
# Perform a 'git pull' with rebasing, and automatically stash changes if needed.
alias gpullra='git pull --rebase --autostash'

# Git Pull Rebase Auto Stash Verbose
# Perform a 'git pull' with rebasing, display verbose output, and automatically stash changes if needed.
alias gpullrav='git pull --rebase --autostash -v'

# Function 'gpullro':
# Interactively pull changes from remote 'origin' branch w/ rebasing.
# Usage: Call this function with an optional branch name as an argument to specify the branch to pull.
# If no argument is provided, it will default to the current branch.
function gpullro() {
		[[ "$#" != 1 ]] && local b="$(git_current_branch)"
		git pull --rebase origin "${b:=$1}"
}
compdef _git gpullro=git-checkout

# Function 'gpullroi':
# Pull changes from the remote 'origin' branch with rebasing.
# Usage: Call this function with an optional branch name as an argument to specify the branch to pull.
# If no argument is provided, it will default to the current branch.
function gpullroi() {
		[[ "$#" != 1 ]] && local b="$(git_current_branch)"
		git pull --rebase=interactive origin "${b:=$1}"
}
compdef _git gpullroi=git-checkout

# +---------+
# | Pushing |
# +---------+
# Git Push
# Push changes to the 'origin' remote for the current branch
alias gp='git push'

# Git Push Verbose
# Push changes to the remote 'origin' with verbose output.
alias gpv='git push --verbose'

# Function `gpf` (Git Force Push):
# This function is used to forcefully push changes to a remote branch in Git.
# If you provide a branch name as an argument, it will push the current branch (or the one specified) with a force push to the remote repository using the --force-with-lease option.
# If no argument is provided, it will use the current branch by default.
# Usage:
# To use this function, simply call it with an optional branch name as an argument.
# Example 1: Force push the current branch
#   gpf
# Example 2: Force push a specific branch
#   gpf feature-branch
function gpf() {
	# Check if an argument (branch name) is provided, if not, use the current branch
	[[ "$#" != 1 ]] && local b="$(git_current_branch)"

	# Use `git push` with the `--force-with-lease` option to forcefully update the remote branch safely
	git push --force-with-lease origin "${b:=$1}"
}
compdef _git gpf=git-checkout

# Git Push Set Upstream
# Push current branch to remote 'origin' and set it as upstream
alias gpsup='git push --set-upstream origin $(git_current_branch)'

# Git Push Set Upstream Force
# Forcefully push current branch to remote 'origin' and set it as upstream
alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease'

# Git Push Origin All and Tags
# Push all branches & tags to the remote 'origin.'
alias gpoat='git push origin --all && git push origin --tags'

# Git Push Origin Delete
# Delete a branch on the remote 'origin.'
alias gpod='git push origin --delete'

# Git Push to Origin
# Push current branch to the remote 'origin' w/ same branch name.
# NOTE: Same as gpoc
# OPTIONAL: Add a branch name as an argument to push a different branch
alias gpo='git push origin'

# Git Push to Origin (Current Branch)
# Push current branch to the remote 'origin' w/ same branch name.
# NOTE: Same as gpo
alias gpoc='git push origin "$(git_current_branch)"'

# Git Push Upstream
# Pushes the current branch to the remote 'upstream.'
# OPTIONAL: Specify a branch name to push instead of the current branch
alias gpu='git push upstream'

# =====
# FETCH
# =====
alias gf='git fetch' # Fetch from remote repository
alias gfa='git fetch --all --prune --jobs=10' # Fetch from all remotes and prune stale branches
alias gfo='git fetch origin' # Fetch from origin remote

# =======
# MERGING
# =======
# Git Merge
# Perform a standard Git merge.
# USAGE: gm <branch_name_to_merge_into_current>
alias gm='git merge' # Specify a branch name to merge into the current branch

# Git Merge Abort
# Abort the current Git merge in progress.
alias gma='git merge --abort'

# Git Merge Squash
# Perform a Git merge while squashing all changes into a single commit.
# USAGE: gms <branch_name_to_merge_into_current>
alias gms="git merge --squash" # Specify a branch name to merge into the current branch

# Git Merge Origin (Remote Merge -- Origin Current Branch)
# Merge changes from the 'origin' remote into the current branch.
# USAGE: gmo
# Same as gpulloc git pull origin $(git_current_branch)
alias gmo='git merge origin' # Merge changes from the 'origin' main branch into the current branch

# Git Merge Origin (Remote Merge -- Origin Main Branch)
# Merge changes from the 'origin' main branch into the current branch.
# USAGE: gmo
alias gmom='git merge origin/$(git_main_branch)'

# Git Merge Upstream (Remote Merge -- Upstream Main Branch)
# Merge changes from the 'upstream' main branch into the current branch.
alias gmum='git merge upstream/$(git_main_branch)'

# Git Mergetool
# Launch the Git mergetool to resolve merge conflicts without prompting.
alias gmtl='git mergetool --no-prompt'

# Git Mergetool with vimdiff
# Launch the Git mergetool with the 'vimdiff' tool to resolve merge conflicts without prompting.
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'

# ========
# REBASING
# ========
# Git Rebase
# Perform a standard Git rebase. (Apply commits from your current branch on top of another branch)
# USAGE: grb <branch_name_to_rebase_onto>
alias grb='git rebase' # Specify a branch name to rebase the current branch onto

# Git Rebase Abort
# Abort the current Git rebase in progress.
alias grba='git rebase --abort'

# Git Rebase Continue
# Continue a paused Git rebase.
alias grbc='git rebase --continue'

# Git Rebase Interactive
# Start an interactive Git rebase, allowing you to squash, edit, or reorder commits.
alias grbi='git rebase --interactive'

# Git Rebase Skip
# Skip the current commit during an interactive rebase.
alias grbs='git rebase --skip'

# Git Rebase Onto
# Rebase the current branch onto a different base commit or branch.
# USAGE: grbo <branch_name_to_rebase_onto> <branch_name_to_rebase>
alias grbo='git rebase --onto'

# Git Rebase Develop
# Rebase the current branch onto the develop branch.
alias grbd='git rebase $(git_develop_branch)'

# Git Rebase Main
# Rebase the current branch onto the main branch.
alias grbm='git rebase $(git_main_branch)'

# Git Rebase Origin/Main
# Rebase the current branch onto the main branch of the 'origin' remote repository.
alias grbom='git rebase origin/$(git_main_branch)'

# =======
# LOGGING
# =======

# alias gl='git log --graph --abbrev-commit --oneline --decorate'

# Git Log One Line Custom
alias gl1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
alias gl2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"
alias gl=gl1

# Git Log Graph
# Show a graphical representation of the commit history.
alias glg='git log --graph'

# Git Log Graph Decorate All
# Show a graphical representation of the complete commit history with decorations.
alias glga='git log --graph --decorate --all'

# Git Log Graph Last 10
# Show a graphical representation of the last 10 commits in the commit history.
alias glgm='git log --graph --max-count=10'

# Show a simplified one-line view of the commit history with decorations.
alias glgo='git log --oneline --decorate'

# Show a simplified one-line view of the commit history with decorations and a graph.
alias glgog='git log --oneline --decorate --graph'

# Show a simplified one-line view of the complete commit history with decorations and a graph.
alias glgoga='git log --oneline --decorate --graph --all'

# Git Log Stats
# Display summarized git log w/ file change statistics.
alias glgst='git log --stat'

# Git Log Stats Patch
# Display summarized git log w/ file change stats & patch details.
alias glgstp='git log --stat --patch'

# Git Log Graph Date Short
# Show a graphical representation of the commit history with a custom pretty format and short date.
alias glgds='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short'

# Show a graphical representation of the commit history with a custom pretty format.
alias glgod='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset"'

# Show a graphical representation of the complete commit history with a custom pretty format and relative dates.
alias glgla='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all'

# Show a graphical representation of the commit history with a custom pretty format and file statistics.
alias glgls='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat'

# Show a graphical representation of the commit history with a custom pretty format and relative dates.
alias glgl='git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"'

# ========
# STASHING
# ========

# Git Stash (Stash Changes -- Tracked)
# Stash changes in the working directory
alias gst='git stash'

# Git Stash All (Stash Changes -- Tracked & Untracked)
# Stashes all changes in the working directory, including untracked files.
alias gstall='git stash --all'

# Git Stash List
# List all stashes in the repository.
alias gstl='git stash list'

# Git Stash Apply
# Apply the most recent stash to the working directory
alias gsta='git stash apply'

# Git Stash Pop
# Apply the most recent stash & remove it from the stash list
alias gstp='git stash pop'

# Git Stash Clear (Clear All Stashes)
# Clears all stashes, removing them from the stash list.
alias gstc='git stash clear'

# Git Stash Drop
# Drop most recent stash, permanently removing it from the stash list.
alias gstd='git stash drop'

# Git Stash Save
# Stash changes in the working directory with a custom message.
# Usage: gsta "Your custom stash message"
alias gsta='git stash save'

# Git Stash Show Patch
# Shows the changes in the most recent stash as a patch.
alias gsts='git stash show --patch'

# =======
# TAGGING
# =======
# Git Tag
# List all tags, or create a new tag (by passing a new tag name)
# Usage: gt            # List all tags
# Usage: gt <tag-name> # Create a new tag
# NOTE: Git does not automatically push tags to remote repository.
alias gt='git tag'

# Git Tag Annotate
# Create an annotated tag in Git with additional annotation/comment.
# Usage: gta <tag-name> -m "Annotation message"
alias gta='git tag --annotate'


# Git Tag Push
# Push all tags to remote repository.
# NOTE: Git does not automatically push tags to remote repository.
alias gtp='git push --tags'

# Git Tag Delete
# Delete a tag in Git.
# Usage: gtd <tag-name>
alias gtd='git tag --delete'

# Git Tag View
# List all Git tags in a sorted version order.
alias gtv='git tag | sort -V'

# Git Checkout Tag
# Checkout a Git tag.
# USAGE: gtco <tag-name>
alias gtco='git checkout'

# Git Checkout Tag Latest
# Checkout the latest Git tag.
alias gtcol='git checkout $(git describe --tags $(git rev-list --tags --max-count=1))'

# ====
# MISC
# ====
# List Git Conifg
# Lists all git config settings
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
# alias gp='git push'
# alias gpraise='git blame'
# alias gpo='git push origin'
# alias gplo='git pull origin'
# alias gb='git branch '
# alias gc='git commit'
# alias gcm='git commit -m'
# alias gd='git diff'
# alias gds='git diff --cached' # View changes to staged files compared against previous commit
# alias gco='git checkout '
# alias gr='git remote'
# alias grs='git remote show'
# alias gclean="git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 git branch -d" # Delete local branch merged with master
# alias gblog="git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:red)%(refname:short)%(color:reset) - %(color:yellow)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:blue)%(committerdate:relative)%(color:reset))'"                                                             # git log for each branches
# alias gsub="git submodule update --remote"                                                        # pull submodules
# alias gj="git-jump"                                                                               # Open in vim quickfix list files of interest (git diff, merged...)
# alias dif="git diff --no-index"                                                                   # Diff two files even if not in git repo! Can add -w (don't diff whitespaces)
# Git authentication with multiple SSH keys

This guide configures separate personal and work Git identities and SSH keys, selected automatically by repository location. It covers GitHub and Bitbucket examples; the same approach works with other Git hosts that support SSH.

For key generation, passphrases, agents, permissions, and remote server access, see [SSH client setup](ssh-setup.md). This guide assumes Git and the OpenSSH client are installed.

Two settings serve different purposes:

- `user.name` and `user.email` determine the author identity recorded in commits. The name can be your full name; it need not be a hosting username.
- `core.sshCommand` selects the SSH command and authentication key for fetch, pull, and push. It does not configure commit signing or ordinary interactive SSH sessions.

## 1. Create and register account keys

Follow the [key generation procedure](ssh-setup.md#2-generate-a-key-pair) for each account. For the examples in this guide:

> **NOTE:** If you want to create keys in sub-directories within `~/.ssh`, you need to make sure that those sub-directories are created first w/ `mkdir`

```sh
mkdir -p ~/.ssh/github/pszponder ~/.ssh/github/work-account ~/.ssh/bitbucket/work-account
chmod 700 ~/.ssh ~/.ssh/github ~/.ssh/bitbucket \
    ~/.ssh/github/pszponder ~/.ssh/github/work-account ~/.ssh/bitbucket/work-account

ssh-keygen -t ed25519 -f ~/.ssh/github/pszponder/personal -C "personal-github from laptop"
ssh-keygen -t ed25519 -f ~/.ssh/github/work-account/work -C "work-github from laptop"
ssh-keygen -t ed25519 -f ~/.ssh/bitbucket/work-account/work -C "work-bitbucket from laptop"
```

Use a passphrase for each key and choose filenames that do not overwrite existing keys. Replace `pszponder` and `work-account` throughout this guide with your account names or chosen local directory labels.

Display each `.pub` file and register it in the corresponding account's **SSH authentication key** settings, following the provider's instructions:

| Account         | Public key                               | Provider instructions                                                                                              |
| --------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Personal GitHub | `~/.ssh/github/pszponder/personal.pub`   | [GitHub SSH setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)                        |
| Work GitHub     | `~/.ssh/github/work-account/work.pub`    | [GitHub SSH setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)                        |
| Work Bitbucket  | `~/.ssh/bitbucket/work-account/work.pub` | [Bitbucket SSH setup](https://support.atlassian.com/bitbucket-cloud/docs/configure-ssh-and-two-step-verification/) |

For example, run `cat ~/.ssh/github/pszponder/personal.pub` and copy the entire line. Never upload the private key. For GitLab, see its [SSH key instructions](https://docs.gitlab.com/user/ssh/).

Optionally [add the keys to your SSH agent](ssh-setup.md#3-optionally-cache-the-passphrase-with-ssh-agent) to cache their passphrases.

## 2. Select Git settings by repository directory

Organize repositories under account-specific directories:

```text
~/repos/
├── github/
│   ├── pszponder/project-a/
│   └── work-account/company-service/
└── bitbucket/
    └── work-account/backend-service/
```

The local directory label selects your configuration; the repository owner in its remote URL may be an organization or workspace with a different name.

Create the directory for account configuration fragments:

```sh
mkdir -p ~/.config/git
```

Edit your global Git configuration, preserving existing settings. These examples use `~/.gitconfig`:

```gitconfig
# Put any fallback identity BEFORE the conditional includes.
# Require an explicitly configured identity instead of guessing one.
[user]
    useConfigOnly = true

[includeIf "gitdir:~/repos/github/pszponder/"]
    path = ~/.config/git/github_pszponder

[includeIf "gitdir:~/repos/github/work-account/"]
    path = ~/.config/git/github_work

[includeIf "gitdir:~/repos/bitbucket/work-account/"]
    path = ~/.config/git/bitbucket_work
```

A trailing slash makes each directory condition recursive. Git matches the repository's Git directory, usually its `.git` directory. Linked worktrees and custom Git directories may require different rules; inspect them with `git rev-parse --absolute-git-dir`.

Git also automatically reads `$XDG_CONFIG_HOME/git/config` (normally `~/.config/git/config`). If both global files exist, `~/.gitconfig` is read later. Put your rules in one place and inspect existing settings with `git config --global --show-origin --list`. Later values normally override earlier ones, including values supplied by conditional includes. Local repository configuration can override global settings too.

With no configured name or email, `user.useConfigOnly` makes a commit fail rather than inventing an identity for an unmatched repository. Existing global or local identities still apply; remove unwanted defaults if you want unmatched repositories to require explicit configuration.

## 3. Create per-account configuration files

Create `~/.config/git/github_pszponder`:

```gitconfig
[user]
    name = Your Personal Name
    email = personal@example.com
[core]
    sshCommand = ssh -i ~/.ssh/github/pszponder/personal -o IdentitiesOnly=yes
```

Create `~/.config/git/github_work`:

```gitconfig
[user]
    name = Your Work Name
    email = you@company.com
[core]
    sshCommand = ssh -i ~/.ssh/github/work-account/work -o IdentitiesOnly=yes
```

Create `~/.config/git/bitbucket_work`:

```gitconfig
[user]
    name = Your Work Name
    email = you@company.com
[core]
    sshCommand = ssh -i ~/.ssh/bitbucket/work-account/work -o IdentitiesOnly=yes
```

Use the email you want attributed to commits, such as an account's verified or provider-supplied private email address.

`IdentitiesOnly=yes` prevents unrelated agent keys from being offered. SSH still reads `~/.ssh/config`, and matching `IdentityFile` entries accumulate with `-i`. Keep account-specific keys out of broad matching SSH blocks to avoid offering additional identities. See the [SSH configuration guidance](ssh-setup.md#5-configure-a-reusable-server-alias).

This command applies to every SSH remote in a matching repository. If its remotes need different keys, use the host alias approach below and omit `core.sshCommand` for that repository's configuration.

## 4. Clone and use repositories

Pass the key explicitly for the initial clone so it does not depend on directory-based configuration during clone setup:

```sh
mkdir -p ~/repos/github/pszponder ~/repos/github/work-account ~/repos/bitbucket/work-account

git -c core.sshCommand="ssh -i ~/.ssh/github/pszponder/personal -o IdentitiesOnly=yes" \
    clone git@github.com:pszponder/project-a.git \
    ~/repos/github/pszponder/project-a

git -c core.sshCommand="ssh -i ~/.ssh/github/work-account/work -o IdentitiesOnly=yes" \
    clone git@github.com:work-account/company-service.git \
    ~/repos/github/work-account/company-service

git -c core.sshCommand="ssh -i ~/.ssh/bitbucket/work-account/work -o IdentitiesOnly=yes" \
    clone git@bitbucket.org:work-account/backend-service.git \
    ~/repos/bitbucket/work-account/backend-service
```

Replace the example remote owners and repository names with repositories you can access. On first connection, verify the host key fingerprint against the provider's published fingerprint before accepting it.

The `git -c` option applies only to that invocation. Once cloned into a matching directory, ordinary commands use the conditional configuration:

```sh
cd ~/repos/github/pszponder/project-a
git fetch
git pull
git push
```

For an existing repository, place it under the matching directory and ensure its remote uses SSH:

```sh
git remote -v
git remote set-url origin git@github.com:pszponder/project-a.git
```

An `https://` remote uses HTTPS authentication and does not use `core.sshCommand`.

## 5. Alternative: select keys with SSH host aliases

Use aliases if you prefer selecting accounts through remote URLs, or if different remotes in a single repository require different keys. Continue using Git's conditional includes for commit names and emails, but omit their `core.sshCommand` entries so SSH aliases control key selection.

Add to `~/.ssh/config`:

```sshconfig
Host github-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/github/pszponder/personal
    IdentitiesOnly yes

Host github-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/github/work-account/work
    IdentitiesOnly yes
```

Apply the [SSH config permissions](ssh-setup.md#5-configure-a-reusable-server-alias), then clone using the intended alias:

```sh
git clone git@github-personal:pszponder/project-a.git ~/repos/github/pszponder/project-a
git clone git@github-work:work-account/company-service.git ~/repos/github/work-account/company-service
```

The alias stays in the saved remote URL, so subsequent operations select the same key. For an existing repository, use `git remote set-url origin git@github-work:work-account/company-service.git`.

The SSH username for these GitHub URLs is always `git`; the key identifies your hosting account. Server logins instead use the account on that server, as explained in the [SSH client guide](ssh-setup.md#5-configure-a-reusable-server-alias).

## 6. Verify and troubleshoot

Inside each repository, inspect the effective settings and their source files:

```sh
git config --show-origin --get user.name
git config --show-origin --get user.email
git config --show-origin --get core.sshCommand
git remote -v
git ls-remote origin
```

With the alias approach, an unset `core.sshCommand` is expected. `git ls-remote origin` tests read access through Git's actual configuration; push access may require additional repository permissions.

Test a specific GitHub key independently of Git:

```sh
ssh -T -i ~/.ssh/github/pszponder/personal -o IdentitiesOnly=yes git@github.com
```

Or test an alias with `ssh -T git@github-personal`. GitHub's success message names the authenticated account; it does not provide shell access and normally exits with status 1. A plain `ssh -T git@github.com` does not read Git's `core.sshCommand` and may test a different key.

If the wrong account or identity is selected:

1. Check the Git directory with `git rev-parse --absolute-git-dir` and compare it to your `includeIf` rules.
2. Check settings and overrides with `git config --show-origin --show-scope --list`. Repository-local settings, later includes, and `GIT_SSH_COMMAND` can override your intended command.
3. Check that the remote uses SSH and the correct owner/repository path or alias.
4. Confirm the public key is registered with the intended account and that account has repository access.
5. Inspect matching SSH identity files with `ssh -G github.com` or `ssh -G github-personal`.

For more detail, run `GIT_TRACE=1 git ls-remote origin`, or add `-v` to a direct SSH test. Review logs before sharing them because they can contain account names, paths, and repository URLs. For agent, permissions, server connection, and key replacement issues, see [SSH troubleshooting and maintenance](ssh-setup.md#6-troubleshoot-and-maintain-keys).

## References

- [Git configuration reference: conditional includes, precedence, and core.sshCommand](https://git-scm.com/docs/git-config)
- [Git clone reference](https://git-scm.com/docs/git-clone)
- [GitHub: testing your SSH connection](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection)

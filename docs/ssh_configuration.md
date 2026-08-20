# Configuring SSH Keys

## Configure remote hosts

Use `~/.ssh/config` to give remote servers a stable alias and select connection options such as the user, port, and identity. This is useful for interactive SSH, `scp`, `rsync`, and tools that invoke SSH.

```sshconfig
# ~/.ssh/config
Host <ssh_alias_name>
    HostName <remote_server_ip>
    User <username_for _server>
    IdentityFile ~/.ssh/<path_to_your_private_key>

Host app-prod
    HostName 203.0.113.10
    User deploy
    Port 2222
    IdentityFile ~/.ssh/servers/app-prod
    IdentitiesOnly yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
```

Replace the example hostname, user, port (defaults to 2222 if not specified), and key path for each server. Then connect with `ssh app-prod`, copy with `scp file app-prod:/path/`, or use the alias as an `rsync` destination.

`IdentitiesOnly yes` makes OpenSSH use the identity declared for that host instead of also offering keys held by `ssh-agent`. This prevents the wrong account being selected and avoids "too many authentication failures" when the agent has several keys.

Protect the directory, configuration, and private keys:

```sh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config ~/.ssh/servers/app-prod
```

## Generate new SSH key pairs

Refer to the `$HOME/.local/bin/sshkeygen` script to help create an ssh key pair.

```sh
sshkeygen [-t ed25519|rsa] [-d key_dir] [-n key_name] [-c comment] [-a]
```

| Flag | Description | Default |
| --- | --- | --- |
| `-t` | Key type (`ed25519` or `rsa`) | `ed25519` |
| `-d` | Directory to store the key | `~/.ssh` |
| `-n` | Key filename | `id_<type>` |
| `-c` | Key comment (e.g. email or purpose) | none |
| `-a` | Add key to `ssh-agent` non-interactively | prompts interactively |

Any flag you omit will be prompted for interactively (except `-a`, which just skips the agent prompt). The script will:
- Create `key_dir` (`chmod 700`) if it doesn't exist, and prompt before overwriting an existing key
- Generate the key pair and set `chmod 600`/`644` on the private/public key respectively
- Optionally add the private key to `ssh-agent` (using the macOS Keychain if run on macOS)
- Copy the public key to your clipboard if a supported clipboard utility is found (`cb`, `pbcopy`, `xclip`, `xsel`, `wl-copy`, or `clip.exe`), otherwise print it to the terminal

You should create a new SSH key for each service which you wish to connect to via SSH
- Ex. If you have a GitHub and Bitbucket account, you should have a separate SSH key pair for each service.
- You will also need to create an ssh key for any remote machines you wish to connect to (assuming you want to use an ssh key instead of a username and password, which is recommended)

## Bootstrap default SSH keys

`home/.chezmoiscripts/run_once_02-bootstrap-system.sh.tmpl` runs automatically on the first `chezmoi apply` and generates a standard set of keypairs in one pass instead of running `sshkeygen` manually for each one.

The default set (edit the `DEFAULT_KEYS` list in the script to customize) is:
- `~/.ssh/default` — general-purpose fallback key
- `~/.ssh/github/pszponder/personal` — key for your personal GitHub account (each GitHub account gets its own `~/.ssh/github/<account>/` subdir, e.g. a work account would live under `~/.ssh/github/<work-account>/`)

For each entry that doesn't already exist, it runs `sshkeygen` with the matching type/dir/name/comment and adds it to `ssh-agent`. Existing keys are skipped (not overwritten). You'll still be prompted for a passphrase per key, since the underlying `sshkeygen` script doesn't support generating passphrase-less keys.

Since this is a `run_once_` script, editing `DEFAULT_KEYS` and re-running `chezmoi apply` will re-run it (chezmoi reruns `run_once_` scripts when their contents change), generating any newly added keys while skipping ones that already exist.

## Add the public key to your account / service / VM

### Add public key to account / service

Copy the contents of the public key file (ends in `.pub`) to your account / service

### Add public key to VM

Copy the contents of the public key file into the VM's `authorized_keys` file

```sh
# Login to your VM first

mkdir -p ~/.ssh
chmod 700 ~/.ssh

echo "<your_public_key_contents>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

Alternatively

```sh
# From your local machine, copy the public key directly to the VM
ssh-copy-id -i ~/.ssh/<path_to_your_public_key> <username>@<remote_ip>
```

After completing these steps, you should be able to SSH into your VM:

```sh
ssh <username>@<remote_ip>

# Or, if you configured an alias in ~/.ssh/config,
ssh <ssh_alias_name>
```

## Add the private key to your computer's git config

This step is optional but recommended if you are using multiple remote repo accounts (ex. a personal and work GitHub account)

This specific method will use folder-specific identities
- Meaning that anything in a given directory will use your specified ssh config

Here is an example directory hierarchy:

**~/**
- **repos/** (where all your repos go)
    - **github**
        - **pszponder**
            - **repo1**
            - **repo2**
            - ...
    - **bitbucket**
    - **gitlab**
    - ...
- **sandbox/** (place to store experiments)
- **courses/** (place course materials here)
- **resources/** (books, cheat sheets, etc.)

This is what your global gitconfig (`~/.config/git/config`) should look like
```txt
# ~/.config/git/config

# Include for all .git projects under ~/repos/github/pszponder
# Copy this pattern for any other git repos, making sure to change the gitdir and path
[includeIf "gitdir:~/repos/github/pszponder/**"]
path = ~/.config/git/github_pszponder

# Add other global gitconfig settings here ...
```

`~/.config/git/github_pszponder` contains the identity prompted by chezmoi and the SSH key for repositories matched by the `includeIf` rules above. Create a separate fragment and include rule for each future host or account that needs a different identity or SSH key.

```txt
# ~/.config/git/github_pszponder

[user]
    email = <git_email>
    name = <github_username>

[core]
    sshCommand = "ssh -i <PATH_TO_YOUR_PERSONAL_PRIVATE_KEY> -o IdentitiesOnly=yes"
```

`core.sshCommand` is enough for Git repositories matched by the include rule; it does not require a `Host github.com` entry in `~/.ssh/config`. Keep the SSH config for services and remote servers that need reusable connection settings.

## Resources / References

- [Using multiple GitHub accounts without login](https://blog.omkarpai.net/posts/multiple-git-identities/)
- [GitGuardian - 8 Easy Steps to Set Up Multiple GitHub Accounts](https://blog.gitguardian.com/8-easy-steps-to-set-up-multiple-git-accounts/)
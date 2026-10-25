# SSH Client Setup

Use this guide to generate SSH keys, manage passphrases, and connect to remote servers. For Git hosting accounts and automatic selection of multiple keys, continue with [Git authentication with multiple SSH keys](git-ssh-setup.md).

This guide covers the computer initiating a connection, usually your workstation. A server can also act as an SSH client. To accept incoming connections, follow [SSH server setup](ssh-setup-server.md).

The examples use OpenSSH on Linux or macOS. Replace example hostnames, usernames, and paths with your own. You need the OpenSSH client locally; remote servers must already have an SSH service running and an account you can access.

## 1. Choose a key layout

Use separate keys for different accounts or security boundaries, such as personal GitHub, work GitHub, and production servers. You do not need a key per repository or server unless you want that isolation. Prefer separate keys on each device so you can revoke a lost device independently.

Example private key paths:

| Purpose           | Private key                          |
| ----------------- | ------------------------------------ |
| Personal GitHub   | `~/.ssh/github/pszponder/personal`   |
| Work GitHub       | `~/.ssh/github/work-account/work`    |
| Work Bitbucket    | `~/.ssh/bitbucket/work-account/work` |
| Production server | `~/.ssh/servers/app-prod`            |

Each private key has a public counterpart at the same path with `.pub` appended. Keep private keys on your computer; install only public keys on services and servers. Never commit private keys to this repository.

## 2. Generate a key pair

Run these commands on the computer you will connect **from**, such as your workstation or laptop. The key can authenticate you to a remote server, another workstation, or another SSH-enabled device. The `servers/app-prod` path below is an example label for the intended destination; it does not restrict where the key can be used.

```sh
mkdir -p ~/.ssh/servers
chmod 700 ~/.ssh ~/.ssh/servers
ssh-keygen -t ed25519 -f ~/.ssh/servers/app-prod -C "app-prod from laptop"
```

Enter a passphrase when prompted. The comment is a label to help identify the key; it does not set the remote login user. Choose an unused filename and do not overwrite an existing key you still use.

This creates:

- `~/.ssh/servers/app-prod`: private key, protected by your passphrase.
- `~/.ssh/servers/app-prod.pub`: public key, which you can share.

Set permissions and inspect the public key:

```sh
chmod 600 ~/.ssh/servers/app-prod
chmod 644 ~/.ssh/servers/app-prod.pub
cat ~/.ssh/servers/app-prod.pub
ssh-keygen -lf ~/.ssh/servers/app-prod.pub
```

For Git hosting, use the same procedure with the account-specific paths from the [Git guide](git-ssh-setup.md#1-create-and-register-account-keys). The commands here use standard `ssh-keygen`; no custom wrapper or bootstrap script is required.

## 3. OPTIONAL: Cache the passphrase with ssh-agent

An agent holds unlocked keys so you do not have to enter their passphrases for every connection. First check whether your session already has an agent:

```sh
ssh-add -l
```

If it reports that it cannot connect to an authentication agent, start one for the current shell:

```sh
eval "$(ssh-agent -s)"
```

A message that the agent has no identities means it is running but empty. Add your key and list loaded identities:

```sh
ssh-add ~/.ssh/servers/app-prod
ssh-add -l
```

Repeat `ssh-add` for any Git keys you want cached. SSH can also read a private key directly and prompt for its passphrase without an agent. A manually started agent does not automatically configure future login sessions; use your desktop or operating system's agent integration for that.

Remove a cached key with `ssh-add -d ~/.ssh/servers/app-prod`. This does not delete the key file or revoke the public key on a server.

## 4. Install the public key on a server

This step is for logging into a remote machine's user account. For Git repositories hosted on GitHub, Bitbucket, GitLab, or a similar service, add the **public key** in your hosting account's SSH key settings instead, then follow [the Git guide's key registration steps](git-ssh-setup.md#1-create-and-register-account-keys). You do not need to run `ssh-copy-id` or edit `authorized_keys` on those services. Repository-specific deploy keys are a separate option for access limited to a particular repository.

You need an existing way to access the target account, such as a password, another key, an administrator, or the provider's console.

If `ssh-copy-id` is available, run this locally:

```text
ssh-copy-id -i <path_to_public_ssh_key> -p <ssh_port> <remote_username>@<hostname_or_ip>
```

Replace the placeholders, including the angle brackets, before running the command. Use the public key file ending in `.pub`. The name before `@` is the account on the remote machine; the hostname or IP address comes after `@`. Omit `-p <ssh_port>` when using the default port, **22**.

For example:

```sh
ssh-copy-id -i ~/.ssh/servers/app-prod.pub -p 2222 deploy@203.0.113.10
```

This installs `~/.ssh/servers/app-prod.pub` for the remote account `deploy` on `203.0.113.10`, connecting through port `2222`.

For manual installation, follow [server-side public key authorization](ssh-setup-server.md#2-authorize-client-public-keys). `ssh-copy-id` requires an already running SSH service and a permitted way to log in; it does not enable the service or change its authentication policy.

Test from your local computer while keeping your existing session open:

```sh
ssh -i ~/.ssh/servers/app-prod -o IdentitiesOnly=yes -p 2222 deploy@203.0.113.10
```

On the first connection, compare the server's host key fingerprint with one supplied by the administrator or provider through a trusted channel before accepting it. SSH stores accepted server identities in `~/.ssh/known_hosts`; this is separate from `authorized_keys`, which controls who can log in.

## 5. Configure a reusable server alias

Create or edit `~/.ssh/config`, preserving any existing entries:

```sshconfig
# ~/.ssh/config
Host <ssh_alias_name>
    HostName <remote_server_ip>
    User <username_for_server>
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

Then protect the file:

```sh
chmod 600 ~/.ssh/config
```

`Host` is the name you type locally; `HostName` is the actual address. `User` selects the remote account and `IdentityFile` points to the local private key. The keepalive options help detect unresponsive connections.

`IdentitiesOnly yes` limits authentication to configured identities rather than offering unrelated agent keys. Multiple matching `IdentityFile` settings accumulate, so avoid putting account-specific keys in a broad `Host *` block. Put specific host blocks before general defaults because most SSH settings use the first matching value.

Connect using the alias:

```sh
ssh app-prod
```

Git host aliases are optional and are covered in the [Git guide](git-ssh-setup.md#5-alternative-select-keys-with-ssh-host-aliases).

### Optional: transfer files over SSH

Once SSH access works, you can also use the alias to transfer files. These tools are optional conveniences; neither is required to configure SSH. The remote computer can be a server, another workstation, or a NAS that supports SSH file transfers.

Use `scp` to copy a file:

```sh
scp ./file.txt app-prod:/tmp/
```

Use `rsync` to synchronize a directory, transferring only changed data on subsequent runs. This command requires `rsync` on both computers:

```sh
rsync -av ./project/ app-prod:/srv/project/
```

Both examples copy from your local computer to the remote computer. The alias supplies the user, port, and key. Replace the source and destination paths as needed; the destination account must have permission to write to the target path.

## 6. Troubleshoot and maintain keys

Inspect the resolved configuration without connecting, then use verbose logging if needed:

```sh
ssh -G app-prod
ssh -v app-prod
```

For `Permission denied (publickey)`, check the remote username, selected key, installed public key, file ownership and permissions, and [server authentication policy](ssh-setup-server.md#3-test-access-before-restricting-authentication). For connection timeouts or refusals, check the address, port, network access, and SSH service.

If SSH warns that a server's host key has changed, confirm the new fingerprint with the administrator before updating `known_hosts`.

To change a private key's passphrase:

```sh
ssh-keygen -p -f ~/.ssh/servers/app-prod
```

To replace a key, generate a new pair at a new path, install its public key, update the relevant SSH or Git configuration, and test access. Then remove the old public key from each account or server where it was authorized. Deleting a local private key alone does not revoke access.

For Git-specific issues, use the [Git verification and troubleshooting steps](git-ssh-setup.md#6-verify-and-troubleshoot).

## References

- [OpenSSH key generation manual](https://man.openbsd.org/ssh-keygen)
- [OpenSSH client configuration manual](https://man.openbsd.org/ssh_config)
- [OpenSSH agent manual](https://man.openbsd.org/ssh-agent)

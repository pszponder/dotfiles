# SSH Server Setup

Use this guide to let other computers connect to a machine over SSH. It covers the receiving side: the SSH service, login accounts, authorized public keys, network access, and authentication policy. A workstation needs this setup too if you want to connect to it remotely.

Generate and keep your client private keys on the connecting computer using [SSH client setup](ssh-setup.md). For Git hosting authentication, use the [Git guide](git-ssh-setup.md); you do not need to run your own SSH server to use GitHub or Bitbucket.

The examples use a remote account named `deploy` and port `2222`, matching the client guide. Replace these with your actual account and port. OpenSSH's standard port is `22`.

## 1. Enable the service and network access

Keep console or provider recovery access available while setting this up. If already connected over SSH, keep that session open until a second connection succeeds.

Install and enable the OpenSSH server using your operating system's instructions. Package and service names vary; common names are `openssh-server` and `ssh` or `sshd`. Allow the SSH port through the host firewall and any upstream firewall, security group, or router. Limit access to your network or VPN when practical.

Configure the service through `/etc/ssh/sshd_config` or a supported included file. For example:

```text
Port 2222
PubkeyAuthentication yes
```

Check existing settings, `Include` files, and `Match` blocks rather than appending conflicting directives. Validate with `sudo sshd -t` before reloading the service using your operating system's service manager. If changing the port, keep the old port enabled until you verify the new one.

## 2. Authorize client public keys

An authorized key grants access to a particular remote user. Create or choose that account first; it needs an appropriate home directory and login shell. Administrative privileges are a separate decision and are not required for SSH access.

### Add the key to the remote account

For accounts that use `~/.ssh/authorized_keys`, log into the target account using existing access or a console and run these commands **on the server**:

```sh
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cat >> ~/.ssh/authorized_keys <<'PUBLIC_KEY'
PASTE_YOUR_ENTIRE_PUBLIC_KEY_LINE_HERE
PUBLIC_KEY
chmod 600 ~/.ssh/authorized_keys
```

Replace the placeholder before running the command. This appends a public key without replacing existing entries. Run it as the intended login user so the files belong to that user; their home directory must not be writable by other users.

Alternatively, run [`ssh-copy-id` from the client](ssh-setup.md#4-install-the-public-key-on-a-server) if an existing login method permits it.

To revoke access, remove the key from the account's `authorized_keys` file.

## 3. Test access before restricting authentication

On the server, obtain its public host key fingerprint through your console or existing trusted access:

```sh
sudo ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
```

If the server uses different host key paths or algorithms, inspect the corresponding public host key. Share this fingerprint with the connecting user through a trusted channel. Server host keys identify the server; authorized client keys identify users. Keep server host private keys on the server.

From a second terminal **on the client**, test public key authentication without falling back to a password or keyboard-interactive prompt:

```sh
ssh -i ~/.ssh/servers/app-prod \
    -o IdentitiesOnly=yes \
    -o PreferredAuthentications=publickey \
    -p 2222 deploy@203.0.113.10
```

Compare the host key fingerprint before accepting it. A prompt for the local private key's passphrase is expected unless an agent has already unlocked it. Confirm you reach the intended account, and test `sudo` separately if this account requires administration rights.

After that succeeds, you can require key-based login by setting these options in `sshd_config`:

```text
PasswordAuthentication no
KbdInteractiveAuthentication no
PermitRootLogin no
```

These settings disable password and keyboard-interactive SSH authentication and direct root login. Use them only after all intended users have working public keys and you have a non-root administration path. If you use keyboard-interactive MFA, preserve its required authentication policy. Validate with `sudo sshd -t`, reload the service, and open another fresh client connection before closing your original session. See the [OpenSSH server configuration manual](https://man.openbsd.org/sshd_config).

## 4. Troubleshoot and maintain access

Inspect the service and recent logs (replace `sshd` if your system uses another service name):

```sh
sudo systemctl status sshd
sudo journalctl -u sshd -b --no-pager -n 100
```

To inspect listening TCP sockets on Linux, use `sudo ss -ltnp`.

- For connection timeouts or refusals, check the service, listening address and port, host firewall, and upstream network rules.
- For `Permission denied (publickey)`, check the account, installed public key, ownership, permissions, and effective authentication policy. Check any user or group allow/deny rules too.
- If access breaks after a change, use the session you kept open or recovery console to correct or revert it.

For client diagnostics, aliases, and replacement keys, see [SSH client troubleshooting](ssh-setup.md#6-troubleshoot-and-maintain-keys). When retiring a client device, remove its public keys from the server's authorization sources and apply the change. Existing sessions may remain active after key removal.

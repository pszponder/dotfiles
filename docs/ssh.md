# Configuring SSH Keys

## Create SSH Config

Use the `$HOME/scripts/initialize_ssh_config.sh` script to create a templated starter ssh config file if one doesn't yet exist

## Generate new SSH key pairs

Refer to `sshkeygen` script to help create an ssh key

You should create a new SSH key for each service which you wish to connect to via SSH
- Ex. If you have a GitHub and Bitbucket account, you should have a separate SSH key pair for each service.
- You will also need to create an ssh key for any remote machines you wish to connect to (assuming you want to use an ssh key instead of a username and password, which is recommended)

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

You should also update your ssh config on your local machine for convenience

```sh
Host <ssh_alias_name>
    HostName <server_ip>
    User <username_for_server>
    IdentityFile ~/.ssh/<path_to_your_private_key>
```

After completing these steps, you should be able to ssh into your VM

```sh
ssh <username>@<remote_ip>

# Or, if you configured your ~/.ssh/config file,
ssh <ssh_alias_name>
```

## Add the private key to your computer's git config

This step is optional but recommended if you are using multiple remote repo accounts (ex. a personal and work GitHub account)

This specific method will use folder-specific identities
- Meaning that anything in a given directory will use your specified ssh config

Here is the directory hierarchy:

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

This is what your global gitconfig (`/home/YOUR_USER/.gitconfig`) should look like
```txt
# ~/.gitconfig

# Include for all .git projects under ~/repos/github/pszponder
# Copy this pattern for any other git repos
[includeIf "gitdir:~/repos/github/pszponder/**"]
path = ~/.gitconfig_github_pszponder

[core]
excludesfile = ~/.gitignore      # always ignore the patterns listed in this file

# Add other global gitconfig settings
```

Now, we also want to create the `~/.gitconfig_github_pszponder` which will specify the SSH key to use

```txt
# ~/.gitconfig_github_pszponder

[user]
    email = <git_email>
    name = <github_username>

[core]
    sshCommand = "ssh -i <PATH_TO_YOUR_PERSONAL_PRIVATE_KEY>"
```

## Resources / References

- [Using multiple GitHub accounts without login](https://blog.omkarpai.net/posts/multiple-git-identities/)
- [GitGuardian - 8 Easy Steps to Set Up Multiple GitHub Accounts](https://blog.gitguardian.com/8-easy-steps-to-set-up-multiple-git-accounts/)
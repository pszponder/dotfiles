# Dotfiles

## Prerequisites

- [chezmoi](https://www.chezmoi.io/)

## How to Run / Setup

```sh
chezmoi init --apply pszponder
```

## Organization

Code repositories are organized in the following location: `~/repos/<REMOTE>/<NAMESPACE>/<REPO>`
- Example => `~/repos/github/pszponder/<REPO_NAME>`

### Directory hierarchy:

```txt
~
├── repos
│   ├── github
│   │   └── pszponder
│   │       ├── repo1
│   │       ├── repo2
│   │       └── ...
│   ├── bitbucket
│   ├── gitlab
│   └── ...
├── sandbox
├── courses
└── resources
```

- **~/repos/**      - Where all your repos go
- **~/sandbox/**    - Place to store experiments and tests
- **~/courses/**    - Place course materials here
- **~/resources/**  - Books, cheat sheets, etc.

Refer to `scripts/setup_directories.sh` to view/edit the predefined directories created by this repo.

## Configuring Git / SSH

Refer to `./docs/ssh_configuration.md` for more information on configuring SSH and Git on your system

## Troubleshooting

## TODOs
- Install and setup Podman
- Install and setup Kanata

## Resources / References

- [Arch Package Repository](https://aur.archlinux.org/packages)
- [AUR - Arch User Repository](https://aur.archlinux.org/packages)
- [Jguer/yay: Yet another Yogurt - An AUR Helper written in Go](https://github.com/Jguer/yay)
- [Home | mise-en-place](https://mise.jdx.dev/)
- [Mise: The BEST Way to Manage Versions of Node, Python, Go (and Much More...)](https://www.youtube.com/watch?v=eKJCnc0t8V0)
- [DevOps Toolbox - The Holy Grail of Developer CLIs - mise](https://www.youtube.com/watch?v=-_o1AS3q6xo)

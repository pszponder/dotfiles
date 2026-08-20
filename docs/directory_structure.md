# Home Directory Structure

On a new system, `chezmoi apply` runs [`home/.chezmoiscripts/run_once_02-bootstrap-system.sh.tmpl`](../home/.chezmoiscripts/run_once_02-bootstrap-system.sh.tmpl), which creates the following default directories under `$HOME` (skipping any that already exist):

```
~/
├── repos/                    # Source-controlled projects and repositories
│   └── github/
│       └── pszponder/        # Personal GitHub repositories
│
├── resources/                # Learning materials, reference material, and knowledge
│   ├── courses/               # Course materials, tutorials, and learning programs
│   ├── books/                 # Books, ebooks, and book-related material
│   ├── datasets/               # Datasets and data used for learning, analysis, or experimentation
│   ├── cheatsheets/            # Quick-reference guides and condensed technical references
│   └── notes/                  # Personal notes, summaries, and distilled knowledge
│
└── scratch/                  # Temporary, disposable work and quick experiments
```

To add or remove a default directory, edit the `DEFAULT_DIRS` list in the script above.

The same script then symlinks `~/repos/github/pszponder/dotfiles` to chezmoi's source directory (default: `~/.local/share/chezmoi`), so the repo is easy to find alongside other projects while chezmoi keeps using its standard source location.

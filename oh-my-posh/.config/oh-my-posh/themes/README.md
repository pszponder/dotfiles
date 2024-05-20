# Oh My Posh

## How to Read the Git Symbols

The prompt theming [JanDeDobbeleer/oh-my-posh](https://github.com/JanDeDobbeleer/oh-my-posh) includes themes based on symbols from [dahlbyk/posh-git](https://dahlbyk.github.io/posh-git/)

> [{HEAD-name} S +A ~B -C !D | +E ~F -G !H W]

`S`
- `≡` = The local branch in at the same commit level as the remote branch (`BranchIdenticalStatus`)
- `↑<num>` = The local branch is ahead of the remote branch by the specified number of commits; a `git push` is required to update the remote branch (`BranchAheadStatus`)
- `↓<num>` = The local branch is behind the remote branch by the specified number of commits; a `git pull` is required to update the local branch (`BranchBehindStatus`)

`ABCD` represent the index | `EFGH` represent the working directory
- `+` = Added files
- `~` = Modified files
- `-` = Removed files
- `!` = Conflicted files

`W` represents the overall status of the working directory
- `!` = There are unstaged changes in the working tree (`LocalWorkingStatusSymbol`)
- `~` = There are uncommitted changes i.e. staged changes in the working tree waiting to be committed (`LocalStagedStatusSymbol`)
None = There are no unstaged or uncommitted changes to the working tree (`LocalDefaultStatusSymbol`)

For a more detailed description, review [here](https://github.com/dahlbyk/posh-git?tab=readme-ov-file#git-status-summary-information)


## Resources / References
- [Oh My Posh - A prompt theme engine for any shell](https://ohmyposh.dev/)
- [Posh Git - Git status summary information](https://github.com/dahlbyk/posh-git?tab=readme-ov-file#git-status-summary-information)
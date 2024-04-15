# Notes for VSCode

## Vim Shortcuts

### Switch Modes

```text
i               -- Exit VISUAL mode into INSERT mode
ESC, jj, jk, kj -- Exit INSERT mode into VISUAL mode
```

### Opening / Closing / Exiting

```text
LEADER + f   -- File Quick Open
CTRL + w + q -- Close active File
LEADER + w   -- Save active File
LEADER + q   -- Close active File w/o saving
LEADER + x   -- Save & Quit active File
```

### Navigation

```text
LEADER + \     -- Create a vertical split
CTRL + w v     -- Create a vertical split

LEADER + -     -- Create a horizontal split
CTRL + w s     -- Create a horizontal split

CTRL + h,j,k,l -- Navigate between Windows / Split
SHIFT + h,l    -- Navigate left/right tabs of current split

[ + d          -- Go to Previous Error / Warning
] + d          -- Go to Next Error / Warning

CTRL + o       -- Navigate Back
CTRL + i       -- Navigate Forward

CTRL + j,k     -- Navigate UP / DOWN in menus
h,j,k,l        -- Navigation in Hover Menu (gh)

TAB            -- Toggle focus between right and left peek widget

LEADER + d     -- Add Selection to Next Find Match (CTRL+D alternative)

ALT + j        -- Swap line down
ALT + k        -- Swap line up
```

```text
gd  -- Go to Definition
gpd -- Peek Definition
gh  -- Show Hover
gi  -- Go to Implementations
gpi -- Peek Implementations
gq  -- Quick fix (open the code actions menu)
gr  -- Go to References
gt  -- Go to Type Definition
gpt -- Peek Type Definition
```

### Terminal

```text
CTRL + ,   -- Toggle Between Editor & Terminal (Opens a new terminal if one is not yet open)
CTRL +  n  -- Create a new terminal (when terminal view is focused)
CTRL + a,b -- Switch between terminals (when terminal view is is focused)
CTRL + w   -- Close currently active terminal (when terminal view is focused)

CTRL + u,d         -- Scroll Up / Down Terminal
CTRL + k,j         -- Move Up / Down Terminal (line-by-line)
CTRL + SHIFT + k,j -- Scroll to PREVIOUS / NEXT command
CTRL + SHIFT + u,d -- Scroll to TOP / BOTTOM of Terminal
```

### File Explorer

```text
CTRL + e    -- Toggle File Explorer
LEADER + e  -- Toggle File Explorer
a           -- Create a New File
f           -- Create a New Directory
r           -- Rename currently selected file / directory
x           -- Cut currently selected file / directory
y           -- Copy currently selected file / directory
p           -- Paste currently selected file / directory
d           -- Delete currently selected file / directory
o           -- Open file / directory (& stay in explorer menu)

NAVIGATION
j         -- Navigate UP
k         -- Navigate DOWN
h         -- Navigate to Parent Directory
l         -- Navigate to Child Directory
```

### Find

```text
CTRL + f         -- Search File
CTRL + SHIFT + f -- Global File Search
CTRL + e         -- Toggle back to Editor (when Global File Search is active)
```

### MISC

```text
LEADER + ca   -- Code Actions / Quick Fix
LEADER + p    -- Format Document
CTRL + /      -- Toggle comment
LEADER + c    -- Toggle comment (in VISUAL mode)
SHIFT + j     -- Move selected lines DOWN (in VISUAL mode)
SHIFT + k     -- Move selected lines UP   (in VISUAL mode)
<             -- Outdent lines selected in VISUAL Mode
>             -- Indent lines selected in VISUAL Mode
```

### Vim Surround

- [tpope - vim-surround](https://github.com/tpope/vim-surround)
- [Surrounding Things w/ Vim Surround](https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/surrounding-things-with-vim-surround/)

```text
ys <motion> <desired>   -- Add <desired> surround around text defined by <motion>
ds <existing>           -- Delete <existing> surround
cs <existing> <desired> -- Change <existing> surround to <desired>
SHIFT + s <desired>     -- Surround when in VISUAL mode (surrounds full selection)
```

### Vim Commentary

[tpope - vim-commentary](https://github.com/tpope/vim-commentary)

```text
gcc           -- Toggles comment for current line
gc <movement> -- Toggles line comment from current line to movement
gC            -- Toggles block comment
```

Usage Examples:
- `gc2j` comments current line + next 2 lines down
- `gcl` or `gch` comments current line
- `gCi)` comments out everything within parenthesis

## Resources / References
- [Boost Your Coding Fu w/ VSCode and Vim](https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/cheatsheet)
- [Melkey - Mastering VIM Motions in VSCode (Mouseless Development)](https://www.youtube.com/watch?v=GST8we5uABo)
- [10 VSCode Vim Tricks to Boost Your Productivity](https://dev.to/ansonh/10-vs-code-vim-tricks-to-boost-your-productivity-1b0n)
- [VSCodeVim - vim-surround](https://github.com/VSCodeVim/Vim#vim-surround)
- [tpope - vim-surround](https://github.com/tpope/vim-surround)
- [Surrounding Things w/ Vim Surround](https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/surrounding-things-with-vim-surround/)
- [VSCodeVim - vim-commentary](https://github.com/VSCodeVim/Vim#vim-commentary)
- [tpope - vim-surround](https://github.com/tpope/vim-surround)
- [Splits, Tabs, and Switching Between Them](https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/splitting-windows/)
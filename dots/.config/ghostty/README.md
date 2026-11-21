# Ghostty keybindings

## Dotfiles shortcuts

These bindings come from this repo’s [Ghostty config](./config). `Super` is
the Windows key on most Linux keyboards and `Cmd` on macOS.

| Action                                   | Shortcut                           |
| ---------------------------------------- | ---------------------------------- |
| Toggle the quick terminal globally       | `Super+,`                          |
| Copy the selection                       | `Ctrl+Insert`                      |
| Paste from the clipboard                 | `Shift+Insert`                     |
| Send `Shift+Enter` as CSI-u              | `Shift+Enter`                      |
| Send `Alt+Shift+Enter` as CSI-u for tmux | `Alt+Shift+Enter`                  |
| Resize a split by 100 pixels             | `Super+Ctrl+Alt+Shift` + arrow key |

The global shortcut depends on desktop support. See [Ghostty’s global shortcut documentation](https://ghostty.org/docs/config/keybind#global).

## Built-in shortcuts

Adapted from [FastShortcuts’ Ghostty cheat sheet](https://fastshortcuts.com/shortcuts/ghostty/)
and checked against Ghostty 1.4.0 on Linux and the corresponding
[macOS defaults in Ghostty’s source](https://github.com/ghostty-org/ghostty/blob/v1.4.0/src/config/Config.zig).
A dash indicates no built-in shortcut for that action on the platform.

### Windows and tabs

| Action                       | Linux                                               | macOS                             |
| ---------------------------- | --------------------------------------------------- | --------------------------------- |
| Open a window                | `Ctrl+Shift+N`                                      | `Cmd+N`                           |
| Close the window             | `Alt+F4`                                            | `Cmd+Shift+W`                     |
| Toggle fullscreen            | `Ctrl+Enter`                                        | `Cmd+Enter` or `Cmd+Ctrl+F`       |
| Quit                         | `Ctrl+Shift+Q`                                      | `Cmd+Q`                           |
| Open a tab                   | `Ctrl+Shift+T`                                      | `Cmd+T`                           |
| Close the tab and its splits | `Ctrl+Shift+W`                                      | `Cmd+Option+W`                    |
| Close the focused surface    | -                                                   | `Cmd+W`                           |
| Switch to the next tab       | `Ctrl+Tab`, `Ctrl+Shift+→`, or `Ctrl+Page Down`     | `Cmd+Shift+]` or `Ctrl+Tab`       |
| Switch to the previous tab   | `Ctrl+Shift+Tab`, `Ctrl+Shift+←`, or `Ctrl+Page Up` | `Cmd+Shift+[` or `Ctrl+Shift+Tab` |
| Jump to tabs 1 through 8     | `Alt+1` through `Alt+8`                             | `Cmd+1` through `Cmd+8`           |
| Jump to the last tab         | `Alt+9`                                             | `Cmd+9`                           |
| Move the tab left or right   | `Ctrl+Shift+Page Up` or `Ctrl+Shift+Page Down`      | -                                 |

### Splits

| Action                           | Linux                            | macOS                    |
| -------------------------------- | -------------------------------- | ------------------------ |
| Split to the right               | `Ctrl+Shift+O`                   | `Cmd+D`                  |
| Split below                      | `Ctrl+Shift+E`                   | `Cmd+Shift+D`            |
| Focus previous or next split     | `Ctrl+Super+[` or `Ctrl+Super+]` | `Cmd+[` or `Cmd+]`       |
| Focus a split by direction       | `Ctrl+Alt` + arrow key           | `Cmd+Option` + arrow key |
| Toggle zoom on the focused split | `Ctrl+Shift+Enter`               | `Cmd+Shift+Enter`        |
| Resize a split by 10 pixels      | `Ctrl+Super+Shift` + arrow key   | `Cmd+Ctrl` + arrow key   |
| Equalize split sizes             | -                                | `Cmd+Ctrl+=`             |

### Clipboard and scrollback

| Action                                       | Linux                                      | macOS                                        |
| -------------------------------------------- | ------------------------------------------ | -------------------------------------------- |
| Copy the selection                           | `Ctrl+Shift+C`                             | `Cmd+C`                                      |
| Paste from the clipboard                     | `Ctrl+Shift+V`                             | `Cmd+V`                                      |
| Paste from the primary selection             | `Shift+Insert` (overridden by this config) | `Cmd+Shift+V`                                |
| Clear the screen                             | -                                          | `Cmd+K`                                      |
| Scroll to the top or bottom                  | `Shift+Home` or `Shift+End`                | `Cmd+Home` or `Cmd+End`                      |
| Scroll a page up or down                     | `Shift+Page Up` or `Shift+Page Down`       | `Cmd+Page Up` or `Cmd+Page Down`             |
| Jump to the previous or next shell prompt    | `Ctrl+Shift+↑` or `Ctrl+Shift+↓`           | `Cmd+↑` or `Cmd+↓` (also works with `Shift`) |
| Save scrollback to a file and paste its path | `Ctrl+Shift+J`                             | `Cmd+Shift+J`                                |
| Save scrollback to a file and open it        | `Ctrl+Alt+Shift+J`                         | `Cmd+Option+Shift+J`                         |

### Font size and configuration

| Action                        | Linux                | macOS              |
| ----------------------------- | -------------------- | ------------------ |
| Increase font size            | `Ctrl+=` or `Ctrl++` | `Cmd+=` or `Cmd++` |
| Decrease font size            | `Ctrl+-`             | `Cmd+-`            |
| Reset font size               | `Ctrl+0`             | `Cmd+0`            |
| Open the config               | `Ctrl+,`             | `Cmd+,`            |
| Reload the config             | `Ctrl+Shift+,`       | `Cmd+Shift+,`      |
| Toggle the terminal inspector | `Ctrl+Shift+I`       | `Cmd+Option+I`     |

## Check or change your bindings

Run the first command to list your effective bindings and the second to list
the defaults for your installed version.

```sh
ghostty +list-keybinds
ghostty +list-keybinds --default
```

Add a `keybind = trigger=action` line to [config](./config) and use the reload
shortcut above. See [Ghostty’s keybinding reference](https://ghostty.org/docs/config/keybind)
and [available actions](https://ghostty.org/docs/config/keybind/reference).

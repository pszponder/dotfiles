#!/usr/bin/env bash

# https://gist.github.com/elijahmanor/c10e5787bf9ac6b8c276e47e6745826c
# https://www.youtube.com/watch?v=mQdB_kHyZn8
# https://www.youtube.com/watch?v=b_FSqS4C1Ns
# To setup a new font: Place your fonts in a new directory in ~/.local/share/fonts
# Run fc-cache -f -v to rebuild your font cache
# Run fc-list | grep "<your font name>" to list the installed fonts

# List of Fonts to Try:
# https://www.nerdfonts.com/font-downloads
# https://github.com/githubnext/monaspace
# https://github.com/JetBrains/JetBrainsMono
# https://github.com/microsoft/cascadia-code
# https://tosche.net/fonts/comic-code (PAID FONT)

smoke_tests="Normal
\033[1mBold\033[22m
\033[3mItalic\033[23m
\033[3;1mBold Italic\033[0m
\033[4mUnderline\033[24m
== === !== >= <= =>
󰐊     󰄉      󰑓 󰒲 "

printf "%b" "${smoke_tests}"
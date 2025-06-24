#!/usr/bin/env bash

# Run this to check that all of your nerd fonts are working correctly

smoke_tests="Normal
\033[1mBold\033[22m
\033[3mItalic\033[23m
\033[3;1mBold Italic\033[0m
\033[4mUnderline\033[24m
== === !== >= <= =>
Nerdfont
         󰾆      󰢻   󱑥   󰒲   󰗼
Fontawesome Free
                        

"


printf "%b" "${smoke_tests}"
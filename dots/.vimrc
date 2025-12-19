" Basic Vim Configuration

" Enable syntax highlighting
syntax on

" Show line numbers and relative numbers
set number
set relativenumber

" Tab and indentation settings
set tabstop=4       " Number of spaces that a <Tab> in the file counts for
set shiftwidth=4    " Number of spaces to use for each step of (auto)indent
set expandtab       " Use spaces instead of tabs
set autoindent
set smartindent

" Search settings
set hlsearch        " Highlight all search matches
set incsearch       " Show matches as you type
set ignorecase      " Case-insensitive search...
set smartcase       " ...unless uppercase used

" Clipboard and mouse
set clipboard=unnamedplus  " Use system clipboard
set mouse=a                " Enable mouse support

" Enable filetype detection and plugins
filetype plugin indent on

" Wrapping
set wrap             " Wrap long lines

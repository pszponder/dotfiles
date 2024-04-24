local opt = vim.opt

vim.cmd("let g:netrw_liststyle = 3")

-- line & line numbers
opt.relativenumber = true
opt.number = true
opt.cursorline = true -- Enable highlighting of the current line

-- tabs & indentation
opt.tabstop = 4        -- Number of spaces to represent a tab character visually (e.g., in normal mode)
opt.softtabstop = 4    -- Number of spaces inserted when pressing the Tab key in insert mode, and affects backspace behavior
opt.shiftwidth = 4     -- spaces for indent width
opt.expandtab = false  -- expand tab to spaces
opt.autoindent = true  -- copy indent from current line when starting new one
opt.smartindent = true -- Insert indents automatically
opt.breakindent = true -- Enable automatic indentation of wrapped lines

opt.wrap = true        -- Enables text wrapping, lines will automatically wrap at the edge of the screen

-- mouse
opt.mouse = "a" -- Enable mouse mode


-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true -- True color support
opt.background = "dark"  -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"   -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom
opt.splitkeep = "screen"

-- Autowrite
opt.autowrite = true -- Enable auto write

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Conceal
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions

-- Confirmation
opt.confirm = true -- Confirm to save changes before exiting modified buffer

-- Format options
opt.formatoptions = "jcroqlnt" -- tcqj

-- Grep
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Incremental command
opt.inccommand = "split" -- Preview incremental substitute

-- Statusline
opt.laststatus = 3 -- Global statusline

-- Display whitespace characters like tabs and trailing spaces
opt.list = true -- Show some invisible characters (tabs...)
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Popup settings
opt.pumblend = 10  -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup

-- Scrolling
opt.scrolloff = 4 -- Lines of context

-- Session options
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Round indent
opt.shiftround = true -- Round indent

-- Short messages
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Mode
opt.showmode = false -- Don't show mode since we have a statusline

-- Context columns
opt.sidescrolloff = 8 -- Columns of context

-- Spellcheck language
opt.spelllang = { "en" }

-- Timeout
if not vim.g.vscode then
  opt.timeoutlen = 300 -- Lower than default (1000) to quickly trigger which-key
end

-- Undo
opt.undofile = true
opt.undolevels = 10000

-- Update time
opt.updatetime = 200 -- Save swap file and trigger CursorHold

-- Virtual edit
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

-- Wildmode
opt.wildmode = "longest:full,full" -- Command-line completion mode

-- Minimum window width
opt.winminwidth = 5

-- Fill characters
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Smooth scroll (if supported)
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

-- Folding
opt.foldlevel = 99

-- Markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Customize short messages
opt.shortmess:append({ W = true, I = true, c = true, C = true })

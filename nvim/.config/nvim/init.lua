-- [[Install and setup `lazy.nvim` plugin manager]]
-- To check the current status of your plugins, run => :Lazy
-- You can press `?` in the menu for help. Use `:q` to close the window
-- To update plugins you can run => :Lazy update
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("core")
require("lazy").setup("plugins")


-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.number = true
vim.opt.relativenumber = true
vim.g.autoformat = false

vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("relative-line-numbers", { clear = true }),
  callback = function(args)
    vim.opt.relativenumber = args.event == "InsertLeave"
  end,
})

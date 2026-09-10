return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true,
        integrations = {
          bufferline = true,
          telescope = true,
          notify = true,
          nvimtree = true,
          which_key = true,
          gitsigns = true,
          treesitter = true,
          cmp = true,
          lsp_trouble = true,
          mason = true,
          mini = true,
          indent_blankline = {
            enabled = true,
            scope_color = "lavender",
            colored_indent_levels = false,
          },
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

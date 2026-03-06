return {
  -- 1. Install and configure the catppuccin colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,  -- make sure it's loaded early
    config = function()
      require("catppuccin").setup({
        -- optional: set your preferred flavour & options here
        flavour = "mocha",  -- latte, frappe, macchiato, mocha
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

      -- Apply the colorscheme
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  -- 2. Tell LazyVim to use catppuccin as the default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

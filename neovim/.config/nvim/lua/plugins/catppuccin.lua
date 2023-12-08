-- https://www.joshmedeski.com/posts/create-a-neovim-ide-with-lazyvim/
-- https://github.com/catppuccin/nvim

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		---@class CatppuccinOptions
		opts = {
			transparent_background = false,
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			no_italic = false, -- Force no italic
			no_bold = false, -- Force no bold
			no_underline = false, -- Force no underline
			integrations = {
				cmp = true,
				gitsigns = true,
				nvimtree = true,
				treesitter = true,
				notify = false,
				mini = {
					enabled = true,
					indentscope_color = "",
				},
			},
		},
	},
}

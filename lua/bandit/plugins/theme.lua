return {
	-- Evergarden theme
	{
		"everviolet/nvim",
		name = "evergarden",
		lazy = false,
		priority = 1000,
		config = function()
			require("evergarden").setup({
				variant = "winter",
			})
			vim.cmd.colorscheme("evergarden")
		end,
	},

	{
		"binbandit/AutumnCozy.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- require("autumncozy").setup()
		end,
	},

	-- Aetherglow Them
	{
		"binbandit/aetherglow.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- require("aetherglow").setup({
			-- 	variant = "dark_bold",
			-- 	transparent = "full",
			-- })
		end,
	},

	-- Oldworld theme
	-- {
	-- 	"dgox16/oldworld.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("oldworld").setup({
	-- 			terminal_colors = true,
	-- 			variant = "default",
	-- 			styles = {
	-- 				comments = { italic = true },
	-- 				keywords = { bold = true },
	-- 				identifiers = {},
	-- 				functions = {},
	-- 				variables = {},
	-- 				booleans = { bold = true },
	-- 			},
	-- 			integrations = {
	-- 				alpha = true,
	-- 				cmp = true,
	-- 				flash = false,
	-- 				gitsigns = true,
	-- 				hop = false,
	-- 				indent_blankline = true,
	-- 				lazy = true,
	-- 				lsp = true,
	-- 				markdown = true,
	-- 				mason = true,
	-- 				navic = true,
	-- 				neo_tree = false,
	-- 				neogit = false,
	-- 				neorg = false,
	-- 				noice = false,
	-- 				notify = false,
	-- 				rainbow_delimiters = true,
	-- 				telescope = false,
	-- 				treesitter = true,
	-- 			},
	-- 			highlight_overrides = {},
	-- 		})
	-- 		vim.cmd.colorscheme("oldworld")
	-- 	end,
	-- },

	-- Achroma theme
	{
		"binbandit/achroma.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- require("achroma").setup({
			-- 	mode = "dark",
			-- 	variant = "black",
			-- 	inverse_popup = true,
			-- })
			-- vim.cmd.colorscheme("achroma")
		end,
	},

	-- Serene Horizon theme
	-- {
	--     'binbandit/serene-horizon.nvim',
	--     lazy = false,
	--     priority = 1000,
	--     config = function()
	--         vim.cmd.colorscheme 'serene-horizon'
	--     end,
	-- },
}

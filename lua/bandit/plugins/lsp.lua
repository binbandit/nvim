vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter for better coloring etc
  { src = "https://github.com/neovim/nvim-lspconfig" },           -- basic config for lsp
  { src = "https://github.com/rafamadriz/friendly-snippets" },    -- snippet system
  { src = "https://github.com/saghen/blink.cmp" },                -- completion system
  { src = "https://github.com/folke/lazydev.nvim" },              -- proper lua completion
  { src = "https://github.com/mason-org/mason.nvim" },            -- mason for language server install
})

-- LSP
local servers = { "lua_ls", "biome", "emmetls" }
local server_names = vim.tbl_keys(servers)

vim.lsp.enable(servers)
require "nvim-treesitter.configs".setup({
  ensure_installed = { "typescript", "javascript", "css" },
  highlight = { enable = true }
})

-- mason

require "mason".setup({
  -- Pip configuration
  pip = {
    upgrade_pip = true,
    install_args = { "--no-cache-dir" }
  }
})

-- completion
require "blink.cmp".setup()

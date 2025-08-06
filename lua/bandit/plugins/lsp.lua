vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter for better coloring etc
  { src = "https://github.com/neovim/nvim-lspconfig" },           -- basic config for lsp
  { src = "https://github.com/rafamadriz/friendly-snippets" },    -- snippet system
  { src = "https://github.com/saghen/blink.cmp" },                -- completion system
  { src = "https://github.com/folke/lazydev.nvim" },              -- proper lua completion
  { src = "https://github.com/mason-org/mason.nvim" },            -- mason for language server install
})

-- LSP
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
require "blink.cmp".setup({
  keymap = { preset = "default" },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },
  signature = { enabled = true }
})

-- lsp
-- List of servers to set up
local servers = { "lua_ls", "biome" }  -- Add servers you need here

vim.lsp.enable(servers)

local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()

for _, server in ipairs(servers) do
  lspconfig[server].setup({ capabilities = capabilities })
end

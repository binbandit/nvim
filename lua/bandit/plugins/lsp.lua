vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter for better coloring etc
  { src = "https://github.com/neovim/nvim-lspconfig" },           -- basic config for lsp
  { src = "https://github.com/rafamadriz/friendly-snippets" },    -- snippet system
  { src = "https://github.com/saghen/blink.cmp" },                -- completion system
  { src = "https://github.com/folke/lazydev.nvim" },              -- proper lua completion
  { src = "https://github.com/mason-org/mason.nvim" },            -- mason for language server install
  { src = "https://github.com/pmizio/typescript-tools.nvim" },    -- better typescript LSP
  { src = "https://github.com/mrcjkb/rustaceanvim" },             -- better rust LSP
  { src = "https://github.com/ray-x/go.nvim" },                   -- better golsp
})

-- LSP
require "nvim-treesitter.configs".setup({
  ensure_installed = { "typescript", "javascript", "css" },
  highlight = { enable = true }
})

require "typescript-tools".setup({
  settings = {
    jsx_close_tag = {
      enable = true,
      filetypes = { "javascriptreact", "typescriptreact" }
    },
    tsserver_plugins = {
      "@styled/typescript-styled-plugins",
    }
  }
})

require "go".setup({})

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").goimports()
  end,
  group = format_sync_grp
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
  keymap = { preset = "super-tab" },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono'
  },
  fuzzy = { implementation = "lua" },
  signature = { enabled = true }
})

-- lsp
-- List of servers to set up
local servers = { "lua_ls" } -- Add servers you need here

vim.lsp.enable(servers)

local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()

for _, server in ipairs(servers) do
  lspconfig[server].setup({ capabilities = capabilities })
end

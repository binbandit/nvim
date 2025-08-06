vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter for better coloring etc
  { src = "https://github.com/neovim/nvim-lspconfig" },           -- basic config for lsp
  { src = "https://github.com/rafamadriz/friendly-snippets" },    -- snippet system
  { src = "https://github.com/saghen/blink.cmp" },                -- completion system
  { src = "https://github.com/folke/lazydev.nvim" },              -- proper lua completion
  { src = "https://github.com/mason-org/mason.nvim" },            -- mason for language server install
})

-- LSP
local servers = { "lua_ls", "biome", "tinymist", "emmetls" }
local server_names = vim.tbl_keys(servers)

vim.lsp.enable(servers)
require "nvim-treesitter.configs".setup({
  ensure_installed = { "typescript", "javascript" },
  highlight = { enable = true }
})

-- mason

require "mason".setup({
  ui = {
    border = "rounded", -- Use rounded borders for the Mason window
    icons = {
      package_installed = "✅",
      package_pending = "⏳",
      package_uninstalled = "❌"
    }
  },

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
    nerd_font_variant = 'mono'
  },
  completion = {
    -- only show the documentation popup when manually triggered
    documentation = { auto_show = false },
  },
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  },
  fuzzy = { implementation = 'lua' },
})

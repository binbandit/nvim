vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter for better coloring etc
  { src = "https://github.com/neovim/nvim-lspconfig" },           -- basic config for lsp
  { src = "https://github.com/rafamadriz/friendly-snippets" },    -- snippet system
  { src = "https://github.com/saghen/blink.cmp" },                -- completion system
  { src = "https://github.com/folke/lazydev.nvim" },              -- proper lua completion
  { src = "https://github.com/mason-org/mason.nvim" },            -- mason for language server install
  { src = "https://github.com/pmizio/typescript-tools.nvim" },    -- better typescript LSP
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
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeCompletionsForModuleExports = true,
      quotePreference = "auto"
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
  fuzzy = {
    prebuilt_binaries = {
      download = false,  -- Don't download prebuilt binaries
    }
  },
  signature = { enabled = true }
})

-- lsp
local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Lua LSP with proper Neovim support
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = 'LuaJIT',
        -- Setup your lua path
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Add lazydev.nvim types
          '${3rd}/luv/library',
        },
      },
      telemetry = {
        enable = false,
      },
    })
  end,
  settings = {
    Lua = {}
  }
})

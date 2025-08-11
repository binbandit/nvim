-- Built-in packages (Neovim 0.12+): vim.pack.add
local pack = vim.pack
if not (pack and type(pack.add) == 'function') then
  vim.schedule(function()
    vim.notify('vim.pack.add not found. Use Neovim 0.12+ (nightly) to load plugins.', vim.log.levels.ERROR)
  end)
  return
end

local P = require('utils.pack')

local specs = {
  -- Core & UI
  { src = 'nvim-lua/plenary.nvim' },
  { src = 'folke/tokyonight.nvim' },
  { src = 'nvim-lualine/lualine.nvim' },
  { src = 'lewis6991/gitsigns.nvim' },
  { src = 'folke/which-key.nvim' },
  { src = 'echasnovski/mini.nvim' },
  { src = 'nvim-tree/nvim-web-devicons' },
  { src = 'folke/snacks.nvim' },
  { src = 'folke/flash.nvim' },
  { src = 'stevearc/oil.nvim' },
  { src = 'benomahony/oil-git.nvim' },

  -- Finder
  { src = 'ibhagwan/fzf-lua' },

  -- Syntax & Treesitter
  { src = 'nvim-treesitter/nvim-treesitter' },
  { src = 'windwp/nvim-ts-autotag' },

  -- LSP + Completion + Tools
  { src = 'neovim/nvim-lspconfig' },
  { src = 'williamboman/mason.nvim' },
  { src = 'williamboman/mason-lspconfig.nvim' },
  { src = 'saghen/blink.cmp', version = vim.version.range('1.*') },
  { src = 'stevearc/conform.nvim' },

  -- Language extras
  { src = 'mrcjkb/rustaceanvim' },
  { src = 'pmizio/typescript-tools.nvim' },

  -- Diagnostics / Git / AI / QOL
  { src = 'folke/trouble.nvim' },
  { src = 'kdheepak/lazygit.nvim' },
  { src = 'supermaven-inc/supermaven-nvim' },
  { src = 'folke/todo-comments.nvim' },
}

local ok_add, err = P.add(specs)
if not ok_add then
  vim.schedule(function()
    vim.notify('vim.pack.add error: ' .. tostring(err), vim.log.levels.ERROR)
  end)
end

-- Load plugin configs (pcall so first-time installs don’t error)
local function req(name)
  local ok, mod = pcall(require, name)
  if not ok then
    vim.schedule(function() vim.notify(('Plugin config %s failed to load'):format(name), vim.log.levels.WARN) end)
  end
  return mod
end

-- Theme first
req('plugins.tokyonight')

req('plugins.fzf')
req('plugins.nvim-treesitter')
req('plugins.which-key')
req('plugins.mini')
req('plugins.gitsigns')
req('plugins.lualine')
req('plugins.snacks')
req('plugins.flash')
req('plugins.oil')
req('plugins.ts-autotag')
req('plugins.trouble')
req('plugins.lazygit')
req('plugins.todo-comments')
req('plugins.blink')
req('plugins.conform')
req('plugins.lsp')
req('plugins.rustaceanvim')
req('plugins.typescript-tools')
req('plugins.supermaven')

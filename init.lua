-- Leader keys must be set early
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Disable netrw; use a modern file manager instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Core settings and UX
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Opt-in to any new LSP default behavior if available (0.12+)
pcall(function()
  if vim.lsp and type(vim.lsp.enable) == 'function' then
    vim.lsp.enable()
  end
end)

-- Plugins via Neovim built-in package manager (0.12+)
require('plugins')

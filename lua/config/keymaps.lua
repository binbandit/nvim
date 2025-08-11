local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend('force', { noremap = true, silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Basic
map('n', '<Esc>', '<cmd>nohlsearch<cr>')
map('n', 'x', '"_x')

-- Save/Quit
map('n', '<leader>w', '<cmd>update<cr>')
map('n', '<leader>q', '<cmd>qa<cr>')
map('n', '<leader>qq', '<cmd>qa!<cr>', { desc = 'Quit all (force)' })
-- Ctrl+S to save across modes
map('n', '<C-s>', '<cmd>update<cr>', { desc = 'Save file' })
map('i', '<C-s>', function()
  vim.cmd('update')
end, { desc = 'Save file' })
map('v', '<C-s>', function()
  vim.cmd('update')
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
end, { desc = 'Save file' })

-- Windows
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<leader>sv', '<C-w>v')
map('n', '<leader>sh>', '<C-w>s')

-- Buffers
map('n', '<S-l>', ':bnext<cr>')
map('n', '<S-h>', ':bprevious<cr>')
map('n', '<leader>bd', function()
  local ok, br = pcall(require, 'mini.bufremove')
  if ok then br.delete(0, false) else vim.cmd.bdelete() end
end, { desc = 'Delete buffer' })

-- Finder: fzf-lua (bindings that resolve plugin at call time)
local function fzf_call(method, ...)
  local args = { ... }
  return function()
    local ok, fzf = pcall(require, 'fzf-lua')
    if not ok then return vim.notify('fzf-lua not available yet', vim.log.levels.WARN) end
    local fn = fzf[method]
    if type(fn) == 'function' then return fn(unpack(args)) end
  end
end

map('n', '<leader><leader>', fzf_call('files'), { desc = 'Find files' })
map('n', '<leader>/', fzf_call('live_grep'), { desc = 'Live grep' })
map('n', '<leader>ff', fzf_call('files'), { desc = 'Find files' })
map('n', '<leader>fg', fzf_call('live_grep'), { desc = 'Live grep' })
map('n', '<leader>fb', fzf_call('buffers'), { desc = 'Buffers' })
map('n', '<leader>fo', fzf_call('oldfiles'), { desc = 'Old files' })
map('n', '<leader>fh', fzf_call('helptags'), { desc = 'Help' })
map('n', '<leader>fw', fzf_call('grep_cword'), { desc = 'Grep word' })
map('n', '<leader>gs', fzf_call('git_status'), { desc = 'Git status (fzf)' })
map('n', '<leader>gf', fzf_call('git_files'), { desc = 'Git files (fzf)' })
map('n', '<leader>sb', fzf_call('builtin'), { desc = 'fzf builtin pickers' })
map('n', '<leader>ss', fzf_call('lsp_document_symbols'), { desc = 'Document symbols (fzf)' })
map('n', '<leader>sS', fzf_call('lsp_live_workspace_symbols'), { desc = 'Workspace symbols (fzf)' })

-- Oil file explorer
map('n', '<leader>e', function()
  local ok, oil = pcall(require, 'oil')
  if not ok then return end
  oil.open()
  vim.cmd('only')
end, { desc = 'File explorer (Oil)' })

map('n', '-', function()
  local ok, oil = pcall(require, 'oil')
  if not ok then return end
  oil.open(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h'))
  vim.cmd('only')
end, { desc = 'Open parent directory (Oil)' })

-- Diagnostics quick help
map('n', 'gl', vim.diagnostic.open_float, { desc = 'Line diagnostics' })

-- Toggle terminal
map('n', '<leader>tt', function()
  require('utils.terminal').toggle()
end, { desc = 'Toggle terminal' })

-- Terminal: Ctrl+\ to toggle (normal and terminal modes)
map('n', [[<C-\>]], function()
  require('utils.terminal').toggle()
end, { desc = 'Toggle terminal' })
map('t', [[<C-\>]], function()
  require('utils.terminal').toggle()
end, { desc = 'Toggle terminal' })

-- Toggle inlay hints
map('n', '<leader>th', function()
  local ih = vim.lsp.inlay_hint
  if not ih then return end
  local bufnr = 0
  local enabled = false
  if ih.is_enabled then
    local ok, val = pcall(ih.is_enabled, ih, { bufnr = bufnr })
    enabled = ok and val or false
  end
  local ok_new = pcall(ih.enable, ih, not enabled, { bufnr = bufnr })
  if not ok_new then pcall(ih.enable, ih, bufnr, not enabled) end
end, { desc = 'Toggle inlay hints' })

-- Quick toggles
map('n', '<leader>tw', function() vim.opt.wrap = not vim.wo.wrap end, { desc = 'Toggle wrap' })
map('n', '<leader>tr', function()
  local o = vim.opt.relativenumber:get()
  vim.opt.relativenumber = not o
end, { desc = 'Toggle relativenumber' })
map('n', '<leader>pu', function()
  local ok, err = pcall(vim.pack.update)
  if not ok then vim.notify('vim.pack.update failed: ' .. tostring(err), vim.log.levels.ERROR) end
end, { desc = 'Pack update (confirm)' })

-- Folding helpers
map('n', '<leader>zf', 'za', { desc = 'Toggle fold' })
map('n', '<leader>zM', 'zM', { desc = 'Fold all' })
map('n', '<leader>zR', 'zR', { desc = 'Unfold all' })

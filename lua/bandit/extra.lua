-- yank group
local augroup = vim.api.nvim_create_augroup
local yank_group = augroup('HighlightYank', {})
local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

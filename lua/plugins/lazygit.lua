-- LazyGit integration (requires LazyGit installed)
vim.keymap.set('n', '<leader>gg', function()
  local ok = pcall(vim.cmd, 'LazyGit')
  if not ok then vim.notify('LazyGit not installed', vim.log.levels.WARN) end
end, { desc = 'LazyGit' })


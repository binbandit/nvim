-- vim-be-good: A plugin to help learn Vim movements through games
-- Only loads when learning mode is enabled

return {
  'ThePrimeagen/vim-be-good',
  -- Only load this plugin if learning mode is enabled
  enabled = function()
    return require('learning-mode').is_enabled()
  end,
  cmd = 'VimBeGood',
  config = function()
    -- Optional: Add any vim-be-good specific configuration here
    vim.notify("Vim Be Good loaded! Use :VimBeGood to start practicing", vim.log.levels.INFO)
  end,
}
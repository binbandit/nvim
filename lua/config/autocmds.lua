local aug = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

-- Highlight on yank
au('TextYankPost', {
  group = aug('YankHighlight', { clear = true }),
  callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 150 }) end,
})

-- Equalize splits
au('VimResized', { group = aug('ResizeSplits', { clear = true }), command = 'wincmd =' })

-- Open help in vertical split right side
au('FileType', {
  group = aug('HelpWinRight', { clear = true }),
  pattern = 'help',
  command = 'wincmd L',
})

-- Use Oil as default directory browser (e.g., `nvim .`) and full-screen
au('VimEnter', {
  group = aug('OilOnDir', { clear = true }),
  callback = function()
    if vim.fn.argc() == 1 then
      local arg = vim.fn.argv(0)
      if arg and vim.fn.isdirectory(arg) == 1 then
        local ok, oil = pcall(require, 'oil')
        if ok then
          oil.open(arg)
          vim.cmd('only')
        end
      end
    end
  end,
})

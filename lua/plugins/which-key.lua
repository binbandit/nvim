local ok, wk = pcall(require, 'which-key')
if not ok then return end

wk.setup({ plugins = { spelling = true }, window = { border = 'rounded' } })

wk.add({
  { '<leader>f', group = 'Find/Format' },
  { '<leader>g', group = 'Git' },
  { '<leader>c', group = 'Code' },
  { '<leader>t', group = 'Toggle' },
  { '<leader>w', desc = 'Save' },
  { '<leader>q', desc = 'Quit' },
  { '<leader>e', desc = 'Explorer' },
})


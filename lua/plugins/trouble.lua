local ok, trouble = pcall(require, 'trouble')
if not ok then return end

trouble.setup({ use_diagnostic_signs = true })

local map = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc, silent = true, noremap = true })
end

map('<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', 'Diagnostics (toggle)')
map('<leader>xw', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', 'Diagnostics (buffer)')
map('<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', 'Symbols')
map('<leader>xq', '<cmd>Trouble qflist toggle<cr>', 'Quickfix')
map('<leader>xl', '<cmd>Trouble loclist toggle<cr>', 'Loclist')
map('gR', '<cmd>Trouble lsp_references toggle<cr>', 'LSP References')


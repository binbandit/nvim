local ok, todo = pcall(require, 'todo-comments')
if not ok then return end

todo.setup({ signs = true })

-- Trouble integration
vim.keymap.set('n', '<leader>xt', '<cmd>TodoTrouble<cr>', { desc = 'TODOs (Trouble)' })


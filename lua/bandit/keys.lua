local km = vim.keymap
local bufnr = vim.api.nvim_get_current_buf()

km.set('n', '<leader>o', ':update<CR> :source<CR>')

-- quit
km.set("n", "<leader>qq", "<cmd>qa<CR>", { desc = "quit all" })

-- save
km.set("n", "<C-s>", ":write<CR>", { desc = "save file" })  -- save in normal mode, return to normal mode
km.set("i", "<C-s>", "<cmd>w<CR>a", { desc = "save file" }) -- save in edit mode, and return to edit mode
km.set("v", "<C-s>", "<cmd>w<CR>a", { desc = "save file" }) -- save in visual mode, and return to normal mode

-- code
km.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "format file" })
km.set("n", "<leader>a", function()
  vim.cmd.RustLsp('codeAction')
end, { silent = true, buffer = bufnr, desc = "Launch code actions" })
km.set("n", "K", function()
  vim.cmd.RustLsp({ 'hover', 'actions' })
end, { silent = true, buffer = bufnr })

-- navigation
km.set("n", "<leader>e", ":Oil<CR>", { desc = "Open file navigator" })
km.set("n", "<leader><leader>", ":FzfLua files<CR>", { desc = "find files" })
km.set("n", "<leader>?", ":FzfLua help_tags<CR>", { desc = "find help" })
km.set("n", "<leader>/", ":FzfLua live_grep<CR>", { desc = "project wide search" })
km.set("n", "<leader>fb", ":FzfLua buffers<CR>", { desc = "find buffers" })
km.set("n", "<leader>mm", MiniMap.toggle, { desc = "open minimap" })

-- window management
km.set("n", "<leader>|", "<C-w>v", { desc = "Split window vertically" })
km.set("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
km.set("n", "<leader>ws", "<C-w>s", { desc = "Split window horizontally" })

-- window navigation
km.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
km.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
km.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
km.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- undo
km.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Toggle the undo tree" })

-- ui
km.set('n', '<leader>tt', ":Twilight<CR>", { desc = "Toggle twilight" })

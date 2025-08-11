local ok, flash = pcall(require, 'flash')
if not ok then return end

flash.setup({
  modes = { search = { enabled = true }, char = { enabled = true } },
})

-- Quick jump
vim.keymap.set({ 'n', 'x', 'o' }, 's', flash.jump, { desc = 'Flash jump' })
vim.keymap.set({ 'n', 'x', 'o' }, 'S', flash.treesitter, { desc = 'Flash treesitter' })


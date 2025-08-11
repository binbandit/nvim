local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then return end

gitsigns.setup({
  signs = {
    add = { text = '▎' }, change = { text = '▎' }, delete = { text = '' }, topdelete = { text = '' }, changedelete = { text = '▎' },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local map = function(mode, l, r, opts)
      opts = vim.tbl_extend('force', { noremap = true, silent = true, buffer = bufnr }, opts or {})
      vim.keymap.set(mode, l, r, opts)
    end
    map('n', ']h', gs.next_hunk, { desc = 'Next hunk' })
    map('n', '[h', gs.prev_hunk, { desc = 'Prev hunk' })
    map('n', '<leader>hs', gs.stage_hunk, { desc = 'Stage hunk' })
    map('n', '<leader>hr', gs.reset_hunk, { desc = 'Reset hunk' })
    map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = 'Blame line' })
  end,
})


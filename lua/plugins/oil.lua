local ok, oil = pcall(require, 'oil')
if not ok then return end

-- Enable git status column via oil-git
pcall(function()
  require('oil-git').setup()
end)

oil.setup({
  default_file_explorer = true,
  columns = { 'icon', 'git' },
  view_options = { show_hidden = false },
  skip_confirm_for_simple_edits = true,
  keymaps = {
    ['<C-s>'] = { callback = function() vim.cmd('update') end, desc = 'Save (no split)' },
  },
})

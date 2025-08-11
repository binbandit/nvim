local ok, sm = pcall(require, 'supermaven-nvim')
if not ok then return end

sm.setup({
  keymaps = { -- we'll handle Tab ourselves
    accept_suggestion = false,
    clear_suggestion = '<C-]>',
  },
  disable_inline_completion = false,
  log_level = 'warn',
})

-- Persisted enable/disable
local ai = require('utils.ai_toggle')
ai.apply()

-- Toggle map
vim.keymap.set('n', '<leader>ta', ai.toggle, { desc = 'Toggle AI (Supermaven)' })

-- SuperTab: prefer AI suggestion; otherwise fall back to Blink or Tab
vim.keymap.set('i', '<Tab>', function()
  local ok_prev, prev = pcall(require, 'supermaven-nvim.completion_preview')
  if ok_prev and prev and prev.has_suggestion and prev.has_suggestion() then
    prev.accept()
    return ''
  end
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes('<C-n>', true, false, true)
  end
  return vim.api.nvim_replace_termcodes('<C-Space>', true, false, true)
end, { expr = true, silent = true, remap = true, desc = 'AI accept or Tab' })

vim.keymap.set('i', '<S-Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return vim.api.nvim_replace_termcodes('<C-p>', true, false, true)
  end
  return vim.api.nvim_replace_termcodes('<BS>', true, false, true)
end, { expr = true, silent = true, remap = true, desc = 'Prev completion or backspace' })

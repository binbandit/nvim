local ok, fzf = pcall(require, 'fzf-lua')
if not ok then return end

fzf.setup({
  winopts = {
    border = 'rounded',
    hl = { border = 'FloatBorder', normal = 'NormalFloat' },
    preview = { default = 'bat', border = 'noborder' },
  },
  fzf_colors = true,
  files = { prompt = 'Files❯ ' },
  grep = { prompt = 'Grep❯ ', rg_opts = '--hidden -g !.git -g !node_modules' },
  oldfiles = { include_current_session = true },
  keymap = { builtin = { ['<C-d>'] = 'preview-page-down', ['<C-u>'] = 'preview-page-up' } },
})

-- Use fzf-lua for vim.ui.select
pcall(function()
  fzf.register_ui_select()
end)

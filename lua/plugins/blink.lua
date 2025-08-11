local ok, blink = pcall(require, 'blink.cmp')
if not ok then return end

blink.setup({
  keymap = {
    preset = 'default', -- keep defaults, we override <Tab> via Supermaven
    ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<CR>'] = { 'accept', 'fallback' },
  },
  appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = 'mono' },
  completion = {
    list = { selection = { preselect = true, auto_insert = true } },
    menu = { border = 'rounded' },
    documentation = { auto_show = true, window = { border = 'rounded' } },
  },
  sources = { default = { 'lsp', 'path', 'buffer' } },
})

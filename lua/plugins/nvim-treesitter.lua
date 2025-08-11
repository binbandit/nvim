local ok, ts = pcall(require, 'nvim-treesitter.configs')
if not ok then return end

ts.setup({
  ensure_installed = {
    'lua', 'vim', 'vimdoc', 'query',
    'rust', 'go', 'javascript', 'typescript', 'tsx',
    'json', 'yaml', 'toml', 'bash', 'markdown', 'markdown_inline',
    'python', 'html', 'css'
  },
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
})


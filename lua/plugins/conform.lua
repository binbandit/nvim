local ok, conform = pcall(require, 'conform')
if not ok then return end

conform.setup({
  notify_on_error = true,
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt' },
    go = { 'goimports', 'gofmt' },
    javascript = { 'prettierd', 'prettier' },
    typescript = { 'prettierd', 'prettier' },
    javascriptreact = { 'prettierd', 'prettier' },
    typescriptreact = { 'prettierd', 'prettier' },
    json = { 'jq' },
    yaml = { 'yamlfmt' },
    python = { 'isort', 'black' },
    sh = { 'shfmt' },
    markdown = { 'prettierd', 'prettier' },
  },
  format_on_save = function(bufnr)
    local disable_ft = { 'sql' }
    if vim.tbl_contains(disable_ft, vim.bo[bufnr].filetype) then return end
    return { lsp_fallback = true, timeout_ms = 2000 }
  end,
})

-- Keymaps
vim.keymap.set('n', '<leader>f', function()
  require('conform').format({ async = true, lsp_fallback = true })
end, { desc = 'Format buffer' })


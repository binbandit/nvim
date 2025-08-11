local ok, autotag = pcall(require, 'nvim-ts-autotag')
if not ok then return end

autotag.setup({
  filetypes = { 'html', 'xml', 'javascript', 'javascriptreact', 'typescriptreact', 'tsx' },
})


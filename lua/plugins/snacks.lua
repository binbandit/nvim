local ok, snacks = pcall(require, 'snacks')
if not ok then return end

snacks.setup({
  input = { enabled = true },
  indent = { enabled = true, scope = { enabled = true }, animate = { enabled = false } },
})


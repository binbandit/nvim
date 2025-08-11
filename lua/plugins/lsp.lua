local ok_lsp, lspconfig = pcall(require, 'lspconfig')
if not ok_lsp then return end

local ok_mason, mason = pcall(require, 'mason')
local ok_mason_lsp, mason_lsp = pcall(require, 'mason-lspconfig')

if ok_mason then mason.setup({}) end
if ok_mason_lsp then
  mason_lsp.setup({
    ensure_installed = {
      'lua_ls', 'gopls', 'pyright', 'jsonls', 'yamlls', 'bashls', 'html', 'cssls', -- ts handled by typescript-tools; rust via rustaceanvim
    },
    automatic_installation = true,
  })
end

local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {})
do
  local ok_blink, blink = pcall(require, 'blink.cmp')
  if ok_blink and type(blink.get_lsp_capabilities) == 'function' then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end
end

local on_attach = function(client, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
  end

  map('n', 'gd', require('utils.lsp').goto_definition_smart, 'Goto Definition (smart)')
  map('n', 'gr', vim.lsp.buf.references, 'Goto References')
  map('n', 'gI', vim.lsp.buf.implementation, 'Goto Implementation')
  map('n', 'K', vim.lsp.buf.hover, 'Hover')
  map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename Symbol')
  map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
  map('n', ']d', vim.diagnostic.goto_next, 'Next Diagnostic')
  map('n', '[d', vim.diagnostic.goto_prev, 'Prev Diagnostic')
  map('n', '<leader>sd', vim.lsp.buf.document_symbol, 'Document Symbols')
  map('n', '<leader>sD', vim.lsp.buf.workspace_symbol, 'Workspace Symbols')

  -- Format via conform if available
  map('n', '<leader>cf', function()
    local ok_conform, conform = pcall(require, 'conform')
    if ok_conform then conform.format({ async = true, lsp_fallback = true }) else vim.lsp.buf.format() end
  end, 'Format')

  -- Enable inlay hints if supported
  if client.server_capabilities and client.server_capabilities.inlayHintProvider then
    local ih = vim.lsp.inlay_hint
    if ih then
      local ok_new = pcall(ih.enable, ih, true, { bufnr = bufnr })
      if not ok_new then pcall(ih.enable, ih, bufnr, true) end
    end
  end
end

-- Lua
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
      diagnostics = { globals = { 'vim' } },
      workspace = { checkThirdParty = false },
    },
  },
})

-- JSON/YAML/HTML/CSS/Bash/Python
for _, server in ipairs({ 'jsonls', 'yamlls', 'html', 'cssls', 'bashls', 'pyright' }) do
  lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
end

-- Go
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = { unusedparams = true, unreachable = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- Rust: rely on rustaceanvim (see plugins/rustaceanvim.lua)

-- TypeScript/JavaScript: handled by typescript-tools (see plugins/typescript-tools.lua)

-- Diagnostics UI tuning
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { spacing = 2, source = 'if_many' },
  float = { border = 'rounded', source = 'always' },
})

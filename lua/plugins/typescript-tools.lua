-- Better TypeScript/JavaScript experience
local ok, tts = pcall(require, 'typescript-tools')
if not ok then return end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
if ok_cmp then capabilities = cmp_lsp.default_capabilities(capabilities) end

tts.setup({
  on_attach = function(client, bufnr)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
    end
    -- Prefer source definition over import line
    map('n', 'gd', '<cmd>TSToolsGoToSourceDefinition<cr>', 'Goto Source Definition')
    map('n', 'gr', vim.lsp.buf.references, 'Goto References')
    map('n', 'gI', vim.lsp.buf.implementation, 'Goto Implementation')
    map('n', 'K', vim.lsp.buf.hover, 'Hover')
    map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename Symbol')
    map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
    map('n', '<leader>to', 'TSToolsOrganizeImports', 'Organize Imports')
    map('n', '<leader>tr', 'TSToolsRenameFile', 'Rename File')
  end,
  settings = {
    separate_diagnostic_server = true,
    tsserver_plugins = {},
    publish_diagnostic_on = 'insert_leave',
    expose_as_code_action = 'all',
    tsserver_format_options = { allowIncompleteCompletions = true },
    tsserver_file_preferences = {
      includeInlayParameterNameHints = 'all',
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayVariableTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayEnumMemberValueHints = true,
    },
  },
  capabilities = capabilities,
})

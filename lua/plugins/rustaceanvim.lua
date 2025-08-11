-- Rust tooling via rustaceanvim (if available)
local ok = pcall(require, 'rustaceanvim')
if not ok then return end

vim.g.rustaceanvim = {
  -- Use rust-analyzer via mason if present
  tools = {
    float_win_config = { border = 'rounded' },
  },
  server = {
    on_attach = function(client, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr, desc = desc })
      end
      map('n', '<leader>rr', function() vim.cmd.RustLsp('run') end, 'Rust Run')
      map('n', '<leader>rd', function() vim.cmd.RustLsp('debuggables') end, 'Rust Debuggables')
      map('n', '<leader>ra', function() vim.cmd.RustLsp('codeAction') end, 'Rust Code Actions')
      -- Prefer source def over import lines for rust as well
      map('n', 'gd', require('utils.lsp').goto_definition_smart, 'Goto Definition (smart)')
      -- Enable inlay hints
      local ih = vim.lsp.inlay_hint
      if ih then
        pcall(ih.enable, ih, true, { bufnr = bufnr })
      end
    end,
    default_settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        check = { command = 'clippy' },
        inlayHints = { enable = true },
      },
    },
  },
}

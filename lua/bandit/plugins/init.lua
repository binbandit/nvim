vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" }) -- adds plenary required by lots of plugins
require('bandit.plugins.lsp')
require('bandit.plugins.lualine')
require('bandit.plugins.venn')

vim.pack.add({
  -- Navigation
  { src = "https://github.com/benomahony/oil-git.nvim" }, -- git config for oil
  { src = "https://github.com/stevearc/oil.nvim" },       -- file explorer
  { src = "https://github.com/echasnovski/mini.pick" },   -- quick and easy file picker

  -- Coding
  { src = "https://github.com/echasnovski/mini.ai" },       -- extends `a`/`i` text objects
  { src = "https://github.com/echasnovski/mini.surround" }, -- feature rich sorround actions
  { src = "https://github.com/echasnovski/mini.comment" },  -- better comments
  { src = "https://github.com/echasnovski/mini.map" },      -- minimap for current buffer
  { src = "https://github.com/windwp/nvim-autopairs" },     -- automatic bracket pairs

  -- General
  { src = "https://github.com/mbbill/undotree" },                           -- better undo tree
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" }, -- Pretty markdown

  -- UI
  { src = "https://github.com/mluders/comfy-line-numbers.nvim" }, -- Easier relative line numbers
  { src = "https://github.com/folke/twilight.nvim" },             -- Only highlight what your working on
  { src = "https://github.com/code-biscuits/nvim-biscuits" },     -- show context at the end of the `}`
  { src = "https://github.com/folke/which-key.nvim" }, -- whichkey
})

require "render-markdown".setup({})
require "comfy-line-numbers".setup()
require "twilight".setup({
  dimming = {
    alpha = 0.3, -- amount of dimming
    -- we try to get the foreground from the hightlight groups or fallback color
    color = { "Normal", "#ffffff" },
    term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
    inactive = true,     -- when true, other windows will be fully dimmed (unless they contain the same buffer)
  },
  context = 7,           -- the amount of lines we will try and show around the current line
  treesitter = true,     -- use treesitter when available for the filetype
  -- treesitter is used to automatically expand the visible text,
  -- but you can further control the types of nodes that should always be fully expanded
  expand = { -- for treesitter, we always try to expand to the top-most ancestor with these types
    "function",
    "method",
    "table",
    "if_statement",
  },
  exclude = {}, -- exclude these filetypes
})

-- mini
require "mini.map".setup({
  integrations = nil
})

require "mini.comment".setup({
  mappings = {
    comment = "gc",
    comment_line = "gcc",
    comment_visual = "gc",
    textobject = "gc"
  }
})

require "mini.surround".setup({
  mappings = {
    add = 'sa',            -- Add surrounding in Normal and Visual modes
    delete = 'sd',         -- Delete surrounding
    find = 'sf',           -- Find surrounding (to the right)
    find_left = 'sF',      -- Find surrounding (to the left)
    highlight = 'sh',      -- Highlight surrounding
    replace = 'sr',        -- Replace surrounding
    update_n_lines = 'sn', -- Update `n_lines`

    suffix_last = 'l',     -- Suffix to search with "prev" method
    suffix_next = 'n',     -- Suffix to search with "next" method
  },
})
require "mini.ai".setup()


-- code
require "nvim-autopairs".setup({
  event = "InsertMode"
})

-- navigation
require "mini.pick".setup()
require "oil-git".setup()
require "oil".setup({
  default_file_explorer = true,
  columns = {
    "icon",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = true,
  cleanup_delay_ms = 200,
  experimental_watch_for_changes = true,
  keymaps_help = {
    border = "rounded"
  },
  use_default_keymaps = true,
  view_options = {
    show_hiden = false,
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    is_always_hidden = function(name, bufnr)
      return false
    end,
    natural_order = true,
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },
  },
})

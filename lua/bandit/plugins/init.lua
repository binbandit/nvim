vim.pack.add({ "https://github.com/nvim-lua/plenary.nvim" }) -- adds plenary required by lots of plugins
vim.pack.add({ "https://github.com/nvim-tree/nvim-web-devicons" }) -- icons for fzf-lua
require('bandit.plugins.lsp')
require('bandit.plugins.lualine')
require('bandit.plugins.venn')
require('bandit.plugins.rust')

vim.pack.add({
  -- Navigation
  -- { src = "https://github.com/benomahony/oil-git.nvim" }, -- Commented out for performance
  { src = "https://github.com/stevearc/oil.nvim" },       -- file explorer
  { src = "https://github.com/ibhagwan/fzf-lua" },        -- powerful fuzzy finder

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
require "fzf-lua".setup({
  -- Minimal preset for clean look
  'telescope',
  winopts = {
    -- Position window in bottom left like mini.pick
    height = 0.4,
    width = 0.5,
    row = 1,  -- bottom
    col = 0,  -- left
    border = 'rounded',
    preview = {
      hidden = 'hidden',  -- Hide preview by default for minimal look
      vertical = 'up:40%',
      horizontal = 'right:50%',
    }
  },
  keymap = {
    builtin = {
      ['<C-d>'] = 'preview-page-down',
      ['<C-u>'] = 'preview-page-up',
    },
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
  files = {
    prompt = 'Files> ',
    cwd_prompt = false,
    git_icons = false,  -- Minimal look without git icons
    file_icons = true,
    fd_opts = "--color=never --type f --hidden --follow --exclude .git",
  },
  grep = {
    prompt = 'Grep> ',
    rg_opts = "--hidden --column --line-number --no-heading " ..
              "--color=always --smart-case --max-columns=512",
  },
})
-- require "oil-git".setup()  -- Disabled for performance
--@type oil.SetupOpts
require "oil".setup {
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  cleanup_delay_ms = 100,  -- Reduced from 1000ms for better performance
  use_default_keymaps = true,
  view_options = {
    show_hidden = false,  -- Changed to false for better performance
    is_always_hidden = function(name, bufnr)
      return vim.startswith(name, ".git")
    end,
  },
  win_options = {
    signcolumn = "auto"
  },
  keymaps = {
    ["<C-s>"] = {
      callback = function()
        require("oil").save()
      end,
      mode = "n",
      desc = "Save changes in Oil"
    },
  }
}

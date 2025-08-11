local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = 'yes'
o.termguicolors = true
o.showmode = false
o.wrap = false
o.fillchars = {
  eob = ' ',
  vert = '│',
  fold = ' ',
  foldopen = '▾',
  foldclose = '▸',
  foldsep = ' ',
}

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- Indent
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true

-- Splits
o.splitbelow = true
o.splitright = true

-- Files
o.undofile = true
o.updatetime = 250
o.timeoutlen = 400
o.scrolloff = 6

-- Clipboard
o.clipboard = 'unnamedplus'

-- Better completion experience
o.completeopt = { 'menu', 'menuone', 'noselect' }

-- Folding (Treesitter-based, open by default)
o.foldmethod = 'expr'
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99

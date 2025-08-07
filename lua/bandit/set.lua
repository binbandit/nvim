local o = vim.o
local g = vim.g

-- line numbers
o.number = true -- show line numbers
o.relativenumber = true -- show relative line numbers

-- tabs & indentation
o.tabstop = 2 -- 2 spaces for tabs
o.shiftwidth = 2 -- 2 spaces for indent width
o.expandtab = true -- expand tab to spaces
o.autoindent = true -- copy indent from current line with starting new one

-- line wrapping
o.wrap = false -- disable line wrapping

-- search settings
o.ignorecase = true -- ignore case when searching
o.smartcase = true -- if there is mixed case in the search, it will use case-sensitive

-- cursor line
o.cursorline = true -- highlight the current cursor line


--- appearance
-- turning on termguicolors for colorschemes to work
o.termguicolors = true
o.background = "dark" -- colorschemes with light or dark will be asked to use dark
o.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
o.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
o.clipboard = "unnamedplus" -- use system clipboard

-- split windows
o.splitright = true -- split vertical window to the right
o.splitbelow = true -- split horizontal window to the botttom

-- turn off swapfile
o.swapfile = false

o.updatetime = 50

o.hlsearch = false
o.incsearch = true

o.scrolloff = 8  -- Reduced from 999 for better performance

o.winborder = "rounded"

-- setting leaderkey
g.mapleader = " "
g.maplocalleader = " "

-- fixing the font
g.have_nerd_font = true

-- show the mode or not
o.showmode = false -- dont show the mode as its in the lualine

-- mouse mode
o.mouse = 'a' -- enabling mouse mode

-- undofile
o.undofile = true

-- save confirm
o.confirm = true -- confirm before quit

-- netrw
g.netrw_browse_split = 0 -- disabling splitting
g.netrw_banner = 0 -- removing the banner
g.netrw_winsize = 25 -- setting window size

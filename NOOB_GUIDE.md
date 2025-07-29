# Neovim Configuration Noob Guide

Welcome! This guide will help you get started with this Neovim configuration, even if you're completely new to Neovim. This config is based on kickstart.nvim but has been heavily customized with additional plugins and features.

## Table of Contents
1. [Installation](#installation)
2. [Basic Neovim Concepts](#basic-neovim-concepts)
3. [Key Mappings](#key-mappings)
4. [Plugins Overview](#plugins-overview)
5. [Common Workflows](#common-workflows)
6. [Tips and Tricks](#tips-and-tricks)
7. [Troubleshooting](#troubleshooting)

## Installation

### Prerequisites

Before installing this config, you need:

1. **Neovim** (version 0.9.0 or higher)
   - Mac: `brew install neovim`
   - Ubuntu/Debian: `sudo apt install neovim`
   - Check version: `nvim --version`

2. **Required Dependencies**:
   - Git: `git --version`
   - Make & GCC: `make --version` and `gcc --version`
   - [Ripgrep](https://github.com/BurntSushi/ripgrep): `brew install ripgrep` or `sudo apt install ripgrep`
   - [fd-find](https://github.com/sharkdp/fd): `brew install fd` or `sudo apt install fd-find`
   - Node.js & npm (for TypeScript/JavaScript): `node --version`
   - Python3 (for Python development): `python3 --version`
   - Go (for Go development): `go version`
   - Rust & Cargo (for Rust development): `rustc --version`

3. **Recommended**:
   - A [Nerd Font](https://www.nerdfonts.com/) for icons (I recommend "JetBrainsMono Nerd Font")
   - Set your terminal to use the Nerd Font

### Installation Steps

1. **Backup existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration**:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **First Launch**:
   ```bash
   nvim
   ```
   - Wait for plugins to install automatically (this might take a minute)
   - You might see some errors on first launch - that's normal
   - Restart Neovim after plugins install: `:q` then `nvim`

4. **Verify Installation**:
   - Run `:checkhealth` to see if everything is working
   - Fix any errors shown (usually missing dependencies)

## Basic Neovim Concepts

### Modes
Neovim has different modes:
- **Normal Mode** (default): For navigating and executing commands
- **Insert Mode** (press `i`): For typing text
- **Visual Mode** (press `v`): For selecting text
- **Command Mode** (press `:`): For running commands

Press `Esc` or `jk` (custom mapping) to return to Normal mode from any other mode.

### Leader Key
This config uses `Space` as the leader key. Many commands start with `<leader>` which means pressing Space followed by other keys.

### Basic Navigation
- `h`, `j`, `k`, `l`: Move left, down, up, right
- `gg`: Go to top of file
- `G`: Go to bottom of file
- `0`: Beginning of line
- `$`: End of line
- `w`: Next word
- `b`: Previous word

## Key Mappings

### Essential Mappings

#### File Operations
- `<leader>sf` or `<leader><leader>`: Find files (fuzzy search)
- `<leader>sg`: Search text in all files (grep)
- `<leader>e`: Open file explorer (Oil)
- `-`: Go to parent directory in Oil
- `<Ctrl-s>` or `<leader>s`: Save file
- `<leader>S`: Save all files

#### Window Management
- `<Ctrl-h/j/k/l>`: Navigate between windows
- `<leader>|`: Split window vertically
- `<leader>w-`: Split window horizontally
- `<leader>wd`: Close window

#### Buffer Management
- `<leader>bb`: List open buffers
- `<leader>bd`: Close current buffer (smart)
- `<leader>bn`: Next buffer
- `<leader>bp`: Previous buffer
- `<leader>``: Toggle between last two buffers

#### Terminal
- `<Ctrl-\>`: Toggle floating terminal
- `<leader>gg`: Open LazyGit
- `<leader>tt`: Toggle terminal
- In terminal mode, press `jk` to exit to normal mode

#### Code Navigation & Editing
- `gd`: Go to definition (uses smart-goto)
- `grr`: Find references
- `grn`: Rename symbol
- `gra`: Code actions
- `K`: Show hover documentation
- `<leader>f`: Format code

#### Harpoon (Quick File Navigation)
- `<leader>ha`: Add file to Harpoon
- `<leader>hh`: Show Harpoon menu
- `<leader>h1-4`: Jump to Harpoon file 1-4
- `<Alt-1-4>`: Quick jump to Harpoon file 1-4

#### Search & Replace
- `<leader>ss`: Replace word under cursor
- `/`: Search in current file
- `<leader>/`: Search in project
- `<Esc>`: Clear search highlights

#### Git
- `<leader>gg`: Open LazyGit
- `<leader>hb`: Git blame line
- `<leader>hd`: Git diff hunk
- `<leader>hp`: Preview git hunk

## Plugins Overview

### Core Functionality
- **[lazy.nvim](https://github.com/folke/lazy.nvim)**: Plugin manager
- **[fzf-lua](https://github.com/ibhagwan/fzf-lua)**: Fuzzy finder for files, text, etc.
- **[oil.nvim](https://github.com/stevearc/oil.nvim)**: File explorer as a buffer

### Editor Enhancements
- **[which-key.nvim](https://github.com/folke/which-key.nvim)**: Shows keybindings as you type
- **[flash.nvim](https://github.com/folke/flash.nvim)**: Quick cursor movement
- **[harpoon](https://github.com/ThePrimeagen/harpoon)**: Quick file navigation
- **[undotree](https://github.com/mbbill/undotree)**: Visualize undo history

### Code Intelligence
- **LSP (Language Server Protocol)**: Built-in code intelligence
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: Better syntax highlighting
- **[blink.cmp](https://github.com/Saghen/blink.cmp)**: Autocompletion
- **[trouble.nvim](https://github.com/folke/trouble.nvim)**: Pretty diagnostics list

### Git Integration
- **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)**: Git signs in gutter
- **[vim-fugitive](https://github.com/tpope/vim-fugitive)**: Git commands
- **[lazygit.nvim](https://github.com/kdheepak/lazygit.nvim)**: LazyGit integration

### Language Specific
- **[go.nvim](https://github.com/ray-x/go.nvim)**: Go development
- **[rustaceanvim](https://github.com/mrcjkb/rustaceanvim)**: Rust development
- **[typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim)**: TypeScript/JavaScript

### UI/Theme
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**: Status line
- **[achroma.nvim](https://github.com/binbandit/achroma.nvim)**: Current theme
- **[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)**: Markdown preview

### Utilities
- **[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)**: Terminal integration
- **[zen-mode.nvim](https://github.com/folke/zen-mode.nvim)**: Distraction-free mode
- **[todo-comments.nvim](https://github.com/folke/todo-comments.nvim)**: Highlight TODOs

## Common Workflows

### Finding and Opening Files
1. Press `<leader>sf` (or `<leader><leader>`)
2. Start typing the filename
3. Use arrow keys or `<Ctrl-j/k>` to navigate
4. Press `Enter` to open

### Search Text Across Project
1. Press `<leader>sg`
2. Type your search term
3. Navigate results and press `Enter` to jump to location

### Working with Multiple Files
1. Use Harpoon for frequently accessed files:
   - `<leader>ha` to add current file
   - `<Alt-1>` through `<Alt-4>` for quick access
2. Use buffers for recently opened files:
   - `<leader>bb` to see all buffers
   - `<leader>`\` to toggle between last two

### Git Workflow
1. Make changes to files
2. Press `<leader>gg` to open LazyGit
3. Stage files with `Space`
4. Commit with `c`
5. Push with `P`
6. Exit with `q`

### Code Navigation
1. Put cursor on a function/variable
2. Press `gd` to go to definition
3. Press `grr` to find all references
4. Press `<Ctrl-o>` to go back

### Using the Terminal
1. Press `<Ctrl-\>` for floating terminal
2. Run your commands
3. Press `jk` to go to normal mode
4. Press `i` to go back to terminal mode
5. Press `<Ctrl-\>` again to hide

## Tips and Tricks

### Quick Tips
1. **Learn incrementally**: Start with basic navigation and file opening
2. **Use which-key**: Press `<leader>` and wait to see available commands
3. **Explore with `:Lazy`**: See all installed plugins
4. **Check mappings**: Use `<leader>sk` to search keymaps

### Productivity Boosters
1. **Harpoon everything**: Add your most-used files for instant access
2. **Master fzf**: It's faster than navigating directories
3. **Use visual mode**: Press `v` then navigate to select text
4. **Learn text objects**: `ciw` (change inner word), `di"` (delete inside quotes)

### Customization
- Personal keymaps: Add to `lua/bandit/plugins/keymaps.lua`
- New plugins: Create files in `lua/bandit/plugins/`
- LSP settings: Modify in `init.lua` (servers table)

## Troubleshooting

### Common Issues

1. **Icons not showing**:
   - Install a Nerd Font
   - Set terminal font to the Nerd Font

2. **LSP not working**:
   - Run `:Mason` and install language servers
   - Check `:LspInfo` when in a file

3. **Plugins not loading**:
   - Run `:Lazy sync`
   - Restart Neovim

4. **Keybindings not working**:
   - Check for conflicts with `:map <keymap>`
   - Make sure you're in the right mode

### Getting Help
- In Neovim: `:help <topic>`
- Plugin docs: `:help <plugin-name>`
- Check health: `:checkhealth`

### Useful Commands
- `:Lazy` - Plugin manager
- `:Mason` - LSP installer
- `:LspInfo` - Current LSP status
- `:messages` - View recent messages/errors

## Next Steps

1. **Practice basic navigation** for a week
2. **Learn one new feature per day**
3. **Customize gradually** - don't change everything at once
4. **Join the community** - r/neovim, Neovim Discord

Remember: Neovim has a learning curve, but the investment pays off in productivity! Start slow, be patient, and have fun exploring.

Happy coding! 🚀
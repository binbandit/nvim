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

1. **Terminal Emulator** (Highly recommend [Ghostty](https://ghostty.org))
   - Ghostty is a fast, feature-rich terminal that works perfectly with Neovim
   - **Mac**: Download from [ghostty.org](https://ghostty.org) or `brew install --cask ghostty`
   - **Linux**: Follow instructions at [ghostty.org](https://ghostty.org) for your distribution
   - **Why Ghostty?**
     - Native performance with GPU acceleration
     - Excellent font rendering and ligature support
     - Built-in support for true colors and undercurl
     - Minimal configuration needed
   - After installing, set your font to a Nerd Font in Ghostty's config

2. **Neovim** (version 0.9.0 or higher)
   - Mac: `brew install neovim`
   - Ubuntu/Debian: `sudo apt install neovim`
   - Check version: `nvim --version`

3. **Required Dependencies**:
   - Git: `git --version`
   - Make & GCC: `make --version` and `gcc --version`
   - [Ripgrep](https://github.com/BurntSushi/ripgrep): `brew install ripgrep` or `sudo apt install ripgrep`
   - [fd-find](https://github.com/sharkdp/fd): `brew install fd` or `sudo apt install fd-find`
   - Node.js & npm (for TypeScript/JavaScript): `node --version`
   - Python3 (for Python development): `python3 --version`
   - Go (for Go development): `go version`
   - Rust & Cargo (for Rust development): `rustc --version`

4. **Recommended**:
   - A [Nerd Font](https://www.nerdfonts.com/) for icons (I recommend "JetBrainsMono Nerd Font")
   - Set your terminal to use the Nerd Font (in Ghostty: add `font-family = JetBrainsMono Nerd Font` to your config)

### Installation Steps

1. **Backup existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration**:
   ```bash
   git clone https://github.com/binbandit/nvim ~/.config/nvim
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

### Managing Plugins with Lazy

This config uses **Lazy.nvim** as the plugin manager. Here's how to keep your plugins updated:

#### Opening Lazy Plugin Manager
- Press `<leader>l` (Space + l) or run `:Lazy` in command mode

#### Plugin Management Commands
In the Lazy interface:
- **U** - Update all plugins to their latest versions
- **u** - Update the selected plugin only
- **i** - Install any missing plugins
- **x** - Clean (remove) unused plugins
- **s** - Sync (update and clean)
- **c** - Check for plugin updates (without installing)
- **l** - Show plugin logs
- **r** - Restore plugins to their locked versions
- **?** - Show help for all commands

#### Best Practices
1. **Regular Updates**: Update plugins weekly with `<leader>l` then `U`
2. **Check Breaking Changes**: Review plugin logs (`l`) after updates
3. **Restore if Needed**: Use `r` to restore if updates cause issues
4. **Lock Versions**: The `lazy-lock.json` file tracks plugin versions

#### Adding New Plugins
1. **Create a new file** in `lua/bandit/plugins/` (e.g., `my-plugin.lua`)
2. **Add plugin specification**:
   ```lua
   return {
     'username/plugin-name',
     config = function()
       -- Plugin configuration here
     end,
   }
   ```
3. **Save and restart** Neovim - Lazy will auto-install the plugin
4. **Example** - Adding a color picker plugin:
   ```lua
   -- lua/bandit/plugins/color-picker.lua
   return {
     'uga-rosa/ccc.nvim',
     event = 'BufRead',
     config = function()
       require('ccc').setup()
     end,
   }
   ```

#### Removing Plugins
1. **Delete the plugin file** from `lua/bandit/plugins/` or `lua/kickstart/plugins/`
2. **Open Neovim** and run `:Lazy`
3. **Press `x`** to clean unused plugins
4. **Confirm** the removal when prompted

Alternative method:
- Comment out the plugin in its file by adding `--` before each line
- This keeps the config for potential future use

#### Troubleshooting Plugin Issues
- If a plugin fails to load: `:Lazy` then `i` to reinstall
- For persistent issues: Delete the plugin folder in `~/.local/share/nvim/lazy/` and reinstall
- Check plugin health: `:checkhealth plugin-name`

### Changing the Theme

This config includes multiple themes. To change the active theme:

1. **Open the theme file**: `lua/bandit/plugins/theme.lua`
2. **Available themes**:
   - **Evergarden** - A warm, nature-inspired theme
   - **Aetherglow** - A modern, vibrant theme (variants: `dark_bold`)
   - **Oldworld** - A classic, muted theme (commented out by default)
   - **Achroma** - A minimal black/white theme (currently active)
   - **Serene Horizon** - A calm, peaceful theme (commented out)

3. **To activate a theme**:
   - Find the theme you want in the file
   - Uncomment the `vim.cmd.colorscheme` line
   - Comment out the current active theme's `vim.cmd.colorscheme` line
   - Save and restart Neovim

4. **Example - Switch to Evergarden**:
   ```lua
   -- In the Evergarden config function:
   config = function()
       require('evergarden').setup({
           variant = 'winter',  -- or 'summer'
       })
       vim.cmd.colorscheme 'evergarden'  -- Uncomment this line
   end,
   
   -- In the Achroma config function:
   config = function()
       require("achroma").setup({
           mode = "dark",
           variant = "black",
           inverse_popup = true,
       })
       -- vim.cmd.colorscheme("achroma")  -- Comment this line
   end,
   ```

5. **Quick theme preview**: Try a theme temporarily with `:colorscheme theme-name`

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

### Learning Mode

If you're new to Vim and want to practice movements and motions, this config includes a **Learning Mode** that enables helpful learning tools.

To use Learning Mode:
1. **Enable it**: Press `<Space>Lt` to toggle learning mode (or `<Space>Le` to enable)
2. **Restart Neovim**: The changes take effect after restarting
3. **Practice**: Press `<Space>Lp` to launch VimBeGood, an interactive game for learning Vim movements

VimBeGood includes several games to practice:
- **Basic movements**: Practice h, j, k, l navigation
- **Word movements**: Learn w, b, e motions
- **Delete/Change**: Practice d and c commands
- **Visual mode**: Practice visual selections

When you're comfortable with the basics:
- Press `<Space>Ld` to disable learning mode
- Restart Neovim to unload the learning plugins

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

#### Learning Mode
- `<leader>Lt`: Toggle learning mode
- `<leader>Le`: Enable learning mode
- `<leader>Ld`: Disable learning mode
- `<leader>Lp`: Practice with VimBeGood (requires learning mode)

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
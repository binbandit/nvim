# Brayden's Neovim Configuration

A powerful, modular Neovim configuration based on kickstart.nvim with extensive customizations for modern development workflows.

## Features

- 🚀 **Modular Plugin Architecture**: Organized plugin structure with `god/plugins/` and `kickstart/plugins/` directories
- 🎨 **Rich Theme Support**: Multiple themes including Oldworld, with easy theme switching
- 📁 **Advanced File Navigation**: Oil.nvim for file management, Harpoon for quick navigation, FZF-Lua for fuzzy finding
- 💻 **Language Support**: Pre-configured for TypeScript, Go, Rust, and more with LSP support
- 🔧 **Developer Tools**: LazyGit integration, REST client, Trouble.nvim for diagnostics, and more
- ⚡ **Performance Optimized**: Lazy loading and efficient plugin management with lazy.nvim

## Installation

### Prerequisites

- Neovim 0.9.0 or higher
- Git, Make, GCC
- [ripgrep](https://github.com/BurntSushi/ripgrep) and [fd-find](https://github.com/sharkdp/fd)
- A [Nerd Font](https://www.nerdfonts.com/) (optional but recommended)
- Language-specific tools:
  - Node.js & npm (for TypeScript/JavaScript)
  - Go (for Go development)
  - Rust & Cargo (for Rust development)

### Quick Install

1. **Backup existing config** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this configuration**:
   ```bash
   git clone https://github.com/crazywolf132/nvim.git ~/.config/nvim
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```

Lazy.nvim will automatically install all plugins on first launch.

## Structure

```
~/.config/nvim/
├── init.lua              # Main configuration file
├── lua/
│   ├── god/plugins/     # Custom plugin configurations
│   │   ├── flash.lua    # Flash.nvim for quick navigation
│   │   ├── fzf-lua.lua  # FZF-Lua fuzzy finder
│   │   ├── harpoon.lua  # Harpoon for file marks
│   │   ├── oil.lua      # Oil.nvim file explorer
│   │   ├── theme.lua    # Theme configurations
│   │   └── ...          # More plugin configs
│   └── kickstart/       # Kickstart.nvim modules
│       └── plugins/     # Optional kickstart plugins
├── lazy-lock.json       # Plugin version lock file
└── NOOB_GUIDE.md       # Beginner's guide

```

## Key Features

### File Navigation
- **Oil.nvim**: Modern file explorer as a buffer (`<leader>e`)
- **Harpoon**: Quick file switching and marks
- **FZF-Lua**: Fast fuzzy finding for files, buffers, and more

### Development Tools
- **LSP Support**: Full Language Server Protocol support with auto-completion
- **Git Integration**: LazyGit (`<leader>gg`) and Fugitive for Git operations
- **REST Client**: Built-in REST API testing
- **Debugging**: DAP support for multiple languages

### UI Enhancements
- **Lualine**: Beautiful and informative statusline
- **Navic**: Code context in statusline
- **Render-Markdown**: Enhanced markdown preview
- **Zen Mode**: Distraction-free writing

### Language-Specific
- **TypeScript Tools**: Enhanced TypeScript/JavaScript development
- **Go Tools**: Go development utilities
- **Rust Tools**: Rust analyzer integration

## Key Mappings

Leader key is set to `<Space>`.

### Essential Mappings
- `<leader>e` - Open Oil file explorer
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Browse buffers
- `<leader>gg` - Open LazyGit
- `<leader>xx` - Toggle Trouble diagnostics

See the [NOOB_GUIDE.md](NOOB_GUIDE.md) for a complete list of keybindings.

## Customization

### Adding Plugins

Add new plugins in `lua/god/plugins/` directory:

```lua
-- lua/god/plugins/my-plugin.lua
return {
  'username/plugin-name',
  config = function()
    -- Plugin configuration
  end
}
```

### Modifying Settings

Core settings are in `init.lua`. Modify options like:
- Leader key
- Tab settings
- UI preferences

## Resources

- [NOOB_GUIDE.md](NOOB_GUIDE.md) - Comprehensive beginner's guide
- [LICENSE.md](LICENSE.md) - MIT License
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - Original kickstart.nvim

## Contributing

Feel free to submit issues and pull requests. This configuration is actively maintained and evolves with my development needs.

## License

MIT - See [LICENSE.md](LICENSE.md) for details.
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Neovim configuration using Neovim nightly build features. The configuration leverages bleeding-edge native APIs including the built-in package manager (vim.pack.add) and other experimental features not yet available in stable releases. The setup follows a modular Lua-based architecture with an emphasis on modern native APIs and minimal external dependencies.

## Architecture

### Directory Structure
```
~/.config/nvim/
├── init.lua                 # Entry point - loads bandit module
├── lsp/                     # 300+ LSP server configs from nvim-lspconfig
│   └── *.lua               # Individual LSP server configurations
└── lua/bandit/
    ├── init.lua            # Module loader
    ├── set.lua             # Core Neovim settings
    ├── theme.lua           # Color scheme configuration
    ├── keys.lua            # Global keybindings
    ├── extra.lua           # Autocmds and additional configs
    └── plugins/
        ├── init.lua        # Plugin declarations and basic setup
        ├── lsp.lua         # LSP and completion configuration
        ├── lualine.lua     # Status line configuration
        ├── rust.lua        # Rust-specific tooling setup
        └── venn.lua        # ASCII diagram drawing tool

```

### Key Architectural Decisions

1. **Neovim Version**: Running nightly build to access cutting-edge features like native package management and latest LSP improvements.

2. **LSP Configurations**: All LSP server configs from nvim-lspconfig are copied into the `lsp/` directory, allowing direct modification without forking the plugin.

3. **Plugin Management**: Uses Neovim's native `vim.pack.add()` (nightly feature) instead of third-party managers like lazy.nvim or packer.

4. **Completion System**: Uses blink.cmp (modern Lua-based) instead of nvim-cmp for better performance.

5. **File Navigation**: oil.nvim as primary file explorer instead of traditional tree-based explorers.

## Common Development Tasks

### Testing Changes
```bash
# Reload configuration after making changes
# In Neovim: <leader>o (saves and sources current file)

# Test specific LSP server changes
# 1. Edit the LSP config in lsp/<server_name>.lua
# 2. Restart Neovim or run :LspRestart
```

### Adding New Plugins
1. Add plugin to `lua/bandit/plugins/init.lua` using `vim.pack.add()`
2. For complex configs, create a new file in `lua/bandit/plugins/`
3. Require the new config file in `lua/bandit/plugins/init.lua`

### Modifying LSP Servers
1. Edit the specific server config in `lsp/<server_name>.lua`
2. Changes take effect after restarting Neovim or running `:LspRestart`

### Key Bindings Reference
- Leader key: `<space>`
- Save: `<C-s>` (works in all modes)
- File navigation: `<leader>e` (oil.nvim)
- Find files: `<leader><leader>`
- Format file: `<leader>lf`
- Code actions: `<leader>a` (Rust-aware)
- Window splits: `<leader>|` (vertical), `<leader>ws` (horizontal)

## Plugin System Details

### Core Plugins
- **Navigation**: oil.nvim, mini.pick
- **Editing**: mini.surround, mini.comment, nvim-autopairs
- **LSP**: nvim-lspconfig, blink.cmp, mason.nvim
- **Languages**: typescript-tools.nvim, go.nvim, rustaceanvim
- **UI**: lualine.nvim, which-key.nvim, twilight.nvim

### Language-Specific Enhancements

**TypeScript/JavaScript**:
- Enhanced via typescript-tools.nvim
- Includes styled-components support
- Auto-imports and inlay hints enabled

**Rust**:
- Full rust-analyzer integration via rustaceanvim
- Clippy hints enabled
- crates.nvim for dependency management

**Go**:
- Auto-formatting with goimports on save
- go.nvim for additional tooling

## Important Conventions

1. **Keybinding Descriptions**: Always include `desc` field for which-key integration
2. **File Paths**: Use absolute paths when working with file operations
3. **LSP Setup**: Basic servers use `vim.lsp.enable()`, complex ones have dedicated config files
4. **Autocommands**: Placed in `lua/bandit/extra.lua`
5. **Global Functions**: Defined in plugin-specific files (e.g., `Toggle_venn()` in venn.lua)

## Debugging Tips

- Check LSP status: Look at lualine status bar (shows active LSP servers)
- View LSP logs: `:LspLog`
- Debug keybindings: `:WhichKey` to see available mappings
- Plugin issues: Check `:messages` for error output
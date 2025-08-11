# Repository Guidelines

> Neovim configuration repo focused on Lua modules and plugin setup. Keep changes scoped, reversible, and well-described.

## Project Structure & Module Organization
- Root: `init.lua` bootstraps modules from `lua/`.
- Modules: `lua/` organized by domain, e.g. `lua/config/` (options, keymaps, autocmds), `lua/plugins/` (plugin specs/config), `lua/utils/` (helpers).
- Plugin runtime: `plugin/` (auto-generated/init files), `after/` (filetype overrides). Optional: `assets/` (screenshots), `tests/`.
- Pattern: one plugin per file in `lua/plugins/` named after the plugin, e.g. `lua/plugins/gitsigns.lua`.

## Build, Test, and Development Commands
- Validate startup (headless): `nvim --headless '+qa'`.
- Sync/update plugins (Lazy.nvim): `nvim --headless '+Lazy! sync' '+qa'`.
- Format Lua (Stylua): `stylua .` (install via `brew install stylua` or cargo).
- Lint Lua (Luacheck): `luacheck lua/` (if configured).
- Health checks: `nvim '+checkhealth'` to review runtime issues.

## Coding Style & Naming Conventions
- Indentation: 2 spaces for Lua and Vimscript.
- Lua style: prefer local modules; return tables; avoid globals.
- Naming: `snake_case` for variables/functions; `kebab-case` file names only when mirroring plugin names; module paths match dirs, e.g. `require('config.keymaps')`.
- Keep plugin config self-contained and idempotent; no side effects at require time beyond setup.
- Run `stylua` before commits; keep lines reasonably short and readable.

## Testing Guidelines
- Quick checks: open `nvim` and watch `:messages` for errors; run `:checkhealth`.
- Optional unit tests (plenary): place specs in `tests/` ending with `_spec.lua`; run
  `nvim --headless -c "PlenaryBustedDirectory tests { minimal_init = 'tests/minimal_init.lua' }" +qa`.
- Aim to cover critical helpers in `lua/utils/` and risky plugin glue.

## Commit & Pull Request Guidelines
- Commit style: Conventional Commits with scoped changes, e.g. `feat(lualine): switch to evergarden theme`, `fix(treesitter): extend ensure_installed`.
- Keep commits small; include rationale in body when non-obvious.
- PRs: describe intent, list notable changes, include screenshots for UI/theme updates, link issues, and mention breaking changes or migration steps.
- After plugin changes, include `:Lazy` output or notes on required `:Mason`/`:TSInstall` steps.

## Security & Configuration Tips
- Do not commit secrets; keep tokens/keys in env or ignored files.
- Commit lockfiles (e.g., `lazy-lock.json`) when plugin versions change to ensure reproducible setups.

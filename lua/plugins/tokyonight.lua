local ok, tn = pcall(require, 'tokyonight')
if not ok then return end

tn.setup({
  style = 'night', -- moon/night; night is neon, high contrast
  transparent = false,
  styles = { comments = { italic = true }, keywords = { italic = false } },
  on_colors = function(colors)
    -- Nudge toward a Blade Runner vibe
    colors.border = colors.magenta
    colors.hint = colors.cyan
    colors.info = colors.cyan
    colors.warning = colors.orange
    colors.error = colors.red
  end,
  on_highlights = function(hl, c)
    hl.NormalFloat = { bg = c.bg_dark }
    hl.FloatBorder = { fg = c.magenta, bg = c.bg_dark }
    hl.WinSeparator = { fg = c.bg_highlight }
    hl.CursorLine = { bg = c.bg_highlight }
    hl.CursorLineNr = { fg = c.orange, bold = true }
    hl.Visual = { bg = c.bg_highlight }
    hl.IncSearch = { bg = c.cyan, fg = c.bg }
    hl.Search = { bg = c.orange, fg = c.bg }
  end,
})

vim.cmd.colorscheme('tokyonight')


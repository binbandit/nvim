local ok, lualine = pcall(require, 'lualine')
if not ok then return end

lualine.setup({
  options = {
    theme = 'auto',
    globalstatus = true,
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = {
      {
        function()
          local ok_ai, ai = pcall(require, 'utils.ai_toggle')
          if not ok_ai then return '' end
          return (ai.enabled() and ' AI') or ' AI off'
        end,
      },
      'encoding', 'fileformat', 'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})

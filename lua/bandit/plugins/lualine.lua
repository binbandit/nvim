vim.pack.add({
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" }
})

require "lualine".setup({
  options = {
    theme = "auto",
    component_separators = "",
    section_separators = { left = "", right = ""},
    disabled_filetypes = {
      statusline = { "dashboard", "alpha", "starter" },
    },
    always_divide_middle = true,
    globalstatus = true
  },
  sections = {
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return " " .. str:sub(1,1) .. " "
        end,
        separator = { left = "", right = "" },
      },
    },
    lualine_b = {
      { "branch", icon = "" },
    },
    lualine_c = {
      {
        "diagnostics",
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0} },
      { "filename", path = 1, symbols = { modified = "  ", readonly = "", unamed = "" }, color = { gui = "bold" } },
    },
    lualine_x = {
      {
        function()
          return os.date("%H:%M")
        end,
        icon = " ",
      },
      {
        function()
          local msg = "No Active LSP"
          local buf_ft = vim.api.nvim_bug_get_option(0, "filetype")
          local clients = vim.lsp.get_clients()
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = " ",
      },
    },
    lualine_y = {
      { "progress" }
    },
    lualine_z = {
      {
        "location",
        separator = { left = "", right = "" },
      },
    },
  },
  inactive_sections = {
    lualine_c = {"filename"},
    lualine_x = {"location"},
  },
  extensions = {},
})

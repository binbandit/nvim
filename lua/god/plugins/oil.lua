return {
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {
            default_file_explorer = true,
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            cleanup_delay_ms = 1000,
            use_default_keymaps = true,
            view_options = {
                -- Show files and directories that start with "."
                show_hidden = true,
            },
            win_options = {
                signcolumn = "auto"
            },
            keymaps = {
                ["<C-s>"] = function()
                    require("oil").save()
                end,
            }
        },
        dependencies = { {
            "echasnovski/mini.icons", opts = {}
        } },
        lazy = false
    },
    {
        'refractalize/oil-git-status.nvim',
        dependencies = {
            "stevearc/oil.nvim",
        },
        config = true,
    }
}

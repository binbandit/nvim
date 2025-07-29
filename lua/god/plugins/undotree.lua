return {
    "mbbill/undotree",
    config = function()
        -- Set undotree to open on the right side
        vim.g.undotree_WindowLayout = 3
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_ShortIndicators = 1
        vim.g.undotree_SplitWidth = 30
        
        -- Keymap to toggle undotree
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
    end,
}
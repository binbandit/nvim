return {
    'charm-and-friends/freeze.nvim',
    event = 'VeryLazy',
    config = function()
        require('freeze').setup({
            command = "freeze",
            output = function()
                return "./" .. os.date("%Y-%m-%d") .. "_freeze.png"
            end,
            theme = "dracula",
        })
    end,
    keys = {
        {
            "<leader>sc",
            mode = { "n", "v" },
            function()
                require("freeze").freeze()
            end,
            desc = "Freeze code screenshot",
        },
        {
            "<leader>sC",
            mode = { "n", "v" },
            function()
                require("freeze").freeze_line()
            end,
            desc = "Freeze current line",
        },
    },
}
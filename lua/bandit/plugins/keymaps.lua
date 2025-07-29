return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        
        -- Set up which-key
        wk.setup()
        
        -- Define keymaps using new spec format
        wk.add({
            -- Quick quit
            { "<leader>qq", "<cmd>qa<cr>", desc = "Quit all" },
            { "<leader>qQ", "<cmd>qa!<cr>", desc = "Force quit all" },
            
            -- Buffer management
            { "<leader>bd", function() require("bandit.utils.buffer-close").close_buffer(false) end, desc = "Delete buffer (smart)" },
            { "<leader>bD", function() require("bandit.utils.buffer-close").close_buffer(true) end, desc = "Force delete buffer (smart)" },
            { "<leader>bn", "<cmd>bnext<cr>", desc = "Next buffer" },
            { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous buffer" },
            { "<leader>ba", "<cmd>ball<cr>", desc = "Open all buffers" },
            { "<leader>bc", function() require("bandit.utils.buffer-close").close_and_next() end, desc = "Close buffer and go to next" },
            { "<leader>bC", function() require("bandit.utils.buffer-close").close_all_except_current() end, desc = "Close all buffers except current" },
            { "<leader>`", "<cmd>b#<cr>", desc = "Toggle between buffers" },
            
            -- Save mappings (moved to avoid conflict with window group)
            { "<leader>s", "<cmd>w<cr>", desc = "Save file" },
            { "<leader>S", "<cmd>wa<cr>", desc = "Save all files" },
            
            -- Window management
            { "<leader>wd", "<C-W>c", desc = "Delete window" },
            { "<leader>w-", "<C-W>s", desc = "Split window below" },
            { "<leader>ws", "<C-W>s", desc = "Split window horizontally" },
            { "<leader>w|", "<C-W>v", desc = "Split window right" },
            { "<leader>ww", "<C-W>w", desc = "Switch windows" },
            { "<leader>wh", "<C-W>h", desc = "Go to left window" },
            { "<leader>wj", "<C-W>j", desc = "Go to lower window" },
            { "<leader>wk", "<C-W>k", desc = "Go to upper window" },
            { "<leader>wl", "<C-W>l", desc = "Go to right window" },
            
            -- Tab management
            { "<leader>tn", "<cmd>tabnew<cr>", desc = "New tab" },
            { "<leader>tc", "<cmd>tabclose<cr>", desc = "Close tab" },
            { "<leader>to", "<cmd>tabonly<cr>", desc = "Close other tabs" },
            { "<leader>th", "<cmd>tabprevious<cr>", desc = "Previous tab" },
            { "<leader>tl", "<cmd>tabnext<cr>", desc = "Next tab" },
            
            -- File explorer
            { "<leader>e", "<cmd>Oil<cr>", desc = "Open file explorer (Oil)" },
            { "<leader>E", "<cmd>Oil .<cr>", desc = "Open Oil in current directory" },
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
            
            -- Select all
            { "<C-a>", "ggVG", desc = "Select all text" },
            
            -- Search and replace
            { "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Replace word under cursor" },
            
            -- Rust specific (only active in rust files)
            { "<leader>rc", 
                function()
                    if vim.bo.filetype == "rust" then
                        vim.cmd("RustLsp flyCheck")
                    end
                end, 
                desc = "Run cargo check (Rust)" 
            },
            { "<leader>rf", 
                function()
                    if vim.bo.filetype == "rust" then
                        vim.lsp.buf.format({ async = false })
                        vim.notify("Formatted Rust file", vim.log.levels.INFO)
                    end
                end, 
                desc = "Format Rust file" 
            },
            
            -- Folding
            { "<leader>z", group = "fold" },
            { "<leader>za", "<cmd>za<cr>", desc = "Toggle fold" },
            { "<leader>zR", "<cmd>zR<cr>", desc = "Open all folds" },
            { "<leader>zM", "<cmd>zM<cr>", desc = "Close all folds" },
            { "<leader>zc", "<cmd>zc<cr>", desc = "Close current fold" },
            { "<leader>zo", "<cmd>zo<cr>", desc = "Open current fold" },

            -- Learning mode
            { "<leader>L", group = "learning" },
            { "<leader>Lt", function() require("learning-mode").toggle() end, desc = "Toggle learning mode" },
            { "<leader>Le", function() require("learning-mode").enable() end, desc = "Enable learning mode" },
            { "<leader>Ld", function() require("learning-mode").disable() end, desc = "Disable learning mode" },
            { "<leader>Lp", "<cmd>VimBeGood<cr>", desc = "Practice with VimBeGood" },

            -- Register group names
            { "<leader>b", group = "buffer" },
            { "<leader>q", group = "quit" },
            { "<leader>w", group = "window" },
            { "<leader>t", group = "tab" },
            { "<leader>r", group = "rust/recent" },
            { "<leader>h", group = "harpoon" },
        })
    end,
}
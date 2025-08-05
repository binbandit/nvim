return {
    -- Configure treesitter folding
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.fold = { enable = true }
            return opts
        end,
    },
    
    -- Better fold management
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
        },
        event = "BufReadPost",
        init = function()
            -- Set folding options globally
            vim.o.foldcolumn = '1'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        opts = {
            -- Tell ufo to use treesitter as the main provider
            provider_selector = function()
                return { 'treesitter', 'indent' }
            end,
            -- Customize fold text
            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ("  %d "):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, {chunkText, hlGroup})
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, {suffix, "MoreMsg"})
                return newVirtText
            end,
        },
        config = function(_, opts)
            local ufo = require('ufo')
            ufo.setup(opts)
            
            -- Keymaps
            vim.keymap.set('n', 'zR', ufo.openAllFolds, { desc = "Open all folds" })
            vim.keymap.set('n', 'zM', ufo.closeAllFolds, { desc = "Close all folds" })
            vim.keymap.set('n', 'zr', ufo.openFoldsExceptKinds, { desc = "Open folds except kinds" })
            vim.keymap.set('n', 'zm', ufo.closeFoldsWith, { desc = "Close folds with" })
            vim.keymap.set('n', 'K', function()
                local winid = ufo.peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end, { desc = "Peek folded lines or hover" })
            
            -- Create a command to debug folding
            vim.api.nvim_create_user_command('FoldDebug', function()
                print("Foldmethod:", vim.wo.foldmethod)
                print("Foldenable:", vim.wo.foldenable)
                print("Foldlevel:", vim.wo.foldlevel)
                print("Foldexpr:", vim.wo.foldexpr)
                print("Treesitter loaded:", pcall(require, 'nvim-treesitter'))
                print("UFO attached:", pcall(function() return require('ufo').hasAttached() end))
            end, { desc = "Debug folding settings" })
        end
    }
}
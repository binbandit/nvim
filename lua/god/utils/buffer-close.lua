local M = {}

-- Smart buffer close that preserves window splits
function M.close_buffer(force)
    local bufnr = vim.api.nvim_get_current_buf()
    local bufinfo = vim.fn.getbufinfo(bufnr)[1]
    
    -- Check if buffer has unsaved changes
    if not force and bufinfo and bufinfo.changed == 1 then
        vim.notify("Buffer has unsaved changes. Use force close or save first.", vim.log.levels.WARN)
        return
    end
    
    -- Get list of windows showing this buffer
    local windows = vim.fn.win_findbuf(bufnr)
    
    -- Get list of all listed buffers excluding the current one
    local buffers = vim.tbl_filter(function(b)
        return vim.fn.buflisted(b) == 1 and b ~= bufnr
    end, vim.api.nvim_list_bufs())
    
    -- Determine which buffer to show next
    local next_bufnr = nil
    
    -- First try the alternate buffer (#)
    local alt_bufnr = vim.fn.bufnr('#')
    if alt_bufnr ~= -1 and alt_bufnr ~= bufnr and vim.fn.buflisted(alt_bufnr) == 1 then
        next_bufnr = alt_bufnr
    elseif #buffers > 0 then
        -- Otherwise use the first available listed buffer
        next_bufnr = buffers[1]
    end
    
    -- Switch each window showing this buffer to the next buffer or a new empty buffer
    for _, win in ipairs(windows) do
        if next_bufnr then
            vim.api.nvim_win_set_buf(win, next_bufnr)
        else
            -- No other buffers exist, open Oil file explorer in this window
            vim.api.nvim_win_call(win, function()
                vim.cmd('Oil')
            end)
        end
    end
    
    -- Now safely delete the original buffer
    -- Use pcall to handle any edge cases gracefully
    local ok, err = pcall(function()
        if force then
            vim.cmd('silent! bdelete! ' .. bufnr)
        else
            vim.cmd('silent! bdelete ' .. bufnr)
        end
    end)
    
    if not ok and err then
        vim.notify("Error deleting buffer: " .. tostring(err), vim.log.levels.ERROR)
    end
end

-- Close all buffers except the current one
function M.close_all_except_current()
    local current = vim.api.nvim_get_current_buf()
    local buffers = vim.api.nvim_list_bufs()
    
    for _, bufnr in ipairs(buffers) do
        if bufnr ~= current and vim.fn.buflisted(bufnr) == 1 then
            -- Use pcall to handle any errors gracefully
            pcall(function()
                vim.cmd('bdelete ' .. bufnr)
            end)
        end
    end
end

-- Close buffer and move to next
function M.close_and_next()
    -- Get current buffer
    local current_buf = vim.api.nvim_get_current_buf()
    
    -- Get list of all listed buffers excluding the current one
    local buffers = vim.tbl_filter(function(b)
        return vim.fn.buflisted(b) == 1 and b ~= current_buf
    end, vim.api.nvim_list_bufs())
    
    if #buffers > 0 then
        -- Try to move to next buffer first
        vim.cmd('bnext')
        
        -- If we're still on the same buffer, try previous
        if vim.api.nvim_get_current_buf() == current_buf then
            vim.cmd('bprevious')
        end
        
        -- Now close the original buffer
        vim.cmd('silent! bdelete ' .. current_buf)
    else
        -- No other buffers, open Oil and then delete the buffer
        vim.cmd('Oil')
        vim.cmd('silent! bdelete ' .. current_buf)
    end
end

return M
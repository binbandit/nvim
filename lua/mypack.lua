-- Place this in your Neovim config, e.g., lua/mypack.lua
-- Usage: require('mypack').add({ { src = 'https://github.com/folke/tokyonight.nvim', config = true }, ... })
-- Or require('mypack').add({ src = 'https://github.com/folke/tokyonight.nvim', lazy = true, event = 'VeryLazy', ... })
-- Supports multiple: add({ {src=...}, {src=...} })
-- Shorthand: { 'folke/tokyonight.nvim' } assumes https://github.com/
-- For lazy: lazy = true, event = 'EventName', keys = { {'n', '<leader>xx'} }
-- For build: build = 'cargo build --release' or ':TSUpdate' or function() ... end -- shell runs immediately if updated, vim cmds and functions run after load
-- For on_update: on_update = function() ... end -- runs after load if plugin updated or newly installed
-- For config: config = true (calls setup()), or table (setup(table)), or function

local M = {}

local function get_git_head(path)
    local res = vim.system({ 'git', '-C', path, 'rev-parse', 'HEAD' }):wait()
    if res.code == 0 then
        return vim.trim(res.stdout)
    end
    return nil
end

local function single_add(opts)
    local repo = opts.src or opts[1] or opts.repo
    if not repo:match('^https?://') and not repo:match('^/') then
        repo = 'https://github.com/' .. repo
    end
    local name = opts.name or repo:match('[^/]+$'):gsub('%.nvim$', '')
    local lazy = opts.lazy
    local build = opts.build
    local on_update = opts.on_update
    local config = opts.config
    local event = opts.event
    local keys = opts.keys

    local spec = { src = repo }
    if opts.name then spec.name = name end
    if lazy then spec.opt = true end

    local pack_dir = vim.fn.stdpath('data') .. '/site/pack/packs/'
    local subdir = lazy and 'opt' or 'start'
    local path = pack_dir .. subdir .. '/' .. name

    local exists_before = vim.fn.isdirectory(path) == 1

    vim.pack.add({ spec })

    local was_updated = not exists_before
    if (build or on_update) and exists_before then
        local old_head = get_git_head(path)
        vim.system({ 'git', '-C', path, 'pull' }):wait()
        local new_head = get_git_head(path)
        if new_head ~= old_head then
            was_updated = true
        end
    end

    -- Run shell build immediately if applicable
    if was_updated and build and type(build) == 'string' and not build:match('^:') then
        vim.system({ 'sh', '-c', 'cd ' .. vim.fn.shellescape(path) .. ' && ' .. build }):wait()
    end

    local function run_post_load_actions()
        if was_updated then
            if build then
                if type(build) == 'string' and build:match('^:') then
                    vim.cmd(build:sub(2))
                elseif type(build) == 'function' then
                    build()
                end
            end
            if on_update then
                on_update()
            end
        end
    end

    local function do_config()
        if config then
            local plugin = require(name)
            if type(config) == 'table' then
                plugin.setup(config)
            elseif type(config) == 'function' then
                config()
            else
                plugin.setup()
            end
        end
    end

    if not lazy then
        run_post_load_actions()
        do_config()
    else
        local function lazy_load()
            vim.cmd('packadd ' .. name)
            run_post_load_actions()
            do_config()
        end

        if event then
            vim.api.nvim_create_autocmd(event, {
                callback = lazy_load,
                once = true,
            })
        end

        if keys then
            for _, key in ipairs(keys) do
                local mode = key[1] or 'n'
                local lhs = key[2] or key[1]
                vim.keymap.set(mode, lhs, function()
                    lazy_load()
                    local keycode = vim.api.nvim_replace_termcodes(lhs, true, false, true)
                    vim.api.nvim_feedkeys(keycode, 'n', true)
                end, { desc = 'Lazy load ' .. name })
            end
        end
    end
end

function M.add(opts)
    if opts[1] and type(opts[1]) == 'table' then
        for _, subopts in ipairs(opts) do
            single_add(subopts)
        end
    else
        single_add(opts)
    end
end

return M

-- Minimal wrapper around Neovim's built-in package manager (vim.pack)
-- Usage:
--   local pack = require('pack')
--   pack.add({
--     { src = 'nvim-lua/plenary.nvim' },
--     { src = 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
--     { src = 'saghen/blink.cmp', lazy = true, build = 'cargo build --release' },
--   })

local M = {}

-- Queue for Vim commands/functions that require plugin-defined commands
-- to exist. Flushed on VimEnter so plugins are fully sourced.
local pending = {}
local flush_set = false
local function notify(msg, level)
  pcall(vim.notify, msg, level or vim.log.levels.INFO, { title = 'pack' })
end

local function resolve_path(subdir, dir_name)
  local base = vim.fn.stdpath('data') .. '/site/pack'
  local matches = vim.fn.globpath(base, '*/' .. subdir .. '/' .. dir_name, 1, 1)
  if type(matches) == 'table' and #matches > 0 then
    return matches[1]
  end
  return base .. '/core/' .. subdir .. '/' .. dir_name
end

local function path_exists(p)
  local st = vim.loop.fs_stat(p)
  return st and true or false
end

local function wait_for_path(get_path, max_tries, delay_ms, on_ready)
  local function current_path()
    if type(get_path) == 'function' then
      return get_path()
    end
    return get_path
  end
  local p = current_path()
  if path_exists(p) then return on_ready(true, p) end
  local tries = 0
  local function tick()
    tries = tries + 1
    local p2 = current_path()
    if path_exists(p2) then
      return on_ready(true, p2)
    end
    if tries >= max_tries then
      return on_ready(false, p2)
    end
    vim.defer_fn(tick, delay_ms)
  end
  vim.defer_fn(tick, delay_ms)
end

local function run_shell_build(plugin_name, path, cmd, subdir, dir_name)
  notify(string.format("Building %s: %s", plugin_name, cmd))
  -- Ensure the directory exists (clone might still be in-flight)
  local function resolver()
    if path and path_exists(path) then return path end
    return resolve_path(subdir or 'start', dir_name or plugin_name)
  end
  wait_for_path(resolver, 120, 250, function(ok, effective_path)
    if not ok then
      notify(string.format("Build skipped for %s: install path not found\n%s", plugin_name, effective_path), vim.log.levels.WARN)
      return
    end
    -- Run asynchronously so UI doesn’t freeze
    vim.system({ 'sh', '-c', cmd }, { cwd = effective_path }, function(res)
      if res.code == 0 then
        notify(string.format("Build finished: %s", plugin_name), vim.log.levels.INFO)
      else
        local err = (res.stderr or '')
        notify(string.format("Build failed (%s): exit %s\n%s", plugin_name, tostring(res.code), err), vim.log.levels.ERROR)
      end
    end)
  end)
end
local registry = {}
local function queue(fn)
  table.insert(pending, fn)
  if not flush_set then
    flush_set = true
    vim.api.nvim_create_autocmd('VimEnter', {
      once = true,
      callback = function()
        for _, f in ipairs(pending) do
          pcall(f)
        end
        pending = {}
      end,
    })
  end
end

function M.add(list)
  for _, item in ipairs(list) do
    local repo = item.src or item[1] or item.repo
    if not repo then goto continue end

    -- allow shorthand like "owner/repo" by defaulting to GitHub
    local url = repo
    if not url:match('^https?://')
       and not url:match('^git@')
       and not url:match('^ssh://')
       and not url:match('^file://')
       and not url:match('^/') then
      url = 'https://github.com/' .. url
    end

    -- derive plugin dir name from repo URL or "user/repo"
    -- keep repo folder name (including .nvim suffix) for accurate packadd/paths
    local name = (item.name)
      or (url:match('[^/]+$') or url)
      :gsub('%.git$', '')

    local opt_flag = item.lazy or false
    local spec = { src = url, opt = opt_flag }
    if item.version then spec.version = item.version end

    local subdir = opt_flag and 'opt' or 'start'
    local path = resolve_path(subdir, name)

    local function get_head()
      local res = vim.system({ 'git', '-C', path, 'rev-parse', 'HEAD' }):wait()
      if res.code == 0 then return vim.trim(res.stdout) end
      return nil
    end

    local existed = vim.fn.isdirectory(path) == 1
    local old_head = existed and get_head() or nil

    -- install/update via builtin manager (non-fatal on failure)
    local ok, err = pcall(function()
      vim.pack.add({ spec })
    end)
    if not ok then
      vim.schedule(function()
        vim.notify(string.format("pack.add failed for %s: %s", name, tostring(err)), vim.log.levels.WARN)
      end)
      goto continue
    end

    -- refresh path after add in case it was just installed
    path = resolve_path(subdir, name)
    local new_head = get_head()
    local updated = (not existed) or (old_head and new_head and (old_head ~= new_head))

    -- record in registry for later `update_all()`
    registry[name] = {
      name = name,
      path = path,
      opt = opt_flag,
      build = item.build,
      version = item.version,
    }

    -- if updated/new, run optional build hook
    local build = item.build
    if build then
      -- Detect common case: Rust projects not yet built
      local needs_rust_build = false
      if type(build) == 'string' and build:match('cargo%s+build') then
        local stat = vim.loop.fs_stat(path .. '/target/release')
        if not stat then needs_rust_build = true end
      end

      if not updated and not needs_rust_build then
        goto skip_build
      end

      local function ensure_loaded()
        if opt_flag then
          vim.cmd('packadd ' .. name)
        else
          -- ensure newly installed start packages are sourced this session
          pcall(vim.cmd, 'packloadall')
        end
      end

      if type(build) == 'string' then
        if build:sub(1,1) == ':' then
          -- Defer editor commands until VimEnter so they exist
          queue(function()
            ensure_loaded()
            notify(string.format("Running %s for %s", build, name))
            vim.cmd('silent! ' .. build:sub(2))
          end)
        else
          -- shell command inside plugin directory runs asynchronously
          run_shell_build(name, path, build, subdir, name)
        end
      elseif type(build) == 'function' then
        -- Defer lua functions as they may rely on plugin being loaded
        queue(function()
          ensure_loaded()
          notify(string.format("Running build(fn) for %s", name))
          pcall(build)
          notify(string.format("Build(fn) finished: %s", name))
        end)
      end
      ::skip_build::
    end

    ::continue::
  end
end

-- Pull updates for all known plugins and run their build hooks if HEAD changed
function M.update_all()
  for _, it in pairs(registry) do
    -- skip pinned versions (keep tag/commit intact)
    if it.version and it.version ~= 'master' then goto continue end

    -- Re-resolve current install path each run (pack name may differ)
    local subdir = it.opt and 'opt' or 'start'
    local current_path = resolve_path(subdir, it.name)
    if not path_exists(current_path) then
      -- Plugin not installed or not cloned yet; skip quietly
      goto continue
    end

    local function get_head()
      local res = vim.system({ 'git', '-C', current_path, 'rev-parse', 'HEAD' }):wait()
      if res.code == 0 then return vim.trim(res.stdout) end
      return nil
    end

    local before = get_head()

    -- If currently on a detached HEAD but we want master/main, check out a branch
    local branch_res = vim.system({ 'git', '-C', current_path, 'symbolic-ref', '-q', '--short', 'HEAD' }):wait()
    local on_branch = (branch_res.code == 0) and (#vim.trim(branch_res.stdout) > 0)
    if (not on_branch) and (not it.version or it.version == 'master') then
      -- Try master then main
      vim.system({ 'sh', '-c',
        'cd ' .. vim.fn.shellescape(current_path) .. ' && '
        .. '(git checkout master 2>/dev/null || git checkout main 2>/dev/null || true)'
      }):wait()
    end

    -- fetch + fast-forward pull; ignore errors quietly
    vim.system({ 'git', '-C', current_path, 'fetch', '--all', '--tags' }):wait()
    vim.system({ 'git', '-C', current_path, 'pull', '--ff-only' }):wait()
    local after = get_head()

    local changed = (before and after and before ~= after)
    local build = it.build
    local needs_rust_build = false
    if type(build) == 'string' and build:match('cargo%s+build') then
      local stat = vim.loop.fs_stat(current_path .. '/target/release')
      if not stat then needs_rust_build = true end
    end

    if changed or needs_rust_build then
      if build then
        local function ensure_loaded()
          if it.opt then
            vim.cmd('packadd ' .. it.name)
          else
            pcall(vim.cmd, 'packloadall')
          end
        end
        if type(build) == 'string' then
          if build:sub(1,1) == ':' then
            queue(function()
              ensure_loaded()
              notify(string.format("Running %s for %s", build, it.name))
              vim.cmd('silent! ' .. build:sub(2))
            end)
          else
            run_shell_build(it.name, current_path, build, subdir, it.name)
          end
        elseif type(build) == 'function' then
          queue(function()
            ensure_loaded()
            notify(string.format("Running build(fn) for %s", it.name))
            pcall(build)
            notify(string.format("Build(fn) finished: %s", it.name))
          end)
        end
      end
    end

    ::continue::
  end
end

return M

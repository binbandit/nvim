local M = {}

local function is_github_shorthand(s)
  return type(s) == 'string' and (not s:find('://')) and s:match('^[%w%._-]+/[%w%._-]+$') ~= nil
end

local function to_github_url(s)
  return ('https://github.com/%s'):format(s)
end

function M.expand_spec(spec)
  if type(spec) == 'string' then
    if is_github_shorthand(spec) then
      return { src = to_github_url(spec) }
    else
      return { src = spec }
    end
  elseif type(spec) == 'table' then
    local t = vim.deepcopy(spec)
    if t.src and is_github_shorthand(t.src) then
      t.src = to_github_url(t.src)
    end
    return t
  else
    return spec
  end
end

function M.expand_specs(specs)
  local out = {}
  for _, s in ipairs(specs or {}) do
    table.insert(out, M.expand_spec(s))
  end
  return out
end

function M.add(specs, opts)
  local pack = vim.pack
  if not (pack and type(pack.add) == 'function') then return false, 'vim.pack.add not available' end
  local expanded = M.expand_specs(specs)
  return pcall(pack.add, expanded, opts)
end

return M


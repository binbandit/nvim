local M = {}

-- Prefer real definitions over import lines when multiple locations are returned
local function is_import_line(path, lnum)
  local ok, f = pcall(io.open, path, 'r')
  if not ok or not f then return false end
  local i = 1
  for line in f:lines() do
    if i == lnum then
      f:close()
      return line:match('^%s*use%s') or line:match('^%s*import%s')
    end
    i = i + 1
    if i > lnum then break end
  end
  f:close()
  return false
end

function M.goto_definition_smart()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx)
    if err then return end
    if not result then return end
    local locs = result
    if not vim.tbl_islist(locs) then locs = { locs } end
    local preferred
    local current = vim.api.nvim_buf_get_name(0)
    for _, loc in ipairs(locs) do
      local uri = loc.targetUri or loc.uri
      local range = loc.targetSelectionRange or loc.range
      local path = vim.uri_to_fname(uri)
      local lnum = (range.start.line or 0) + 1
      -- Prefer locations not on import lines; prefer other files over current
      if not is_import_line(path, lnum) then
        preferred = loc
        if path ~= current then break end
      end
    end
    vim.lsp.util.jump_to_location(preferred or locs[1], 'utf-8')
  end)
end

return M


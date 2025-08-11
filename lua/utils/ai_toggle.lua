local M = {}

local state_path = (vim.fn.stdpath('state') .. '/supermaven-state.json')
local function read_state()
  local fd = io.open(state_path, 'r')
  if not fd then return { enabled = true } end
  local ok, decoded = pcall(vim.json.decode, fd:read('*a'))
  fd:close()
  if ok and type(decoded) == 'table' then return decoded end
  return { enabled = true }
end

local function write_state(tbl)
  local ok, data = pcall(vim.json.encode, tbl)
  if not ok then return end
  vim.fn.mkdir(vim.fn.fnamemodify(state_path, ':h'), 'p')
  local fd = io.open(state_path, 'w')
  if not fd then return end
  fd:write(data)
  fd:close()
end

M._state = read_state()

local function sm_start()
  if pcall(vim.cmd, 'SupermavenStart') then return end
  local ok, sm = pcall(require, 'supermaven-nvim')
  if ok and sm.start then sm.start() end
end

local function sm_stop()
  if pcall(vim.cmd, 'SupermavenStop') then return end
  local ok, sm = pcall(require, 'supermaven-nvim')
  if ok and sm.stop then sm.stop() end
end

function M.apply()
  if M._state.enabled then sm_start() else sm_stop() end
end

function M.toggle()
  M._state.enabled = not M._state.enabled
  write_state(M._state)
  M.apply()
  vim.notify('Supermaven ' .. (M._state.enabled and 'enabled' or 'disabled'))
end

function M.enabled()
  return M._state.enabled
end

return M


local ok, mini = pcall(require, 'mini.nvim')
if not ok then return end

local function try(mod, conf)
  local ok_mod, m = pcall(require, mod)
  if ok_mod then m.setup(conf or {}) end
end

try('mini.pairs')
try('mini.surround')
try('mini.comment')
try('mini.ai')
try('mini.git')
try('mini.trailspace')
try('mini.files', {
  windows = { preview = true, width_focus = 35, width_nofocus = 25 },
})
try('mini.bufremove')

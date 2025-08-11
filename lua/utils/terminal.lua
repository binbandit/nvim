local M = {}

local term_buf, term_win

local function is_open()
  return term_win and vim.api.nvim_win_is_valid(term_win)
end

function M.toggle()
  if is_open() then
    vim.api.nvim_win_hide(term_win)
    term_win = nil
    return
  end

  -- Reuse terminal buffer if exists
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd('botright split')
    term_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_height(term_win, math.floor(vim.o.lines * 0.25))
    vim.api.nvim_win_set_buf(term_win, term_buf)
    vim.cmd('startinsert')
    return
  end

  -- Create new terminal split
  vim.cmd('botright split')
  term_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_height(term_win, math.floor(vim.o.lines * 0.25))
  term_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(term_win, term_buf)
  vim.fn.termopen(vim.o.shell)
  vim.bo[term_buf].bufhidden = 'hide'
  vim.cmd('startinsert')
end

return M


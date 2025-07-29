-- Learning mode configuration
-- This module manages the learning mode state for Neovim

local M = {}

-- Default state is disabled
M.enabled = false

-- Function to check if learning mode is enabled
function M.is_enabled()
  return M.enabled
end

-- Function to enable learning mode
function M.enable()
  M.enabled = true
  vim.notify("Learning mode enabled! Restart Neovim for changes to take effect.", vim.log.levels.INFO)
end

-- Function to disable learning mode
function M.disable()
  M.enabled = false
  vim.notify("Learning mode disabled! Restart Neovim for changes to take effect.", vim.log.levels.INFO)
end

-- Function to toggle learning mode
function M.toggle()
  if M.enabled then
    M.disable()
  else
    M.enable()
  end
end

return M
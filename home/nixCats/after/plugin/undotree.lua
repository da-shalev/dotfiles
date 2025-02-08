local M = {}
local remap = require "usr.remap"

M.loaded = false

M.toggle = function()
  if not M.loaded then
    vim.api.nvim_command("packadd undotree")
    M.loaded = true
  end

  vim.cmd("UndotreeToggle")
end

vim.keymap.set("n", "<leader>u", function() M.toggle() end, remap.opt)

return M

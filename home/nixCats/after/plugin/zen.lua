local remap = require "usr.remap"
local M = {}

M.loaded = false
M.plugin = nil
M.opts = {
  window = {
    backdrop = 1,
    width = 80,
    options = {
      signcolumn = "no",
      number = false,
      relativenumber = false,
      cursorline = false,
      cursorcolumn = false,
    },
  },
}

M.toggle = function()
  if not M.loaded then
    vim.api.nvim_command("packadd zen-mode.nvim")
    M.loaded = true
    M.plugin = require("zen-mode")
    M.plugin.setup(M.opts)
  end

  M.plugin.toggle()
end

vim.keymap.set("n", "<leader>z", function() M.toggle() end, remap.opt)

return M

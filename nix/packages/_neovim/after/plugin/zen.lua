local remap = require "usr.remap"
local M = {}

M.plugin = require("zen-mode")
M.plugin.setup({
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
})

vim.keymap.set("n", "<leader>z", function() M.plugin.toggle() end, remap.opt)

return M

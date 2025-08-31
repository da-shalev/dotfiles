local remap = require "me.remap"
vim.keymap.set("n", "<leader>u", function() vim.cmd("UndotreeToggle") end, remap.opt)

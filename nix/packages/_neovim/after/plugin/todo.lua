local M = {}
M.plugin = require("todo-comments")
M.plugin.setup({})

vim.keymap.set("n", "]t", function()
  M.plugin.jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  M.plugin.jump_prev()
end, { desc = "Previous todo comment" })

return M

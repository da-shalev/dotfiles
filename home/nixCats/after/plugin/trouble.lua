local M = {}

M.loaded = false
M.plugin = nil

M.toggle = function(cmd)
  if not M.loaded then
    vim.api.nvim_command("packadd trouble.nvim")
    M.loaded = true
    M.plugin = require("trouble")
    M.plugin.setup({})
  end

  vim.cmd(cmd)
end

vim.keymap.set("n", "<leader>xx", function() M.toggle("Trouble diagnostics toggle") end,
  { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", function() M.toggle("Trouble diagnostics toggle filter.buf=0") end,
  { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", function() M.toggle("Trouble symbols toggle focus=false") end,
  { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cl", function() M.toggle("Trouble lsp toggle focus=false win.position=right") end,
  { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set("n", "<leader>xL", function() M.toggle("Trouble loclist toggle") end, { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", function() M.toggle("Trouble qflist toggle") end, { desc = "Quickfix List (Trouble)" })

return M

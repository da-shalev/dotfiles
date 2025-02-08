local M = {}
M.opt = { silent = true }

vim.keymap.set("n", "<leader>q", ":qa!<cr>", M.opt)
vim.keymap.set("n", "<leader>R", ":!chmod +x %<cr>", M.opt)
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, M.opt)

M.vsplit = function()
  vim.cmd("vsplit")
  vim.cmd("Ex")
end

M.split = function()
  vim.cmd("split")
  vim.cmd("Ex")
end

vim.keymap.set("n", "<leader>5", function()
  M.vsplit()
end, M.opt)

vim.keymap.set("n", "<leader>'", function()
  M.split()
end, M.opt)

-- patchy
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", M.opt)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", M.opt)
vim.keymap.set("v", "<S-h>", "<gv", M.opt)
vim.keymap.set("v", "<S-l>", ">gv", M.opt)
vim.keymap.set("x", "<leader>p", [["_dP]], M.opt)         -- paste without yank
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], M.opt) -- delete without yank

-- center
vim.keymap.set("n", "J", "mzJ`z", M.opt)
vim.keymap.set("n", "<C-d>", "<C-d>zz", M.opt)
vim.keymap.set("n", "<C-u>", "<C-u>zz", M.opt)
vim.keymap.set("n", "n", "nzzzv", M.opt)
vim.keymap.set("n", "N", "Nzzzv", M.opt)

return M

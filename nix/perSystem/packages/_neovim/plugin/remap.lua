local opt = { silent = true }

vim.keymap.set('n', '<leader>q', ':qa!<cr>', opt)
vim.keymap.set('n', '<leader>R', ':!chmod +x %<cr>', opt)
vim.keymap.set('n', '<leader>e', vim.cmd.Ex, opt)

vim.keymap.set('n', '<leader>5', function()
  vim.cmd('vsplit')
  vim.cmd('Ex')
end, opt)

vim.keymap.set('n', "<leader>'", function()
  vim.cmd('split')
  vim.cmd('Ex')
end, opt)

-- patchy
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", opt)
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", opt)
vim.keymap.set('v', '<S-h>', '<gv', opt)
vim.keymap.set('v', '<S-l>', '>gv', opt)
vim.keymap.set('x', '<leader>p', [["_dP]], opt) -- paste without yank
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], opt) -- delete without yank

-- center
vim.keymap.set('n', 'J', 'mzJ`z', opt)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opt)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opt)
vim.keymap.set('n', 'n', 'nzzzv', opt)
vim.keymap.set('n', 'N', 'Nzzzv', opt)

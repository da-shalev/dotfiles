local telescope = require('telescope')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local opts = {
  previewer = true,
  hidden = true,
  no_ignore = false,
  file_ignore_patterns = {
    '.direnv',
    'target',
    '%.git',
    '%.ase',
    '%.jpeg',
    '%.jpg',
    '%.png',
    '.vscode',
  },
}

local find = function()
  builtin.find_files(themes.get_dropdown(opts))
end

local grep = function()
  builtin.live_grep(themes.get_dropdown(opts))
end

if not vim.g.is_tty then
  opts.prompt_prefix = ' '
  opts.selection_caret = ' '
end

telescope.setup({ defaults = opts })

vim.keymap.set('n', '<leader>f', function()
  find()
end, { silent = true })
vim.keymap.set('n', '<leader>F', function()
  grep()
end, { silent = true })
vim.keymap.set('n', '<leader>"', function()
  vim.cmd('split')
  vim.cmd('Ex')
  find()
end, { silent = true })
vim.keymap.set('n', '<leader>%', function()
  vim.cmd('vsplit')
  vim.cmd('Ex')
  find()
end, { silent = true })

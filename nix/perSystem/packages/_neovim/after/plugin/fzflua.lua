local fzf = require('fzf-lua')

local opts = {
  winopts = {
    preview = {
      default = 'builtin',
    },
  },
  file_ignore_patterns = {
    '.direnv/',
    'target/',
    '.git/',
    '%.ase$',
    '%.jpeg$',
    '%.jpg$',
    '%.png$',
    '.vscode/',
  },
  files = {
    hidden = true,
    no_ignore = false,
  },
  grep = {
    hidden = true,
    no_ignore = false,
  },
}

fzf.setup(opts)

vim.keymap.set('n', '<leader>f', function()
  fzf.files()
end, { silent = true })

vim.keymap.set('n', '<leader>F', function()
  fzf.live_grep()
end, { silent = true })

vim.keymap.set('n', '<leader>"', function()
  vim.cmd('split')
  vim.cmd('Ex')
  fzf.files()
end, { silent = true })

vim.keymap.set('n', '<leader>%', function()
  vim.cmd('vsplit')
  vim.cmd('Ex')
  fzf.files()
end, { silent = true })

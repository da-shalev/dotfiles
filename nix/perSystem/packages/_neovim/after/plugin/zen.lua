local plugin = require('zen-mode')

plugin.setup({
  window = {
    backdrop = 1,
    width = 80,
    options = {
      signcolumn = 'no',
      number = false,
      relativenumber = false,
      cursorline = false,
      cursorcolumn = false,
    },
  },
})

vim.keymap.set('n', '<leader>z', function()
  plugin.toggle()
end, { silent = true })

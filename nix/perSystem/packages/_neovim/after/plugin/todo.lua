local plugin = require('todo-comments')
plugin.setup({})

vim.keymap.set('n', ']t', function()
  plugin.jump_next()
end, { desc = 'Next todo comment' })

vim.keymap.set('n', '[t', function()
  plugin.jump_prev()
end, { desc = 'Previous todo comment' })

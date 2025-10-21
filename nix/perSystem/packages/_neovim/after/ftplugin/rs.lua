vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust_analyzer'] = {
      rust_analyzer = {
        files = {
          excludeDirs = { '.direnv' },
        },
      },
    },
  },
})

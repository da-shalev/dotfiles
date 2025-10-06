vim.lsp.config('nil_ls', {
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

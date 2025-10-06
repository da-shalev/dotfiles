vim.lsp.config('nil_ls', {
  settings = {
    ['nil'] = {
      nix = {
        flake = {
          autoArchive = true,
        },
      },
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      telemetry = { enable = false },
      format = { enable = false },
    },
  },
})

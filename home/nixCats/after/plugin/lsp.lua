if require('usr.lsps').enabled then
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      vim.api.nvim_command("packadd nvim-autopairs")
      require "nvim-autopairs".setup {}
    end,
  })

  require "lsp_signature".setup {
    bind = true,
    floating_window_above_cur_line = true,
    handler_opts = {
      border = "none",
    },
  }

  require('nvim-ts-autotag').setup({})
end

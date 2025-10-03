vim.api.nvim_create_autocmd('FileType', {
  callback = function(event)
    local bufnr = event.buf
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })

    if filetype == '' then
      return
    end

    local parser_name = vim.treesitter.language.get_lang(filetype)
    if not parser_name then
      return
    end
    local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
    if not parser_installed then
      return
    end

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.treesitter.start()
  end,
})

require('nvim-ts-autotag').setup({})

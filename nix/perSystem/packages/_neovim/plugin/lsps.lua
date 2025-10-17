require('lazydev').setup()
require('Comment').setup()

local conform = require('conform')
conform.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    nix = { 'nixfmt' },
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    md = { 'prettier' },
    mdx = { 'prettier' },
    astro = { 'prettier' },
    css = { 'prettier' },
    yaml = { lsp_format = 'fallback' },
    toml = { lsp_format = 'fallback' },
  },
  -- knowing your formatter is nice
  -- default_format_opts = {
  -- lsp_format = 'fallback',
  -- },
})

vim.lsp.enable({
  'nil_ls',
  'lua_ls',
  'jsonls',
  'svelte',
  'clangd',
  'pyright',
  'html',
  'astro',
  'taplo',
  'tailwindcss',
  'cssls',
  'ts_ls',
  'rust_analyzer',
  'zls',
  'yamlls',
  'eslint',
})

local capabilities = require('blink.cmp').get_lsp_capabilities()
local inlay_hints = false

local format = function(args)
  -- vim.lsp.buf.format({ async = true })
  conform.format({ args = args })
end

local keymaps = function(bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set('n', 'gd', function()
    vim.lsp.buf.definition()
  end, opts)

  vim.keymap.set('n', 'gl', function()
    vim.diagnostic.open_float()
  end, opts)

  vim.keymap.set('n', 'gh', function()
    inlay_hints = not inlay_hints
    vim.lsp.inlay_hint.enable(inlay_hints)
  end, { desc = 'toggle inlay hints' })

  vim.keymap.set('n', '<leader>as', function()
    vim.lsp.buf.workspace_symbol()
  end, opts)

  vim.keymap.set('n', '<leader>aa', function()
    vim.lsp.buf.code_action()
  end, opts)

  vim.keymap.set('n', '<leader>ad', function()
    vim.lsp.buf.references()
  end, opts)

  vim.keymap.set('n', '<leader>ar', function()
    vim.lsp.buf.rename()
  end, opts)

  vim.keymap.set('n', '<leader>af', function()
    format(bufnr)
  end, opts)

  vim.keymap.set('n', '<leader>aj', function()
    vim.diagnostic.jump({ count = 1 })
  end, opts)

  vim.keymap.set('n', '<leader>ak', function()
    vim.diagnostic.jump({ count = -1 })
  end, opts)

  vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover()
    vim.lsp.buf.hover()
  end, opts)

  vim.keymap.set('i', '<C-h>', function()
    vim.lsp.buf.signature_help()
  end, opts)
end

local on_attach = function(buf)
  vim.api.nvim_create_augroup('lsp_augroup', { clear = true })

  keymaps(buf)

  vim.api.nvim_buf_create_user_command(buf, 'Format', function(_)
    format(buf)
  end, { desc = 'Format current buffer' })
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'My LSP settings',
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    on_attach(args.buf)
  end,
})

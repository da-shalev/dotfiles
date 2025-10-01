local M = {}

require('lazydev').setup()
require('Comment').setup()

M.capabilities = require('blink.cmp').get_lsp_capabilities()
M.conform = require('conform')

M.conform.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
  },
})

M.format = function(bufnr)
  -- vim.lsp.buf.format({ async = true })
  M.conform.format({ bufnr = bufnr })
end

M.keymaps = function(bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set('n', 'gd', function()
    vim.lsp.buf.definition()
  end, opts)

  vim.keymap.set('n', 'gl', function()
    vim.diagnostic.open_float()
  end, opts)

  vim.keymap.set('n', 'gh', function()
    M.inlay_hints = not M.inlay_hints
    vim.lsp.inlay_hint.enable(M.inlay_hints)
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
    M.format(bufnr)
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

M.on_attach = function(_, bufnr)
  vim.api.nvim_create_augroup('lsp_augroup', { clear = true })

  M.keymaps(bufnr)

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    M.format(bufnr)
  end, { desc = 'Format current buffer' })
end

vim.lsp.config('lua_ls', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  settings = {
    Lua = {
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable('lua_ls')

vim.lsp.config('nil_ls', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  settings = {
    ['nil'] = {
      nix = {
        flake = {
          autoArchive = true,
        },
      },
      formatting = {
        command = { 'nixfmt' },
      },
    },
  },
})
vim.lsp.enable('nil_ls')

vim.lsp.config('jsonls', {
  autostart = true,
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})
vim.lsp.enable('jsonls')

vim.lsp.config('svelte', {
  autostart = true,
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})
vim.lsp.enable('svelte')

vim.lsp.config('clangd', {
  autostart = true,
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})
vim.lsp.enable('clangd')

-- vim.lsp.config('psalm', {
--   capabilities = M.capabilities,
--   on_attach = M.on_attach,
-- })

-- vim.lsp.config('intelephense', {
--   capabilities = M.capabilities,
--   on_attach = M.on_attach,
-- })

vim.lsp.config('pyright', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})
vim.lsp.enable('pyright')

vim.lsp.config('html', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  filetypes = { 'html', 'templ', 'svg', 'xml' },
})
vim.lsp.enable('html')

vim.lsp.config('astro', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  settings = {
    astro = {
      contentIntellisense = true,
    },
  },
})
vim.lsp.enable('astro')

vim.lsp.config('tailwindcss', {
  autostart = true,
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})
vim.lsp.enable('tailwindcss')

vim.lsp.config('cssls', {
  autostart = true,
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})
vim.lsp.enable('cssls')

-- vim.lsp.config.mdx_analyzer.setup {
--   capabilities = M.capabilities,
--   on_attach = M.on_attach,
-- }

vim.lsp.config('emmet_ls', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  filetypes = {
    'astro',
    'css',
    'eruby',
    'html',
    'htmldjango',
    'javascriptreact',
    'less',
    'php',
    'pug',
    'sass',
    'scss',
    'svelte',
    'typescriptreact',
    'vue',
  },
})
vim.lsp.enable('emmet_ls')

vim.lsp.config('ts_ls', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  init_options = {
    maxTsServerMemory = 8192,
  },
})
vim.lsp.enable('emmet_ls')

vim.lsp.config('rust_analyzer', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
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
vim.lsp.enable('emmet_ls')

vim.lsp.config('zls', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
})
vim.lsp.enable('emmet_ls')

vim.lsp.config('yamlls', {
  capabilities = M.capabilities,
  on_attach = M.on_attach,
  settings = {
    yaml = {
      format = { enable = true },
    },
  },
})
vim.lsp.enable('emmet_ls')

return M

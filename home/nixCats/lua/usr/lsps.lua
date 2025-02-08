local M = {}

M.enabled = nixCats('lsps-enabled')

if M.enabled then
  require("neodev").setup()

  vim.api.nvim_command("packadd crates.nvim")
  require("crates").setup({})
  require('Comment').setup()

  M.conform = require("conform")
  M.capabilities = require("cmp_nvim_lsp").default_capabilities()
  M.format = function(bufnr)
    M.conform.format({ bufnr, lsp_fallback = true })
  end

  M.keymaps = function(bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition()
    end, opts)

    vim.keymap.set("n", "gl", function()
      vim.diagnostic.open_float()
    end, opts)

    vim.keymap.set("n", "gh", function()
      M.inlay_hints = not M.inlay_hints
      vim.lsp.inlay_hint.enable(M.inlay_hints)
    end, { desc = "toggle inlay hints" })

    vim.keymap.set("n", "<leader>as", function()
      vim.lsp.buf.workspace_symbol()
    end, opts)

    vim.keymap.set("n", "<leader>aa", function()
      vim.lsp.buf.code_action()
    end, opts)

    vim.keymap.set("n", "<leader>ad", function()
      vim.lsp.buf.references()
    end, opts)

    vim.keymap.set("n", "<leader>ar", function()
      vim.lsp.buf.rename()
    end, opts)

    vim.keymap.set("n", "<leader>af", function()
      M.format(bufnr)
    end, opts)

    vim.keymap.set("n", "<leader>aj", function()
      vim.diagnostic.goto_next()
    end, opts)

    vim.keymap.set("n", "<leader>ak", function()
      vim.diagnostic.goto_prev()
    end, opts)

    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
      vim.lsp.buf.hover()
    end, opts)

    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, opts)
  end

  M.on_attach = function(_, bufnr)
    vim.api.nvim_create_augroup("lsp_augroup", { clear = true })

    M.keymaps(bufnr)

    vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
      M.format(bufnr)
    end, { desc = "Format current buffer" })
  end

  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.HINT] = "󰌶",
        [vim.diagnostic.severity.INFO] = "",
      },
    },
    float = {
      border = "none",
    },
  })

  require("conform").setup({
    formatters_by_ft = {
      ["*"] = { "trim_newlines" },
      json = { "jq" },
      nix = { "nixfmt" },
      sh = { "shfmt" },
      yaml = { "yq" },
      astro = { "prettier" },
    },
  })

  local lspconfig = require("lspconfig")

  lspconfig.nil_ls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  lspconfig.lua_ls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    settings = {
      Lua = {
        telemetry = { enable = false },
        hint = {
          enable = true,
        },
      },
    },
  })

  lspconfig.clangd.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  lspconfig.psalm.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  lspconfig.intelephense.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  lspconfig.html.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  lspconfig.astro.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  lspconfig.tailwindcss.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  lspconfig.cssls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  lspconfig.emmet_ls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    filetypes = {
      "astro",
      "css",
      "eruby",
      "html",
      "htmldjango",
      "javascriptreact",
      "less",
      "php",
      "pug",
      "sass",
      "scss",
      "svelte",
      "typescriptreact",
      "vue",
    },
  })

  lspconfig.ts_ls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })

  lspconfig.rust_analyzer.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
    settings = {
      ["rust_analyzer"] = {
        rust_analyzer = {
          files = {
            excludeDirs = { ".direnv" },
          },
        },
      },
    },
  })

  lspconfig.zls.setup({
    capabilities = M.capabilities,
    on_attach = M.on_attach,
  })
end

return M

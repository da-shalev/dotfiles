if not vim.g.is_tty then
  require("gruvbox").setup({
    undercurl = false,
    underline = true,
    transparent_mode = true,
    dim_inactive = false,
  })

  vim.cmd.colorscheme("gruvbox")

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
else
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "E",
        [vim.diagnostic.severity.WARN] = "W",
        [vim.diagnostic.severity.HINT] = "H",
        [vim.diagnostic.severity.INFO] = "I",
      },
    },
    float = {
      border = "none",
    },
  })
end

require("lualine").setup({
  options = {
    icons_enabled = not vim.g.is_tty,
    theme = "auto",
    component_separators = "",
    section_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "filename" },
    lualine_c = { "" },
    lualine_x = { "" },
    lualine_y = { "" },
    lualine_z = { "branch" },
  },
})

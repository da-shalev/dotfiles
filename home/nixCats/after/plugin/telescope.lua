local remap = require("usr.remap")
local M = {}

M.telescope = require "telescope"
M.builtin = require "telescope.builtin"
M.themes = require "telescope.themes"
M.opts = {
  previewer = true,
  hidden = true,
  no_ignore = false,
}

M.vsplit = function()
  remap.vsplit()
  M.find()
end

M.split = function()
  remap.split()
  M.find()
end

M.find = function()
  M.builtin.find_files(M.themes.get_dropdown(M.opts))
end

M.grep = function()
  M.builtin.live_grep(M.themes.get_dropdown(M.opts))
end

M.telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    file_ignore_patterns = {
      ".direnv",
      "target",
      ".git",
      ".cache",
      "%.ase",
      "%.jpeg",
      "%.jpg",
      "%.png",
      ".vscode",
    },
  },
})

vim.keymap.set("n", "<leader>f", function() M.find() end, M.opt)
vim.keymap.set("n", "<leader>F", function() M.grep() end, M.opt)
vim.keymap.set("n", "<leader>\"", function() M.split() end, M.opt)
vim.keymap.set("n", "<leader>%", function() M.vsplit() end, M.opt)

return M

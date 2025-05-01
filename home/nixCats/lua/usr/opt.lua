vim.loader.enable()

vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.guicursor = ""
vim.opt.completeopt = { "menuone", "noselect" }
-- searches don't account for uppercase and lowercase letters
vim.opt.ignorecase = true
vim.opt.mouse = "a"
vim.opt.showtabline = 0
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.writebackup = false
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.nu = true
-- enable a global status line across all windows
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.relativenumber = true
vim.opt.numberwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.title = true
vim.opt.undofile = true
vim.opt.undodir = os.getenv("XDG_CACHE_HOME") .. "/vimundo"
vim.opt.hlsearch = false

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.smartindent = false
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.g.netrw_list_hide = ".DS_Store"
vim.g.netrw_sort_reverse = 1

-- stop commenting on new lines
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})

require 'nixCatsUtils'.setup {
  non_nix_value = true,
}

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'usr.opt'
require 'usr.remap'
require 'usr.appearance'
require 'usr.lsps'

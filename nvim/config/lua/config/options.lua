-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.mapleader = ";"

vim.opt.winbar = "%=%m %f"
vim.opt.wrap = true
vim.opt.textwidth = 80
vim.opt.tabstop = 4

vim.g.line_height = 3

-- Enable 24-bit RGB colors and italic support
vim.opt.termguicolors = true

-- Ensure italic fonts work in terminal
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

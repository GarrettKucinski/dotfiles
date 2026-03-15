-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Clear colorcolumn in terminal buffers so it doesn't render as visible lines
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.colorcolumn = ""
  end,
})

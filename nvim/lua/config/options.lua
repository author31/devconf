-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- Disable auto code format on save globally in LazyVim
vim.g.autoformat = false

-- Python LSP
vim.g.lazyvim_python_lsp = "jedi_language_server"
vim.g.lazyvim_python_ruff = "ruff"

vim.opt.winbar = "%=%t"



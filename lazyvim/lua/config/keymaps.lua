-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--

-- Personal_configurations
vim.keymap.set("i", "jk", "<ESC>", { noremap = true })
-- Set tab width to 4 spaces
vim.opt.tabstop = 4 -- Width of tab character
vim.opt.softtabstop = 4 -- Fine-tunes the amount of whitespace to be added
vim.opt.shiftwidth = 4 -- Width of indentation
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.autoread = true
vim.opt.wrap = false
vim.g.clipboard = {
  name = "OSC52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- Enable relative line numbers
vim.opt.number = true -- Show current line number
vim.opt.relativenumber = true -- Show relative line numbers

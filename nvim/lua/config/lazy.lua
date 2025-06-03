-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup {
  spec = {
    { import = "plugins" },
    { "bwpge/lazy-events.nvim", version = "*" },
    {
      "nvim-neorg/neorg",
      -- lazy-load on filetype
      ft = "norg",
      -- options for neorg. This will automatically call `require("neorg").setup(opts)`
      opts = {
        load = {
          ["core.defaults"] = {},
        },
      },
    },
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      opts = {
        ensure_installed = {
          "pyright", -- Python LSP
          "black", -- Python formatter
          "ruff", -- Python linter
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
  },
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

  -- automatically check for plugin updates
  checker = { enabled = true },
}

-- Personal_configurations
vim.keymap.set("i", "jk", "<ESC>", { noremap = true })
-- Set tab width to 4 spaces
vim.opt.tabstop = 4 -- Width of tab character
vim.opt.softtabstop = 4 -- Fine-tunes the amount of whitespace to be added
vim.opt.shiftwidth = 4 -- Width of indentation
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.autoread = true
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

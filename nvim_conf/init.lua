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
      "nvim-telescope/telescope.nvim",
      tag = "0.1.5",
      dependencies = {
        "nvim-lua/plenary.nvim",
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          build = "make",
        },
      },
      config = function()
        local telescope = require "telescope"
        local builtin = require "telescope.builtin"

        -- Basic telescope configuration
        telescope.setup {
          defaults = {
            file_ignore_patterns = {
              "node_modules",
              ".git",
            },
            mappings = {
              i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
              },
            },
          },
          pickers = {
            find_files = {
              hidden = true,
            },
          },
        }

        -- Enable fzf native
        telescope.load_extension "fzf"

        -- Keymaps
        vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      end,
    },
    {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      keys = {
        {
          -- Customize the keymap if you want to trigger formatting manually
          "<leader>f",
          function() require("conform").format { async = true, lsp_fallback = true } end,
          mode = "",
          desc = "Format buffer",
        },
      },
      opts = {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black", "ruff_format" },
        },
        -- Set up format-on-save
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
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

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
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

-- Enable relative line numbers
vim.opt.number = true -- Show current line number
vim.opt.relativenumber = true -- Show relative line numbers

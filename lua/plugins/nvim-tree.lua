-- lua/plugins/nvim-tree.lua
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional: for file icons
    config = function()
      -- Basic setup for nvim-tree
      require("nvim-tree").setup {
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
          side = "right", -- Explicitly set tree on the left (default, but added for clarity)
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false, -- Show dotfiles by default (toggle with `H`)
        },
      }

      -- Automatically open nvim-tree on Neovim startup
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function() require("nvim-tree.api").tree.open() end,
      })

      -- Keybinding to toggle NvimTree visibility with Alt-b
      vim.keymap.set("n", "<A-b>", ":NvimTreeToggle<CR>", { silent = true })

      -- Keybinding to toggle focus between tree and source code with Alt-i
      vim.keymap.set("n", "<A-i>", function()
        local api = require "nvim-tree.api"
        if vim.bo.filetype == "NvimTree" then
          -- If in tree, move focus to previous window (source code)
          vim.cmd "wincmd p"
        else
          -- If in source code, focus the tree
          api.tree.focus()
        end
      end, { silent = true, desc = "Toggle focus between NvimTree and source code" })
    end,
  },
}

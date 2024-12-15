return {
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
    local actions = require "telescope.actions"

    telescope.setup {
      defaults = {
        file_ignore_patterns = {
          "yarn%.lock",
          "node_modules/",
          "raycast/",
          "dist/",
          "%.next",
          "%.git/",
          "%.gitlab/",
          "build/",
          "target/",
          "package%-lock%.json",
        },
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<C-t>"] = actions.select_tab, -- Open in new tab
            ["<C-s>"] = actions.select_horizontal, -- Open in horizontal split
            ["<C-v>"] = actions.select_vertical, -- Open in vertical split
          },
          n = {
            ["t"] = actions.select_tab, -- Open in new tab (normal mode)
            ["s"] = actions.select_horizontal, -- Open in horizontal split (normal mode)
            ["v"] = actions.select_vertical, -- Open in vertical split (normal mode)
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

    -- Keymaps for Telescope

    vim.keymap.set(
      "n",
      "<leader><leader>",
      function() builtin.find_files { hidden = true } end,
      { desc = "Find all files (ignore .gitignore)" }
    )
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

    -- Tab switching with Alt+1 through Alt+9
    for i = 1, 9 do
      vim.keymap.set("n", string.format("<A-%d>", i), string.format("%dgt", i), { desc = "Go to tab " .. i })
    end

    -- Pane switching with Ctrl+1 (and additional pane controls)
    vim.keymap.set("n", "<C-1>", "<C-w>w", { desc = "Cycle through panes" })

    -- Additional useful pane navigation (optional)
    vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left pane" })
    vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below pane" })
    vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above pane" })
    vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right pane" })

    -- Tab management
    vim.keymap.set("n", "M-n", ":tabnew<CR>", { desc = "New tab" })
    vim.keymap.set("n", "M-w", ":tabclose<CR>", { desc = "Close tab" })

    -- Pane management
    vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Close current pane" })
    vim.keymap.set("n", "<leader>=", "<C-w>=", { desc = "Equalize pane sizes" })
  end,
}

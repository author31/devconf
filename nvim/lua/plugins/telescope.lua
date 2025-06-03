return {
  "nvim-telescope/telescope.nvim",
  versions="v0.1.8",
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
    vim.keymap.set("n", "<leader>fs", function() builtin.lsp_document_symbols({ symbols = { "Function", "Method" }, }) end, { desc = "LSP document symbols (Functions/Methods)" })
    vim.keymap.set("n", "<leader>fi", function() builtin.find_files({ hidden = true, no_ignore = true, prompt_title = "Find All Files (including git-ignored)" }) end, { desc = "Find all files including git-ignored" })
    vim.keymap.set("n", "<leader>gr", function() require("telescope.builtin").lsp_references() end, { desc = "List all references" })
  end,
}

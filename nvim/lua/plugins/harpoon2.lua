-- lua/plugins/harpoon2.lua
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require "harpoon"

    -- REQUIRED: Initialize Harpoon
    harpoon:setup()

    -- Keybindings for Harpoon
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Add file to Harpoon" })

    vim.keymap.set(
      "n",
      "<C-e>",
      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
      { desc = "Toggle Harpoon Quick Menu" }
    )

    -- Navigate to files 1 through 4 in Harpoon list
    vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Go to Harpoon file 1" })

    vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "Go to Harpoon file 2" })

    vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Go to Harpoon file 3" })

    vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Go to Harpoon file 4" })

    -- Optional: Telescope integration for Harpoon
    local conf = require("telescope.config").values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon Files",
          finder = require("telescope.finders").new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end

    vim.keymap.set(
      "n",
      "<leader>h",
      function() toggle_telescope(harpoon:list()) end,
      { desc = "Open Harpoon files with Telescope" }
    )
  end,
}

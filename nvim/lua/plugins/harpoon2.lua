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

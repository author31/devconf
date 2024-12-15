-- lua/plugins/nvim-tree.lua
return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- For file icons
    config = function()
      local api = require "nvim-tree.api"

      -- Custom toggle function to prevent fullscreen expansion
      local function toggle_nvim_tree()
        local is_tree_open = api.tree.is_visible()
        local is_last_tab = #vim.api.nvim_list_tabpages() == 1
        local is_last_window = #vim.api.nvim_tabpage_list_wins(0) == 1

        if is_tree_open then
          -- If tree is open, check if closing it would leave a single window in the last tab
          if is_last_tab and is_last_window then
            -- Instead of closing, open a new buffer to prevent fullscreen expansion
            vim.cmd("enew") -- Open a new empty buffer
            vim.cmd("wincmd p") -- Move focus back to tree
            api.tree.close() -- Close the tree
            vim.cmd("wincmd =") -- Equalize window sizes
          else
            -- Normal close behavior
            api.tree.close()
            vim.cmd("wincmd =") -- Equalize remaining windows to prevent fullscreen
          end
        else
          -- Open the tree normally
          api.tree.open()
          vim.cmd("wincmd =") -- Equalize windows after opening
        end
      end

      -- Basic setup for nvim-tree
      require("nvim-tree").setup {
        sort = {
          sorter = "case_sensitive", -- Sort files case-sensitively
        },
        view = {
          width = 30, -- Fixed width of the tree
          side = "right", -- Place tree on the right side
        },
        renderer = {
          group_empty = true, -- Group empty folders
          highlight_git = true, -- Highlight git status
          icons = {
            show = {
              git = true, -- Show git icons
              file = true,
              folder = true,
              folder_arrow = true,
            },
            glyphs = {
              git = {
                unstaged = "󰄱", -- Same as Neo-tree's unstaged symbol
                staged = "󰱒", -- Same as Neo-tree's staged symbol
                untracked = "┆", -- Match gitsigns.nvim
              },
            },
          },
        },
        filters = {
          dotfiles = false, -- Show dotfiles by default (toggle with `H`)
          custom = { -- Ignore common directories
            "^.git$",
            "^node_modules$",
            "^dist$",
            "^build$",
            "^target$",
          },
        },
        git = {
          enable = true, -- Enable git integration
          ignore = false, -- Show git-ignored files
          timeout = 500, -- Timeout for git status
        },
        filesystem_watchers = {
          enable = true, -- Watch filesystem for changes
        },
        actions = {
          open_file = {
            quit_on_open = false, -- Keep tree open after opening a file
            window_picker = {
              enable = true, -- Allow picking window for file opening
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
        },
        diagnostics = {
          enable = true, -- Show LSP diagnostics in the tree
          show_on_dirs = true, -- Show diagnostics on directories
        },
        update_focused_file = {
          enable = true, -- Follow current file in tree
          update_root = false, -- Don't change tree root
        },
        -- Custom keybindings
        on_attach = function(bufnr)
          local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- Custom keybindings inspired by Neo-tree
          vim.keymap.set("n", "l", api.node.open.edit, opts)
          vim.keymap.set("n", "h", api.node.navigate.parent_close, opts)
          vim.keymap.set("n", "<CR>", api.node.open.edit, opts)
          vim.keymap.set("n", "v", api.node.open.vertical, opts)
          vim.keymap.set("n", "s", api.node.open.horizontal, opts)
          vim.keymap.set("n", "t", api.node.open.tab, opts)
          vim.keymap.set("n", "Y", function()
            local node = api.tree.get_node_under_cursor()
            vim.fn.setreg("+", node.absolute_path, "c")
            vim.notify("Copied path to clipboard: " .. node.absolute_path, vim.log.levels.INFO)
          end, opts)
          vim.keymap.set("n", "O", function()
            local node = api.tree.get_node_under_cursor()
            require("lazy.util").open(node.absolute_path, { system = true })
          end, opts)
          vim.keymap.set("n", "P", api.node.open.preview, opts)
        end,
      }

      -- Keybinding to toggle NvimTree visibility with Alt-b
      vim.keymap.set("n", "<A-b>", toggle_nvim_tree, { silent = true, desc = "Toggle NvimTree visibility" })

      -- Keybinding to toggle focus between tree and source code with Alt-i
      vim.keymap.set("n", "<A-i>", function()
        if vim.bo.filetype == "NvimTree" then
          -- If in tree, move focus to previous window (source code)
          vim.cmd "wincmd p"
        else
          -- If in source code, focus the tree
          api.tree.focus()
        end
      end, { silent = true, desc = "Toggle focus between NvimTree and source code" })

      -- Keybinding to refresh nvim-tree
      vim.keymap.set("n", "<leader>r", api.tree.reload, { desc = "Refresh NvimTree" })

      -- Keybinding to collapse all folders
      vim.keymap.set("n", "<leader>tc", api.tree.collapse_all, { desc = "Collapse all folders in NvimTree" })

      -- Keybinding to find current file in tree (Telescope integration)
      vim.keymap.set("n", "<leader>tf", function()
        api.tree.find_file(vim.api.nvim_buf_get_name(0))
      end, { desc = "Find current file in NvimTree" })
    end,
  },
}

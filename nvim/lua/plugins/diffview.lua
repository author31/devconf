return {
  "sindrets/diffview.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required dependency
  },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  keys = {
    { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
    { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    { "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
    { "<leader>df", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle Files Panel" },
  },
  config = function()
    require("diffview").setup({
      diff_binaries = false,    -- Show diffs for binaries
      enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
      git_cmd = { "git" },      -- The git executable followed by default args
      use_icons = true,         -- Requires nvim-web-devicons
      watch_index = true,       -- Update views and index on git index changes
      icons = {                 -- Only applies when use_icons is true
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },
      view = {
        -- Configure the layout and behavior of different types of views
        default = {
          -- Config for changed files, and staged files in diff views
          layout = "diff2_horizontal",
          winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
        },
        merge_tool = {
          -- Config for conflicted files in diff views during a merge or rebase
          layout = "diff3_horizontal",
          disable_diagnostics = true,   -- Temporarily disable diagnostics in conflict buffers
          winbar_info = true,           -- See ':h diffview-config-view.x.winbar_info'
        },
        file_history = {
          -- Config for changed files in file history views
          layout = "diff2_horizontal",
          winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
        },
      },
      file_panel = {
        listing_style = "tree",             -- One of 'list' or 'tree'
        tree_options = {                    -- Only applies when listing_style is 'tree'
          flatten_dirs = true,              -- Flatten dirs that only contain one single dir
          folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'
        },
        win_config = {                      -- See ':h diffview-config-win_config'
          position = "left",
          width = 35,
          win_opts = {}
        },
      },
      file_history_panel = {
        log_options = {   -- See ':h diffview-config-log_options'
          git = {
            single_file = {
              diff_merges = "combined",
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
        },
        win_config = {    -- See ':h diffview-config-win_config'
          position = "bottom",
          height = 16,
          win_opts = {}
        },
      },
      commit_log_panel = {
        win_config = {   -- See ':h diffview-config-win_config'
          win_opts = {},
        }
      },
      default_args = {    -- Default args prepended to the arg-list for the listed commands
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },
      hooks = {},         -- See ':h diffview-config-hooks'
      keymaps = {
        disable_defaults = false, -- Disable the default keymaps
        view = {
          -- The `view` bindings are active in the diff buffers, only when the current
          -- tabpage is a Diffview
          {
            "n",
            "<tab>",
            require("diffview.actions").select_next_entry,
            { desc = "Open the diff for the next file" }
          },
          {
            "n", 
            "<s-tab>",
            require("diffview.actions").select_prev_entry,
            { desc = "Open the diff for the previous file" }
          },
          {
            "n",
            "gf",
            require("diffview.actions").goto_file_edit,
            { desc = "Open the file in the previous tabpage" }
          },
          {
            "n",
            "<C-w><C-f>",
            require("diffview.actions").goto_file_split,
            { desc = "Open the file in a new split" }
          },
          {
            "n",
            "<C-w>gf",
            require("diffview.actions").goto_file_tab,
            { desc = "Open the file in a new tabpage" }
          },
          {
            "n",
            "<leader>e",
            require("diffview.actions").focus_files,
            { desc = "Bring focus to the file panel" }
          },
          {
            "n",
            "<leader>b",
            require("diffview.actions").toggle_files,
            { desc = "Toggle the file panel" }
          },
          {
            "n",
            "g<C-x>",
            require("diffview.actions").cycle_layout,
            { desc = "Cycle through available layouts" }
          },
          {
            "n",
            "[x",
            require("diffview.actions").prev_conflict,
            { desc = "In the merge-tool: jump to the previous conflict" }
          },
          {
            "n",
            "]x",
            require("diffview.actions").next_conflict,
            { desc = "In the merge-tool: jump to the next conflict" }
          },
        },
        diff1 = {
          -- Mappings in single pane diff layouts
          { "n", "g?", require("diffview.actions").help({ "view", "diff1" }), { desc = "Open the help panel" } },
        },
        diff2 = {
          -- Mappings in 2-way diff layouts
          { "n", "g?", require("diffview.actions").help({ "view", "diff2" }), { desc = "Open the help panel" } },
        },
        diff3 = {
          -- Mappings in 3-way diff layouts
          {
            { "n", "x" },
            "2do",
            require("diffview.actions").diffget("ours"),
            { desc = "Obtain the diff hunk from the OURS version of the file" }
          },
          {
            { "n", "x" },
            "3do",
            require("diffview.actions").diffget("theirs"),
            { desc = "Obtain the diff hunk from the THEIRS version of the file" }
          },
          { "n", "g?", require("diffview.actions").help({ "view", "diff3" }), { desc = "Open the help panel" } },
        },
        diff4 = {
          -- Mappings in 4-way diff layouts
          {
            { "n", "x" },
            "1do",
            require("diffview.actions").diffget("base"),
            { desc = "Obtain the diff hunk from the BASE version of the file" }
          },
          {
            { "n", "x" },
            "2do",
            require("diffview.actions").diffget("ours"),
            { desc = "Obtain the diff hunk from the OURS version of the file" }
          },
          {
            { "n", "x" },
            "3do",
            require("diffview.actions").diffget("theirs"),
            { desc = "Obtain the diff hunk from the THEIRS version of the file" }
          },
          { "n", "g?", require("diffview.actions").help({ "view", "diff4" }), { desc = "Open the help panel" } },
        },
        file_panel = {
          {
            "n",
            "j",
            require("diffview.actions").next_entry,
            { desc = "Bring the cursor to the next file entry" }
          },
          {
            "n",
            "<down>",
            require("diffview.actions").next_entry,
            { desc = "Bring the cursor to the next file entry" }
          },
          {
            "n",
            "k",
            require("diffview.actions").prev_entry,
            { desc = "Bring the cursor to the previous file entry" }
          },
          {
            "n",
            "<up>",
            require("diffview.actions").prev_entry,
            { desc = "Bring the cursor to the previous file entry" }
          },
          {
            "n",
            "<cr>",
            require("diffview.actions").select_entry,
            { desc = "Open the diff for the selected entry" }
          },
          {
            "n",
            "o",
            require("diffview.actions").select_entry,
            { desc = "Open the diff for the selected entry" }
          },
          {
            "n",
            "l",
            require("diffview.actions").select_entry,
            { desc = "Open the diff for the selected entry" }
          },
          {
            "n",
            "<2-LeftMouse>",
            require("diffview.actions").select_entry,
            { desc = "Open the diff for the selected entry" }
          },
          {
            "n",
            "-",
            require("diffview.actions").toggle_stage_entry,
            { desc = "Stage / unstage the selected entry" }
          },
          {
            "n",
            "S",
            require("diffview.actions").stage_all,
            { desc = "Stage all entries" }
          },
          {
            "n",
            "U",
            require("diffview.actions").unstage_all,
            { desc = "Unstage all entries" }
          },
          {
            "n",
            "X",
            require("diffview.actions").restore_entry,
            { desc = "Restore entry to the state on the left side" }
          },
          {
            "n",
            "L",
            require("diffview.actions").open_commit_log,
            { desc = "Open the commit log panel" }
          },
          {
            "n",
            "zo",
            require("diffview.actions").open_fold,
            { desc = "Expand fold" }
          },
          {
            "n",
            "h",
            require("diffview.actions").close_fold,
            { desc = "Collapse fold" }
          },
          {
            "n",
            "zc",
            require("diffview.actions").close_fold,
            { desc = "Collapse fold" }
          },
          {
            "n",
            "za",
            require("diffview.actions").toggle_fold,
            { desc = "Toggle fold" }
          },
          {
            "n",
            "zR",
            require("diffview.actions").open_all_folds,
            { desc = "Expand all folds" }
          },
          {
            "n",
            "zM",
            require("diffview.actions").close_all_folds,
            { desc = "Collapse all folds" }
          },
          {
            "n",
            "<c-b>",
            require("diffview.actions").scroll_view(-0.25),
            { desc = "Scroll the view up" }
          },
          {
            "n",
            "<c-f>",
            require("diffview.actions").scroll_view(0.25),
            { desc = "Scroll the view down" }
          },
          {
            "n",
            "<tab>",
            require("diffview.actions").select_next_entry,
            { desc = "Open the diff for the next file" }
          },
          {
            "n",
            "<s-tab>",
            require("diffview.actions").select_prev_entry,
            { desc = "Open the diff for the previous file" }
          },
          {
            "n",
            "gf",
            require("diffview.actions").goto_file_edit,
            { desc = "Open the file in the previous tabpage" }
          },
          {
            "n",
            "<C-w><C-f>",
            require("diffview.actions").goto_file_split,
            { desc = "Open the file in a new split" }
          },
          {
            "n",
            "<C-w>gf",
            require("diffview.actions").goto_file_tab,
            { desc = "Open the file in a new tabpage" }
          },
          {
            "n",
            "i",
            require("diffview.actions").listing_style,
            { desc = "Toggle between 'list' and 'tree' views" }
          },
          {
            "n",
            "f",
            require("diffview.actions").toggle_flatten_dirs,
            { desc = "Flatten empty subdirectories in tree listing style" }
          },
          {
            "n",
            "R",
            require("diffview.actions").refresh_files,
            { desc = "Update stats and entries in the file list" }
          },
          {
            "n",
            "<leader>e",
            require("diffview.actions").focus_files,
            { desc = "Bring focus to the file panel" }
          },
          {
            "n",
            "<leader>b",
            require("diffview.actions").toggle_files,
            { desc = "Toggle the file panel" }
          },
          {
            "n",
            "g<C-x>",
            require("diffview.actions").cycle_layout,
            { desc = "Cycle through available layouts" }
          },
          {
            "n",
            "[x",
            require("diffview.actions").prev_conflict,
            { desc = "In the merge-tool: jump to the previous conflict" }
          },
          {
            "n",
            "]x",
            require("diffview.actions").next_conflict,
            { desc = "In the merge-tool: jump to the next conflict" }
          },
          { "n", "g?", require("diffview.actions").help("file_panel"), { desc = "Open the help panel" } },
        },
        file_history_panel = {
          { "n", "g!", require("diffview.actions").options, { desc = "Open the option panel" } },
          {
            "n",
            "<C-A-d>",
            require("diffview.actions").open_in_diffview,
            { desc = "Open the entry under the cursor in a diffview" }
          },
          {
            "n",
            "y",
            require("diffview.actions").copy_hash,
            { desc = "Copy the commit hash of the entry under the cursor" }
          },
          { "n", "L", require("diffview.actions").open_commit_log, { desc = "Show commit details" } },
          { "n", "zR", require("diffview.actions").open_all_folds, { desc = "Expand all folds" } },
          { "n", "zM", require("diffview.actions").close_all_folds, { desc = "Collapse all folds" } },
          {
            "n",
            "j",
            require("diffview.actions").next_entry,
            { desc = "Bring the cursor to the next file entry" }
          },
          {
            "n",
            "<down>",
            require("diffview.actions").next_entry,
            { desc = "Bring the cursor to the next file entry" }
          },
          {
            "n",
            "k",
            require("diffview.actions").prev_entry,
            { desc = "Bring the cursor to the previous file entry" }
          },
          {
            "n",
            "<up>",
            require("diffview.actions").prev_entry,
            { desc = "Bring the cursor to the previous file entry" }
          },
          {
            "n",
            "<cr>",
            require("diffview.actions").select_entry,
            { desc = "Open the diff for the selected entry" }
          },
          {
            "n",
            "o",
            require("diffview.actions").select_entry,
            { desc = "Open the diff for the selected entry" }
          },
          {
            "n",
            "<2-LeftMouse>",
            require("diffview.actions").select_entry,
            { desc = "Open the diff for the selected entry" }
          },
          {
            "n",
            "<c-b>",
            require("diffview.actions").scroll_view(-0.25),
            { desc = "Scroll the view up" }
          },
          {
            "n",
            "<c-f>",
            require("diffview.actions").scroll_view(0.25),
            { desc = "Scroll the view down" }
          },
          {
            "n",
            "<tab>",
            require("diffview.actions").select_next_entry,
            { desc = "Open the diff for the next file" }
          },
          {
            "n",
            "<s-tab>",
            require("diffview.actions").select_prev_entry,
            { desc = "Open the diff for the previous file" }
          },
          {
            "n",
            "gf",
            require("diffview.actions").goto_file_edit,
            { desc = "Open the file in the previous tabpage" }
          },
          {
            "n",
            "<C-w><C-f>",
            require("diffview.actions").goto_file_split,
            { desc = "Open the file in a new split" }
          },
          {
            "n",
            "<C-w>gf",
            require("diffview.actions").goto_file_tab,
            { desc = "Open the file in a new tabpage" }
          },
          {
            "n",
            "<leader>e",
            require("diffview.actions").focus_files,
            { desc = "Bring focus to the file panel" }
          },
          {
            "n",
            "<leader>b",
            require("diffview.actions").toggle_files,
            { desc = "Toggle the file panel" }
          },
          {
            "n",
            "g<C-x>",
            require("diffview.actions").cycle_layout,
            { desc = "Cycle through available layouts" }
          },
          { "n", "g?", require("diffview.actions").help("file_history_panel"), { desc = "Open the help panel" } },
        },
        option_panel = {
          { "n", "<tab>", require("diffview.actions").select_entry, { desc = "Change the current option" } },
          { "n", "q", require("diffview.actions").close, { desc = "Close the panel" } },
          { "n", "g?", require("diffview.actions").help("option_panel"), { desc = "Open the help panel" } },
        },
        help_panel = {
          { "n", "q", require("diffview.actions").close, { desc = "Close help menu" } },
          { "n", "<esc>", require("diffview.actions").close, { desc = "Close help menu" } },
        },
      },
    })
  end,
}

-- lua/plugins/conform.lua
return {
  'stevearc/conform.nvim',
  -- Optionally use 'VeryLazy' if you only trigger formatting manually or via keymaps
  -- event = { "BufReadPost", "BufNewFile" },
  event = 'VeryLazy', -- Loads slightly later, potentially faster startup

  -- Define opts here using lazy.nvim convention (often placed before config)
  opts = {
    -- Configure formatters by filetype.
    formatters_by_ft = {
      python = { "ruff" },
      lua = { "stylua" },
      rust = { "rustfmt" },
      html = { "prettier" },
      -- Add other filetypes and their formatters
      ["*"] = { "trim_whitespace" }, -- Example: Apply to all filetypes
    },

    -- Optional: Configure format on save
    -- format_on_save = {
    --   timeout_ms = 500,
    --   lsp_fallback = true, -- Use LSP formatting if no conform formatter is found
    -- },

    -- Your other conform options
    formatters = {
      injected = { options = { ignore_errors = true } },
    },
    -- Consider adjusting timeouts if needed
    -- sync_timeout = 1000,
    -- async_timeout = 5000,
    lsp_format = "fallback", -- Recommended: Use LSP if conform fails or isn't configured
    -- quiet = false,
    -- log_level = vim.log.levels.INFO,
  },

  config = function(_, opts)
    -- Setup conform first
    require("conform").setup(opts)

    -- Define GLOBAL user commands (available everywhere)
    -- Conform will apply the correct formatters based on the current buffer's filetype

    vim.api.nvim_create_user_command(
      "Isort",
      function(args)
        require("conform").format({
          lsp_format = "fallback", -- Use fallback for consistency
          formatters = { "isort" }, -- Explicitly run only isort
          async = true,
           -- Pass range arguments for visual formatting, e.g., V:Isort
          range = args.range > 0 and {
             start = { args.line1, 0 },
             ["end"] = { args.line2 + 1, 0 },
          } or nil,
        })
      end,
      {
        desc = "Run isort formatter",
        range = true, -- Enable visual selection range formatting
      }
    )

    vim.api.nvim_create_user_command(
      "Format",
      function(args)
        -- Let conform decide the formatters based on the current buffer's filetype
        -- and the 'formatters_by_ft' option defined above.
        -- For Python, this will run "isort" then "ruff".
        require("conform").format({
          lsp_format = "fallback", -- Use LSP if conform fails or isn't found
          async = true,
           -- Pass range arguments for visual formatting, e.g., V:Format
          range = args.range > 0 and {
             start = { args.line1, 0 },
             ["end"] = { args.line2 + 1, 0 },
          } or nil,
        })
      end,
      {
        desc = "Format current buffer using conform.nvim",
        range = true, -- Enable visual selection range formatting
      }
    )

    -- Example Keymap (optional, place in your keymap config instead if preferred)
    -- vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    --   require("conform").format({ async = true, lsp_fallback = 'fallback' })
    -- end, { desc = "Format buffer or visual selection" })

    -- vim.keymap.set({'n'}, '<leader>i', "<cmd>Isort<cr>", { desc = "Run Isort" })

  end,
}

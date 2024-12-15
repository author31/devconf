-- lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      -- LSP keymaps
      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
      end

      -- Setup Mason and Mason-LSPConfig
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "pyright",      -- Python LSP
          "ts_ls",        -- TypeScript/JavaScript
          "eslint",       -- ESLint
          "cssls",        -- CSS
          "tailwindcss",  -- Tailwind CSS
          "clangd",       -- C/C++ LSP
        },
        automatic_installation = true,
      }

      -- Setup nvim-cmp
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        },
      }

      -- LSP capabilities for nvim-cmp integration
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require "lspconfig"

      -- Python LSP (pyright) setup
      lspconfig.pyright.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic", -- Options: "off", "basic", "strict"
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace", -- Analyze the entire workspace
            },
          },
        },
        root_dir = lspconfig.util.root_pattern(".git", "pyproject.toml", "setup.py", "requirements.txt"),
        single_file_support = true,
      }

      -- TypeScript/JavaScript LSP (ts_ls) setup
      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
        single_file_support = true,
      }

      -- ESLint setup
      lspconfig.eslint.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          workingDirectory = { mode = "auto" },
        },
        root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json"),
      }

      -- CSS LSP setup
      lspconfig.cssls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- Tailwind CSS LSP setup
      lspconfig.tailwindcss.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      -- C/C++ LSP (clangd) setup
      lspconfig.clangd.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        -- clangd requires a compilation database (like compile_commands.json)
        -- or you might need to pass include paths via settings.
        -- The root_dir pattern helps clangd find the project root.
        root_dir = lspconfig.util.root_pattern(".git", "compile_commands.json", "Makefile", "CMakeLists.txt"),
        settings = {
          -- Example settings (adjust as needed)
          -- clangd = {
          --   arguments = {
          --     "-j=8", -- Use 8 threads
          --     "--background-index", -- Index in the background
          --     "--clang-tidy", -- Enable clang-tidy integration
          --     "--header-insertion=never", -- Control header insertion behavior
          --     -- "--compile-commands-dir=/path/to/your/build/directory", -- Specify build dir if needed
          --   },
          -- },
        },
        -- single_file_support = true, -- Uncomment if you work with single C/C++ files often
      }

    end,
  },
}

-- lua/plugins/treesitter.lua
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        -- List of parsers to ensure are installed
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "html",
          "python",
        },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering a buffer
        auto_install = true,
        -- Enable syntax highlighting
        highlight = {
          enable = true,
          -- Disable for large files to improve performance
          disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then return true end
          end,
          -- Use treesitter for `=` operator indentation
          additional_vim_regex_highlighting = false,
        },
        -- Enable indentation
        indent = {
          enable = true,
        },
      }
    end,
  },
}

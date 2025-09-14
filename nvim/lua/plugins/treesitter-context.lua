return {
  "nvim-treesitter/nvim-treesitter-context",
  config = function()
    require("treesitter-context").setup {
      enable = true, -- enable by default
      max_lines = 2, -- number of context lines
      trim_scope = "outer", -- trim scope if context too large
    }
  end
}


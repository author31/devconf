return {
  "folke/tokyonight.nvim", -- Repository for the TokyoNight colorscheme
  lazy = false, -- Ensure it loads immediately (not lazily)
  priority = 1000, -- Give it high priority to load before other plugins
  config = function()
    -- Optional: Customize the setup if needed
    require("tokyonight").setup {
      style = "storm", -- Options: "storm", "moon", "night", "day"
      transparent = false,
      terminal_colors = true,
    }
    -- Set the colorscheme
    vim.cmd "colorscheme tokyonight"
  end,
}

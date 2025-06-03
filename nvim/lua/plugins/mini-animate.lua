return {
  'echasnovski/mini.animate',
  version = '*',
  config = function()
    local animate = require("mini.animate")
    vim.opt.mousescroll = "ver:1,hor:10"
    animate.setup({
      cursor = {
        timing = animate.gen_timing.linear({ duration = 100, unit = 'total' })
      },
      scroll = {
        timing = animate.gen_timing.linear({ duration = 100, unit = 'total' })
      }
    })
    end
}

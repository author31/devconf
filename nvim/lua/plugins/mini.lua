return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.indentscope').setup({
      draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none(),
      },
      symbol = '│',
      options = { try_as_border = true },
    })
  end
}


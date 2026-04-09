require("vim._core.ui2").enable()

vim.pack.add({
  "https://github.com/rachartier/tiny-cmdline.nvim",
})

vim.opt.cmdheight = 0
require("tiny-cmdline").setup({
  native_types = {},
  on_reposition = require("tiny-cmdline").adapters.blink,
})

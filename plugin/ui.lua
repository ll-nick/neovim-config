require("vim._core.ui2").enable()

vim.pack.add({
  "https://github.com/rachartier/tiny-cmdline.nvim",
})

vim.opt.cmdheight = 0
require("tiny-cmdline").setup({
  native_types = {},
  on_reposition = require("tiny-cmdline").adapters.blink,
})

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  callback = function()
    local bg = vim.api.nvim_get_hl(0, { name = "MsgArea", link = false }).bg
    local fg = vim.api.nvim_get_hl(0, { name = "FloatBorder", link = false }).fg
    vim.api.nvim_set_hl(0, "TinyCmdlineBorder", { fg = fg, bg = bg })
  end,
})

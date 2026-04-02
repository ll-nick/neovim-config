vim.pack.add({
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/stevearc/oil.nvim",
})

require("mini.icons").setup()
require("oil").setup({
  keymaps = {
    ["<C-h>"] = false,
  },
  view_options = {
    show_hidden = true,
  },
})

vim.keymap.set("n", "<C-n>", function()
  require("oil").toggle_float()
end, { desc = "Open Oil" })

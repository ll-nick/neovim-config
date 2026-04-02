vim.pack.add({
  "https://github.com/catppuccin/nvim",
  "https://github.com/f-person/auto-dark-mode.nvim",
})

require("catppuccin").setup({ auto_integrations = true })

vim.cmd.colorscheme("catppuccin-mocha")

require("auto-dark-mode").setup({
  set_dark_mode = function()
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
  set_light_mode = function()
    vim.cmd.colorscheme("catppuccin-latte")
  end,
  fallback = "dark",
})

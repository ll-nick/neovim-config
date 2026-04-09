vim.pack.add({
  "https://github.com/catppuccin/nvim",
  "https://github.com/f-person/auto-dark-mode.nvim",
})

require("catppuccin").setup({
  -- Listing integrations explicitly improves startup time over auto-detection.
  integrations = {
    blink_cmp = true,
    gitsigns = true,
    leap = true,
    mason = true,
    neotest = true,
    noice = true,
    snacks = true,
    telescope = { enabled = true },
    treesitter = true,
    which_key = true,
    dap = true,
    dap_ui = true,
  },
})

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

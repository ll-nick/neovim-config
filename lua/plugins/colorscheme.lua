return {
  "f-person/auto-dark-mode.nvim",
  dependencies = {
    "catppuccin/nvim",
    opts = {
      auto_integrations = true,
    },
    lazy = false,
    name = "catppuccin",
    priority = 1000,
  },
  config = function()
    local opts = {
      set_dark_mode = function()
        vim.cmd.colorscheme("catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.cmd.colorscheme("catppuccin-latte")
      end,
      fallback = "dark",
    }
    vim.cmd.colorscheme("catppuccin-mocha")
    require("auto-dark-mode").setup(opts)
  end,
}

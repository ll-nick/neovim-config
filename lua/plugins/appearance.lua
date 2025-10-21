return {
  {
    "f-person/auto-dark-mode.nvim",
    dependencies = {
      "catppuccin/nvim",
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
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "◗", right = "◖" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "" },
          lualine_y = { "" },
          lualine_z = { "" },
        },
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
    keys = {
      { "<Esc>", "<cmd>lua require('notify').dismiss()<cr>", "n", desc = "Dismiss notification" },
    },
    lazy = false,
  },
}

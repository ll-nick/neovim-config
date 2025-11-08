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
    "vimpostor/vim-tpipeline",
    event = "VeryLazy",
    dependencies = {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      opts = {
        options = {
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "◗", right = "◖" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", color = { bg = "NONE" } } },
          lualine_x = { "" },
          lualine_y = { "" },
          lualine_z = { "" },
        },
      },
      config = function(_, opts)
        require("lualine").setup(opts)

        -- https://github.com/vimpostor/vim-tpipeline/issues/53
        if vim.env.TMUX then
          vim.api.nvim_create_autocmd({ "FocusGained", "ColorScheme" }, {
            callback = function()
              vim.defer_fn(function()
                vim.opt.laststatus = 0
              end, 100)
            end,
          })

          vim.o.laststatus = 0
        end
      end,
      event = "VimEnter",
    },
    init = function()
      vim.g.tpipeline_autoembed = 0
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

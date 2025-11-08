return {
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
}

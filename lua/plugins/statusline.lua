local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "Recording @" .. recording_register .. " │"
  end
end

local function create_recording_autocmd()
  vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
      require("lualine").refresh({
        place = { "statusline" },
      })
    end,
  })

  vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
      -- This is going to seem really weird!
      -- Instead of just calling refresh we need to wait a moment because of the nature of
      -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
      -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
      -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
      -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
      local timer = vim.loop.new_timer()
      timer:start(
        50,
        0,
        vim.schedule_wrap(function()
          require("lualine").refresh({
            place = { "statusline" },
          })
        end)
      )
    end,
  })
end

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
        lualine_c = { {
          "filename",
          color = { bg = "NONE" },
        } },
        lualine_x = {
          {
            "macro-recording",
            fmt = show_macro_recording,
            color = "NonText",
          },
        },
        lualine_y = { "" },
        lualine_z = { "" },
      },
    },
    config = function(_, opts)
      require("lualine").setup(opts)

      create_recording_autocmd()

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

return {
  "amitds1997/remote-nvim.nvim",
  version = "*", -- Pin to GitHub releases
  dependencies = {
    "nvim-lua/plenary.nvim", -- For standard functions
    "MunifTanjim/nui.nvim", -- To build the plugin UI
    "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
  },
  config = function()
    require("remote-nvim").setup({
      client_callback = function(port, _)
        local cmd = ("tmux new-window -n 'nvim - remote' 'nvim --server localhost:%s --remote-ui'"):format(port)
        local result = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then
          vim.notify(
            ("Failed to open tmux window with exit code %s: %s"):format(vim.v.shell_error, result),
            vim.log.levels.ERROR
          )
        end
      end,
      remote = {
        copy_dirs = {
          config = {
            compression = {
              enabled = true,
              additional_opts = { "--exclude-vcs" },
            },
          },
        },
      },
    })
  end,
}

return {
  "folke/snacks.nvim",
  opts = {
    lazygit = {},
  },
  keys = {
    {
      "<leader>gg",
      function()
        Snacks.lazygit.open({ cwd = Snacks.git.get_root() })
      end,
      desc = "Open LazyGit for Current File",
    },
  },
}

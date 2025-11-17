return {
  "folke/snacks.nvim",
  opts = {},
  keys = {
    {
      "<leader>bd",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Delete Other Buffers",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit.open({ cwd = Snacks.git.get_root() })
      end,
      desc = "Open LazyGit for Current File",
    },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Open Git Repository in Browser",
    },
  },
}

return {
  "mpas/marp-nvim",
  keys = {
    {
      "<leader>mm",
      function()
        require("marp").toggle()
      end,
      desc = "Toggle Marp",
    },
  },
}

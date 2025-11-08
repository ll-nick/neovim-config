return {
  "rcarriga/nvim-notify",
  config = function()
    vim.notify = require("notify")
  end,
  keys = {
    { "<Esc>", "<cmd>lua require('notify').dismiss()<cr>", "n", desc = "Dismiss notification" },
  },
  lazy = false,
}

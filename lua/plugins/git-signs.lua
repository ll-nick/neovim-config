return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  keys = {
    { "<leader>gp", "<Cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
    { "<leader>gs", "<Cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
    { "<leader>gr", "<Cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
    { "<leader>gS", "<Cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
    { "<leader>gR", "<Cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
    { "<leader>gt", "<Cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle git blame" },
  },
  lazy = false, -- load the plugin right away for git status colored lines
}

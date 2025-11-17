return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  keys = {
    { "<leader>gp", "<Cmd>Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
    { "<leader>gs", "<Cmd>Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
    { "<leader>gr", "<Cmd>Gitsigns reset_hunk<CR>", desc = "Reset hunk" },
    { "<leader>gS", "<Cmd>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
    { "<leader>gR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
    { "<leader>gt", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle git blame" },
  },
  lazy = false, -- load the plugin right away for git status colored lines
}

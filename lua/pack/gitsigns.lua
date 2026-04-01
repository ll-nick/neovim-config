vim.pack.add({
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
})

require("gitsigns").setup()

vim.keymap.set("n", "<leader>gp", "<Cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gs", "<Cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gr", "<Cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gS", "<Cmd>Gitsigns stage_buffer<cr>", { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>gR", "<Cmd>Gitsigns reset_buffer<cr>", { desc = "Reset buffer" })
vim.keymap.set("n", "<leader>gt", "<Cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle git blame" })
vim.keymap.set("n", "<leader>gn", "<Cmd>Gitsigns next_hunk<cr>", { desc = "Go to next hunk" })

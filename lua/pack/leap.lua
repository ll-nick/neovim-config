vim.pack.add({
  "https://github.com/tpope/vim-repeat",
  "https://codeberg.org/andyg/leap.nvim.git",
})

vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })

-- Manually define defaults due to https://github.com/ggandor/leap.nvim/issues/224
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", { desc = "Leap from window" })

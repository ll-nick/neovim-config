return {
  "johnfrankmorgan/whitespace.nvim",

  config = function()
    vim.keymap.set("n", "<Leader>t", require("whitespace-nvim").trim, { desc = "Trim whitespace" })
  end,
}

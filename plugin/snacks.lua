vim.pack.add({ "https://github.com/folke/snacks.nvim" })

require("snacks").setup({
  gitbrowse = {},
  indent = {
    animate = { enabled = false },
  },
  lazygit = {},
})

vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit.open({ cwd = Snacks.git.get_root() })
end, { desc = "Open LazyGit for Current File" })
vim.keymap.set("n", "<leader>go", function()
  Snacks.gitbrowse()
end, { desc = "Open Git Repository in Browser" })

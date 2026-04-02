vim.pack.add({ "https://github.com/nat-418/boole.nvim" })

require("boole").setup({
  mappings = {
    increment = "<C-a>",
    decrement = "<C-x>",
  },
  additions = {
    { "debug", "info", "warning", "error" },
    { "assertTrue", "assertFalse" },
  },
})

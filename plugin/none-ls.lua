vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvimtools/none-ls.nvim",
})

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.clang_format,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.shfmt.with({
      extra_args = { "--indent", "4", "--case-indent", "--space-redirects" },
    }),
  },
})

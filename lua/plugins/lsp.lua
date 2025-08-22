return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
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
    end,
  },
  {
    "owallb/mason-auto-install.nvim",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
    },
    opts = {
      packages = {
        "basedpyright",
        "bash-language-server",
        "clangd",
        "lua-language-server",
        "ruff",
        "rust-analyzer",
        "stylua",
        "shfmt",
      },
    },
  },
}

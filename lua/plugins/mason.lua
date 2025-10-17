return {
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
}

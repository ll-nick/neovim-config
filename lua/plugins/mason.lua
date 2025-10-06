local host_capabilities = require("host_capabilities")

return {
  "owallb/mason-auto-install.nvim",
  dependencies = {
    { "williamboman/mason.nvim", opts = {} },
  },
  enabled = not host_capabilities.has_executable("nix"),
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

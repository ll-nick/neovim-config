vim.pack.add({ "https://github.com/owallb/mason-auto-install.nvim", "https://github.com/williamboman/mason.nvim" })

require("mason").setup()
require("mason-auto-install").setup({
  packages = {
    "basedpyright",
    "bash-language-server",
    "biome",
    "clangd",
    "css-lsp",
    "gh-actions-language-server",
    "html-lsp",
    "lua-language-server",
    "ruff",
    "rust-analyzer",
    "stylua",
    "shfmt",
    "tinymist",
    "typescript-language-server",
  },
})

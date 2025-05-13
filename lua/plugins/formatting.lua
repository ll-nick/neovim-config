return {
  { "tpope/vim-sleuth" },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason").setup()

      require("mason-null-ls").setup({
        ensure_installed = {
          "black",
          "clang_format",
          "rustfmt",
          "shfmt",
          "stylua",
        },
        automatic_installation = false,
        handlers = {},
      })

      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.shfmt.with({
            extra_args = { "--indent", "4", "--case-indent", "--space-redirects" },
          }),
        },
        -- Auto-format on save
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end,
      })
    end,
    keys = {
      { "<leader>cf", vim.lsp.buf.format, desc = "Format buffer" },
    },
  },
}

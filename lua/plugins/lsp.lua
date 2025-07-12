local lsp_format_on_save = function(client, bufnr)
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
end

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason").setup()

      local registry = require("mason-registry")

      -- These language servers will be installed and enabled
      -- Mapping: mason_package_name -> lspconfig_name
      local servers = {
        ["basedpyright"] = "basedpyright",
        ["bash-language-server"] = "bashls",
        ["clangd"] = "clangd",
        ["lua-language-server"] = "lua_ls",
        ["ruff"] = "ruff",
      }

      registry.refresh(function()
        for mason_name, lsp_name in pairs(servers) do
          -- Ensure the language server is installed
          local ok, pkg = pcall(registry.get_package, mason_name)
          if ok and not pkg:is_installed() then
            pkg:install()
            vim.notify("Installing " .. mason_name .. "...", vim.log.levels.INFO)
          end

          -- Enable the language server
          vim.lsp.enable(lsp_name)
        end
      end)

      -- Additional LSP configurations
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = lsp_format_on_save,
      })
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- These null_ls sources servers will be installed and enabled
      local null_ls_sources = {
        "clang_format",
        "shfmt",
        "stylua",
      }

      registry.refresh(function()
        for _, mason_name in ipairs(null_ls_sources) do
          -- Ensure the language server is installed
          local ok, pkg = pcall(registry.get_package, mason_name)
          if ok and not pkg:is_installed() then
            pkg:install()
            vim.notify("Installing " .. mason_name .. "...", vim.log.levels.INFO)
          end
        end
      end)

      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.shfmt.with({
            extra_args = { "--indent", "4", "--case-indent", "--space-redirects" },
          }),
          null_ls.builtins.formatting.clang_format,
          null_ls.builtins.formatting.stylua,
        },
        on_attach = lsp_format_on_save,
      })
    end,
    keys = {
      -- Diagnostics
      { "<leader>df", vim.diagnostic.open_float, desc = "Open diagnostics float" },
      { "<leader>dn", vim.diagnostic.goto_next, desc = "Go to next diagnostic" },
      { "<leader>dN", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic" },
      { "<leader>dl", vim.diagnostic.setloclist, desc = "Show diagnostics list" },

      -- LSP
      { "K", vim.lsp.buf.hover, desc = "Show hover information" },
      { "<leader>gd", vim.lsp.buf.definition, desc = "Go to definition" },
      { "<leader>gD", vim.lsp.buf.declaration, desc = "Go to declaration" },
      { "<leader>cl", vim.lsp.buf.references, desc = "List all references" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Trigger code actions" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename symbol" },

      -- LSP/clangd
      { "<leader>gh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch between source/header" },

      -- Formatting
      { "<leader>cf", vim.lsp.buf.format, desc = "Format buffer" },
    },
  },
}

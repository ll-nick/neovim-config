return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason").setup()

      local registry = require("mason-registry")

      -- These language servers will be installed and enabled
      -- Mapping: mason_package_name -> lspconfig_name
      local servers = {
        ["bash-language-server"] = "bashls",
        ["clangd"] = "clangd",
        ["jedi-language-server"] = "jedi_language_server",
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
    },
  },
}

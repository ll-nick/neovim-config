local lsp_format_on_save = function(preferred_formatter)
  return function(client, bufnr)
    if client.name ~= preferred_formatter then
      return
    end

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            async = false,
          })
        end,
      })
    end
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
      local null_ls = require("null-ls")

      -- Language-specific configuration
      local languages = {
        cpp = {
          lsps = { "clangd" },
          null_ls = {
            formatting = { "clang_format" },
          },
          format_with = "null-ls",
        },
        lua = {
          lsps = { "lua_ls" },
          null_ls = {
            formatting = { "stylua" },
          },
          format_with = "null-ls",
        },
        python = {
          lsps = { "basedpyright", "ruff" },
          format_with = "ruff",
          organize_imports_with = "ruff",
        },
        sh = {
          lsps = { "bashls" },
          null_ls = {
            formatting = { "shfmt" },
          },
          format_with = "null-ls",
        },
      }
      local mason_name_map = {
        -- LSPs
        ["lua-language-server"] = "lua_ls",
        ["bash-language-server"] = "bashls",

        -- null-ls formatters/linters
        ["clang-format"] = "clang_format",
      }

      -- Collect all Mason packages to install
      local mason_packages = {}

      -- Set up LSPs
      for _, config in pairs(languages) do
        for _, lsp in ipairs(config.lsps or {}) do
          mason_packages[lsp] = true
          vim.lsp.enable(lsp)
          local lsp_config = {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = lsp_format_on_save(config.format_with),
          }

          -- Example: custom override for clangd
          if lsp == "clangd" then
            lsp_config.cmd = { "clangd", "--background-index", "--clang-tidy", "--offset-encoding=utf-16" }
          end

          -- Example: lua_ls diagnostics globals
          if lsp == "lua_ls" then
            lsp_config.settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            }
          end

          vim.lsp.config(lsp, lsp_config)
        end
      end

      -- Set up null-ls sources
      local null_ls_sources = {}

      for _, config in pairs(languages) do
        local null_cfg = config.null_ls or {}

        for _, formatter in ipairs(null_cfg.formatting or {}) do
          mason_packages[formatter] = true
          table.insert(null_ls_sources, null_ls.builtins.formatting[formatter])

          if formatter == "shfmt" then
            table.insert(
              null_ls_sources,
              null_ls.builtins.formatting.shfmt.with({
                extra_args = { "--indent", "4", "--case-indent", "--space-redirects" },
              })
            )
          end
        end

        for _, diagnostic in ipairs(null_cfg.diagnostics or {}) do
          mason_packages[diagnostic] = true
          table.insert(null_ls_sources, null_ls.builtins.diagnostics[diagnostic])
        end

        for _, action in ipairs(null_cfg.code_actions or {}) do
          mason_packages[action] = true
          table.insert(null_ls_sources, null_ls.builtins.code_actions[action])
        end
      end

      null_ls.setup({
        sources = null_ls_sources,
        on_attach = lsp_format_on_save("null-ls"),
      })

      -- Fix package names to match what Mason expects
      local normalized_packages = {}

      for name in pairs(mason_packages) do
        local mason_name = mason_name_map[name] or name
        normalized_packages[mason_name] = true
      end

      -- Ensure Mason installs everything
      registry.refresh(function()
        for name in pairs(normalized_packages) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then
            pkg:install()
            vim.notify("Installing " .. name .. "...", vim.log.levels.INFO)
          end
        end
      end)
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

      -- Clangd-specific
      { "<leader>gh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch between source/header" },

      -- Formatting
      {
        "<leader>cf",
        function()
          vim.lsp.buf.format({ async = true })
        end,
        desc = "Format buffer",
      },
    },
  },
}

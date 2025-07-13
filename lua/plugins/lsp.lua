-- Language-specific configuration
local languages = {
  cpp = {
    -- A list of LSP servers with optional configurations
    lsps = {
      {
        name = "clangd",
        config = {
          cmd = { "clangd", "--background-index", "--clang-tidy", "--offset-encoding=utf-16" },
        },
      },
    },
    -- null-ls sources for formatting, diagnostics, etc.
    null_ls = {
      -- A list of null-ls sources for formatting with optional configurations
      formatting = { { name = "clang_format" } },
    },
    -- The preferred formatter to use for this language, either an LSP or null-ls
    format_with = "null-ls",
  },

  lua = {
    lsps = {
      {
        name = "lua_ls",
        config = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
      },
    },
    null_ls = {
      formatting = { { name = "stylua" } },
    },
    format_with = "null-ls",
  },

  python = {
    lsps = { { name = "basedpyright" }, { name = "ruff" } },
    format_with = "ruff",
  },

  sh = {
    lsps = {
      { name = "bashls" },
    },
    null_ls = {
      formatting = {
        {
          name = "shfmt",
          config = {
            extra_args = { "--indent", "4", "--case-indent", "--space-redirects" },
          },
        },
      },
    },
    format_with = "null-ls",
  },
}

-- Returns a function that sets up LSP formatting on save if the client matches the preferred formatter
-- Otherwise, the returned function does nothing
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

          -- Ruff proved import organization via the linter rather than the formatter.
          -- Call the corresponding code action here to get auto sort on save behavior analogous to e.g. clang-format.
          -- See https://github.com/astral-sh/ruff/issues/8926 for reference
          if client.name == "ruff" then
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports" } },
              apply = true,
              buffer = bufnr,
            })
          end
        end,
      })
    end
  end
end

-- Returns the preferred formatter for the current buffer based on its filetype
local function get_preferred_formatter(bufnr)
  local ft = vim.bo[bufnr or 0].filetype
  local config = languages[ft] or {}
  return config and config.format_with
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

      -- Mason package names don't always match LSP/null-ls names,
      -- so we need a mapping to ensure we install the correct packages.
      local mason_name_map = {
        -- LSPs
        ["lua-language-server"] = "lua_ls",
        ["bash-language-server"] = "bashls",

        -- null-ls formatters/linters
        ["clang-format"] = "clang_format",
      }

      -- A table of packages to ensure are installed
      local mason_packages = {}

      -- Set up LSPs
      for _, config in pairs(languages) do
        for _, lsp_entry in ipairs(config.lsps or {}) do
          local lsp_name = lsp_entry.name
          local opts = lsp_entry.config or {}

          mason_packages[lsp_name] = true
          vim.lsp.enable(lsp_name)

          local lsp_config = vim.tbl_deep_extend("force", {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = lsp_format_on_save(config.format_with),
          }, opts)

          vim.lsp.config(lsp_name, lsp_config)
        end
      end

      -- Set up null-ls sources
      local null_ls_sources = {}

      for _, config in pairs(languages) do
        local null_cfg = config.null_ls or {}

        for _, source in ipairs(null_cfg.formatting or {}) do
          mason_packages[source.name] = true
          local builtin = null_ls.builtins.formatting[source.name]
          if source.config then
            table.insert(null_ls_sources, builtin.with(source.config))
          else
            table.insert(null_ls_sources, builtin)
          end
        end

        for _, source in ipairs(null_cfg.diagnostics or {}) do
          mason_packages[source.name] = true
          local builtin = null_ls.builtins.diagnostics[source.name]
          if source.config then
            table.insert(null_ls_sources, builtin.with(source.config))
          else
            table.insert(null_ls_sources, builtin)
          end
        end

        for _, source in ipairs(null_cfg.code_actions or {}) do
          mason_packages[source.name] = true
          local builtin = null_ls.builtins.code_actions[source.name]
          if source.config then
            table.insert(null_ls_sources, builtin.with(source.config))
          else
            table.insert(null_ls_sources, builtin)
          end
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
          local bufnr = vim.api.nvim_get_current_buf()
          local preferred = get_preferred_formatter(bufnr)
          vim.lsp.buf.format({
            async = true,
            filter = function(client)
              return client.name == preferred
            end,
          })
        end,
        desc = "Format buffer",
      },
    },
  },
}

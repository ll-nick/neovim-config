local function format_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  -- basedpyright could format Python files, but we want to use Ruff for that
  local filter_client = function(client)
    return client.name ~= "basedpyright"
  end

  vim.lsp.buf.format({
    bufnr = bufnr,
    async = false,
    filter = filter_client,
  })

  -- Special Python handling: organize imports via Ruff command
  if ft == "python" then
    -- Ruff proved import organization via the linter rather than the formatter.
    -- Call the corresponding code action here to get auto sort on save behavior analogous to e.g. clang-format.
    -- See https://github.com/astral-sh/ruff/issues/8926 for reference
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd.LspRuffOrganizeImports()
    end)
  end
end

-- Auto-format on save
local function enable_lsp_format_on_save()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
    callback = function(args)
      format_buffer(args.buf)
    end,
  })
end

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason").setup()
      local registry = require("mason-registry")
      local null_ls = require("null-ls")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lsps = {
        "basedpyright",
        "bashls",
        "clangd",
        "lua_ls",
        "ruff",
        "rust_analyzer",
      }

      for _, lsp in ipairs(lsps) do
        vim.lsp.config(lsp, {
          capabilities = capabilities,
        })
        vim.lsp.enable(lsp)
      end

      null_ls.setup({
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.shfmt.with({
          extra_args = { "--indent", "4", "--case-indent", "--space-redirects" },
        }),
      })

      local mason_packages = {
        "basedpyright",
        "bash-language-server",
        "clangd",
        "lua-language-server",
        "ruff",
        "rust-analyzer",
        "stylua",
        "shfmt",
      }

      -- Ensure Mason installs everything
      registry.refresh(function()
        for _, name in ipairs(mason_packages) do
          local ok, pkg = pcall(registry.get_package, name)
          if ok and not pkg:is_installed() then
            pkg:install()
            vim.notify("Installing " .. name .. "...", vim.log.levels.INFO)
          end
        end
      end)

      enable_lsp_format_on_save()
    end,

    keys = {
      -- Diagnostics
      { "<leader>df", vim.diagnostic.open_float,           desc = "Open diagnostics float" },
      { "<leader>dn", vim.diagnostic.goto_next,            desc = "Go to next diagnostic" },
      { "<leader>dN", vim.diagnostic.goto_prev,            desc = "Go to previous diagnostic" },
      { "<leader>dl", vim.diagnostic.setloclist,           desc = "Show diagnostics list" },

      -- LSP
      { "K",          vim.lsp.buf.hover,                   desc = "Show hover information" },
      { "<leader>gd", vim.lsp.buf.definition,              desc = "Go to definition" },
      { "<leader>gD", vim.lsp.buf.declaration,             desc = "Go to declaration" },
      { "<leader>cl", vim.lsp.buf.references,              desc = "List all references" },
      { "<leader>ca", vim.lsp.buf.code_action,             desc = "Trigger code actions" },
      { "<leader>cr", vim.lsp.buf.rename,                  desc = "Rename symbol" },

      -- Clangd-specific
      { "<leader>gh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch between source/header" },

      -- Formatting
      {
        "<leader>cf",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          format_buffer(bufnr)
        end,
        desc = "Format buffer",
      },
    },
  },
}

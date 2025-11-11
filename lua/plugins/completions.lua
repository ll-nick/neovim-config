return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
      },
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<M-y>",
          accept_line = "<M-$>",
          accept_word = "<M-w>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-e>",
        },
      },
      filetypes = {
        yaml = true,
        markdown = true,
        gitcommit = true,
        gitrebase = true,
        cvs = true,
        ["."] = true,
      },
    },
  },
  {
    "folke/which-key.nvim",
    dependencies = {
      { "echasnovski/mini.icons", opts = {}, version = false },
    },
    event = "VeryLazy",
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local lspkind = require("lspkind")

      local ls = require("luasnip")
      ls.config.set_config({
        history = true,
      })

      local cmp = require("cmp")
      require("luasnip.loaders.from_vscode").lazy_load()

      vim.keymap.set({ "i", "s" }, "<C-k>", function()
        ls.jump(1)
      end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-j>", function()
        ls.jump(-1)
      end, { silent = true })

      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
        snippet = {
          expand = function(args)
            ls.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          format = lspkind.cmp_format({}),
        },
      })

      -- Inject cmp capabilities into all LSP servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end,
  },
}

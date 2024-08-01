return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			ensure_installed = {
				"clangd",
				"lua_ls",
				"pyright",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.clangd.setup({
				capabilities = capabilities,
				cmd = { "clangd", "--background-index", "--clang-tidy" },
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
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
			{ "<F2>", vim.lsp.buf.rename, desc = "Rename symbol" },

			-- LSP/clangd
			{ "<leader>gh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch between source/header" },
		},
	},
}

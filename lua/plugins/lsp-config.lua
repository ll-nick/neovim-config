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
			auto_install = true,
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
			})
			lspconfig.tsserver.setup({
				capabilities = capabilities,
			})
			lspconfig.html.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
			vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, { desc = "List all references" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Trigger code actions" })
		end,
	},
}

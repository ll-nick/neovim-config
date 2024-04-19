return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
				pickers = {
					find_files = { hidden = true },
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Grep across project files" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find open buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help" })

			require("telescope").load_extension("ui-select")
		end,
	},
}

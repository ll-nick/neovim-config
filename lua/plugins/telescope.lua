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
				defaults = {
					file_ignore_patterns = {
						".git/",
						"build/",
						"build_debug/",
						"devel/",
						"devel_debug/",
						".cache/",
						".catkin_tools/",
						".mrt_tools",
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
				pickers = {
					find_files = { hidden = true },
				},
			})

			require("telescope").load_extension("ui-select")
		end,

		keys = {
			{ "<leader>ff", ":Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>fg", ":Telescope live_grep<CR>", desc = "Grep across project files" },
			{ "<leader>fb", ":Telescope buffers<CR>", desc = "Find open buffers" },
			{ "<leader>fh", ":Telescope help_tags<CR>", desc = "Telescope help" },
		},
	},
}

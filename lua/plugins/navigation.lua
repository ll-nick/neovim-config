return {
	-- Neotree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function() end,
		keys = {
			{ "<C-n>", ":Neotree filesystem reveal left<CR>", "Reveal Neotree filesystem left" },
			{ "<leader>bf", ":Neotree buffers reveal float<CR>", desc = "Reveal Neotree buffer float" },
		},
	},
	-- Telescope
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
	-- Vim-tmux-navigator
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
}

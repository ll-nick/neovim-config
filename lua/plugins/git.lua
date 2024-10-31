return {
	{
		"tpope/vim-fugitive",
		dependencies = {
			"tpope/vim-rhubarb",
			{
				"shumphrey/fugitive-gitlab.vim",
				config = function()
					vim.g.fugitive_gitlab_domains = { "https://gitlab.mrt.kit.edu" }
				end,
			},
		},
		keys = {
			{ "<leader>go", ":GBrowse<CR>", mode = { "n", "v" }, desc = "Open on remote" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
		keys = {
			{ "<leader>gp", ":Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
			{ "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage hunk" },
			{ "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Reset hunk" },
			{ "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
			{ "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
			{ "<leader>gt", ":Gitsigns toggle_current_line_blame<CR>", desc = "Toggle git blame" },
		},
		lazy = false, -- load the plugin right away for git status colored lines
	},
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit" },
		},
	},
}

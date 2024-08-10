return {
	-- Harpoon
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
		end,
		keys = {
			{
				"<leader>hh",
				function()
					local harpoon = require("harpoon")
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "Toggle Harpoon menu",
			},
			{
				"<leader>ha",
				function()
					local harpoon = require("harpoon")
					harpoon:list():add()
				end,
				desc = "Add file to Harpoon",
			},
			{
				"<leader>hp",
				function()
					local harpoon = require("harpoon")
					harpoon:list():prev()
				end,
				desc = "Select previous Harpoon item",
			},
			{
				"<leader>hn",
				function()
					local harpoon = require("harpoon")
					harpoon:list():next()
				end,
				desc = "Select next Harpoon item",
			},
			{
				"<leader>h1",
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(1)
				end,
				desc = "Select Harpoon item 1",
			},
			{
				"<leader>h2",
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(2)
				end,
				desc = "Select Harpoon item 2",
			},
			{
				"<leader>h3",
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(3)
				end,
				desc = "Select Harpoon item 3",
			},
			{
				"<leader>h4",
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(4)
				end,
				desc = "Select Harpoon item 4",
			},
			{
				"<leader>h5",
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(5)
				end,
				desc = "Select Harpoon item 5",
			},
			{
				"<leader>h6",
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(6)
				end,
				desc = "Select Harpoon item 6",
			},
			{
				"<leader>h7",
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(7)
				end,
				desc = "Select Harpoon item 7",
			},
			{
				"<leader>h8",
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(8)
				end,
				desc = "Select Harpoon item 8",
			},
			{
				"<leader>h9",
				function()
					local harpoon = require("harpoon")
					harpoon:list():select(9)
				end,
				desc = "Select Harpoon item 9",
			},
		},
	},
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
			function Telescope_live_grep_git_dir()
				local git_dir =
					vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
				git_dir = string.gsub(git_dir, "\n", "") -- remove newline character from git_dir
				local opts = {
					cwd = git_dir,
				}
				require("telescope.builtin").live_grep(opts)
			end

			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						".git/",
						"build/",
						"build_debug/",
						"devel/",
						"devel_debug/",
						"logs/",
						"logs_debug/",
						".cache/",
						".catkin_tools/",
						".mrt_tools/",
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
			{ "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy find in current buffer" },
			{ "<leader>fb", ":Telescope buffers<CR>", desc = "Find open buffers" },
			{ "<leader>ff", ":Telescope git_files<CR>", desc = "Find file in git project" },
			{ "<leader>fF", ":Telescope find_files<CR>", desc = "Find files" },
			{ "<leader>fg", ":lua Telescope_live_grep_git_dir()<CR>", desc = "Grep in the git directory" },
			{ "<leader>fG", ":Telescope live_grep<CR>", desc = "Grep across all files" },
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

return {
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
}

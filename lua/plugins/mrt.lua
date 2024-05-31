return {
	"ll-nick/mrt.nvim",

	config = function()
		require("mrt").setup({
			pane_handler = "tmux",
		})
	end,
	keys = {
		{ "<leader>bw", "<cmd>MrtBuildWorkspace<cr>", desc = "Build workspace" },
		{ "<leader>bp", "<cmd>MrtBuildCurrentPackage<cr>", desc = "Build current package" },
		{ "<leader>bt", "<cmd>MrtBuildCurrentPackageTests<cr>", desc = "Build tests for current package" },
		{ "<leader>sp", "<cmd>MrtSwitchCatkinProfile<cr>", desc = "Switch catkin profile" },
	},
}

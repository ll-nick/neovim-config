return {
	"johnfrankmorgan/whitespace.nvim",

	keys = {
		{
			"<Leader>tw",
			function()
				require("whitespace-nvim").trim()
			end,
			desc = "Trim whitespace",
		},
	},
}

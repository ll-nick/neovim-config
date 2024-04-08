return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		require("mason").setup()
		require("mason-nvim-dap").setup({
			ensure_installed = {
				"codelldb",
				"python",
			},
			handlers = {},
		})

		local dap = require("dap")
		local dapui = require("dapui")
		dapui.setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<Leader>dt", ":DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<F9>", ":DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })

		vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>", { desc = "Continue debugging session" })
		vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { desc = "Continue debugging session" })

		vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>", { desc = "Terminate debugging session" })
		vim.keymap.set("n", "<S-F5>", ":DapTerminate<CR>", { desc = "Terminate debugging session" })

		vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>", { desc = "Step over the current line" })
		vim.keymap.set("n", "<F10>", ":DapStepOver<CR>", { desc = "Step over the current line" })

		vim.keymap.set("n", "<Leader>di", ":DapStepInto<CR>", { desc = "Step over the current line" })
		vim.keymap.set("n", "<F11>", ":DapStepInto<CR>", { desc = "Step over the current line" })

		vim.keymap.set("n", "<Leader>dO", ":DapStepOut<CR>", { desc = "Step over the current line" })
		vim.keymap.set("n", "<S-F11>", ":DapStepOut<CR>", { desc = "Step over the current line" })
	end,
}

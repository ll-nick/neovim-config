return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
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
    local dap_ui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")
    dap_ui.setup()
    dap_virtual_text.setup()

    dap.listeners.before.attach.dapui_config = function()
      dap_ui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dap_ui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dap_ui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dap_ui.close()
    end
  end,
  keys = {
    { "<Leader>db", ":DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },
    { "<F9>", ":DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },

    { "<Leader>dc", ":DapContinue<CR>", desc = "Continue debugging session" },
    { "<F5>", ":DapContinue<CR>", desc = "Continue debugging session" },

    { "<Leader>dx", ":DapTerminate<CR>", desc = "Terminate debugging session" },
    { "<S-F5>", ":DapTerminate<CR>", desc = "Terminate debugging session" },

    { "<Leader>do", ":DapStepOver<CR>", desc = "Step over the current line" },
    { "<F10>", ":DapStepOver<CR>", desc = "Step over the current line" },

    { "<Leader>di", ":DapStepInto<CR>", desc = "Step into the current line" },
    { "<F11>", ":DapStepInto<CR>", desc = "Step into the current line" },

    { "<Leader>dO", ":DapStepOut<CR>", desc = "Step out of the current line" },
    { "<S-F11>", ":DapStepOut<CR>", desc = "Step out of the current line" },
  },
}

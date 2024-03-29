return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    require("dapui").setup()
    local dap, dapui = require("dap"), require("dapui")

    -- Requires gdb 14.1 or above for dap support
    dap.adapters.gdb = {
      type = "executable",
      command = "gdb",
      args = { "-i", "dap" },
    }

    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtBeginningOfMainSubprogram = false,
      },
    }

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
    vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>", { desc = "Continue debugging session" })
    vim.keymap.set("n", "<Leader>dx", ":DapTerminate<CR>", { desc = "Terminate debugging session" })
    vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>", { desc = "Step over the current line" })
  end,
}

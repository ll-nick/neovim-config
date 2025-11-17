local function set_conditional_breakpoint()
  vim.ui.input({ prompt = "Enter condition for breakpoint: " }, function(condition)
    if condition then
      require("dap").set_breakpoint(condition)
    end
  end)
end

local function set_hit_breakpoint()
  vim.ui.input({ prompt = "Enter hit count for breakpoint: " }, function(hit_condition)
    if hit_condition then
      require("dap").set_breakpoint(nil, hit_condition)
    end
  end)
end

local function set_log_breakpoint()
  vim.ui.input({ prompt = "Enter log message for breakpoint: " }, function(log_message)
    if log_message then
      require("dap").set_breakpoint(nil, nil, log_message)
    end
  end)
end

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
    dap_ui.setup({
      layouts = {
        {
          -- Remove all the default elements on the left as I use them via floats
          elements = {},
          position = "left",
          size = 40,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.4,
            },
            {
              id = "console",
              size = 0.6,
            },
          },
          position = "bottom",
          size = 10,
        },
      },
    })
    dap_virtual_text.setup()

    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "●", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    vim.fn.sign_define(
      "DapBreakpointRejected",
      { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
    )
    vim.fn.sign_define(
      "DapLogPoint",
      { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
    )
    vim.fn.sign_define(
      "DapStopped",
      { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
    )

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
    {
      "<F1>",
      "<Cmd>DapToggleBreakpoint<CR>",
      desc = "Toggle breakpoint",
    },
    {
      "<F2>",
      function()
        set_conditional_breakpoint()
      end,
      desc = "Set conditional breakpoint",
    },
    {
      "<F3>",
      function()
        set_hit_breakpoint()
      end,
      desc = "Set hit breakpoint",
    },
    {
      "<F4>",
      function()
        set_log_breakpoint()
      end,
      desc = "Set log point",
    },
    {
      "<F5>",
      "<Cmd>DapContinue<CR>",
      desc = "Continue debugging session",
    },
    {
      "<F6>",
      "<Cmd>DapTerminate<CR>",
      desc = "Terminate debugging session",
    },
    {
      "<F7>",
      function()
        require("dapui").toggle()
      end,
      desc = "Toggle the DAP UI",
    },
    {
      "<F10>",
      "<Cmd>DapStepOver<CR>",
      desc = "Step over the current line",
    },
    {
      "<F11>",
      "<Cmd>DapStepInto<CR>",
      desc = "Step into the current line",
    },
    {
      "<F12>",
      "<Cmd>DapStepOut<CR>",
      desc = "Step out of the current line",
    },

    {
      "<leader>db",
      function()
        require("dapui").float_element("breakpoints", { enter = true, position = "center" })
      end,
      desc = "Show breakpoints",
    },
    {
      "<leader>ds",
      function()
        require("dapui").float_element("stacks", { enter = true, position = "center" })
      end,
      desc = "Show stacks",
    },
    {
      "<leader>dv",
      function()
        require("dapui").float_element("scopes", { enter = true, position = "center" })
      end,
      desc = "Show variables",
    },
    {
      "<leader>dw",
      function()
        require("dapui").float_element("watches", { enter = true, position = "center" })
      end,
      desc = "Show watches",
    },
  },
}

local function is_test_file(file)
  local test_extensions = { ".cpp", ".cppm", ".cc", ".cxx", ".c++" }
  local is_in_test_dir = file:match("test/")

  if is_in_test_dir then
    for _, ext in ipairs(test_extensions) do
      if file:sub(-#ext) == ext then
        return true
      end
    end
  end

  return false
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "alfaix/neotest-gtest",
  },

  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-gtest").setup({
          is_test_file = is_test_file,
        }),
        require("neotest-python"),
      },
    })
  end,
  keys = {
    {
      "<leader>tr",
      function()
        require("neotest").run.run({ cwd = vim.fn.expand("%:p:h") })
      end,
      desc = "Run nearest test",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
    },
    {
      "<leader>tf",
      function()
        require("neotest").run.run(vim.fn.expand("%"), { cwd = vim.fn.expand("%:p:h") })
      end,
      desc = "Run tests in file",
    },
    {
      "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap", cwd = vim.fn.expand("%:p:h") })
      end,
      desc = "Debug nearest test",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle test summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle output panel",
    },
    {
      "<leader>tn",
      function()
        require("neotest").jump.next({ status = "failed" })
      end,
      desc = "Jump to next failed test",
    },
    {
      "<leader>tp",
      function()
        require("neotest").jump.prev({ status = "failed" })
      end,
      desc = "Jump to previous failed test",
    },
    {
      "<leader>tc",
      "<Cmd>ConfigureGtest<CR>",
      desc = "Configure Google Test",
    },
  },
}

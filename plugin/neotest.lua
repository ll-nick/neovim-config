vim.pack.add({
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/antoinemadec/FixCursorHold.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-neotest/neotest-python",
  "https://github.com/alfaix/neotest-gtest",
  "https://github.com/nvim-neotest/neotest",
})

local function is_test_file(file)
  local test_extensions = { ".cpp", ".cppm", ".cc", ".cxx", ".c++" }
  if file:match("test/") then
    for _, ext in ipairs(test_extensions) do
      if file:sub(-#ext) == ext then
        return true
      end
    end
  end
  return false
end

require("nvim-treesitter").install({ "c", "cpp" }):wait()

require("neotest").setup({
  adapters = {
    require("neotest-gtest").setup({ is_test_file = is_test_file }),
    require("neotest-python"),
  },
})

vim.keymap.set("n", "<leader>tr", function()
  require("neotest").run.run({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tl", function()
  require("neotest").run.run_last()
end, { desc = "Run last test" })
vim.keymap.set("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"), { cwd = vim.fn.expand("%:p:h") })
end, { desc = "Run tests in file" })
vim.keymap.set("n", "<leader>td", function()
  require("neotest").run.run({ strategy = "dap", cwd = vim.fn.expand("%:p:h") })
end, { desc = "Debug nearest test" })
vim.keymap.set("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Toggle test summary" })
vim.keymap.set("n", "<leader>to", function()
  require("neotest").output_panel.toggle()
end, { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>tn", function()
  require("neotest").jump.next({ status = "failed" })
end, { desc = "Jump to next failed test" })
vim.keymap.set("n", "<leader>tp", function()
  require("neotest").jump.prev({ status = "failed" })
end, { desc = "Jump to previous failed test" })
vim.keymap.set("n", "<leader>tc", "<Cmd>ConfigureGtest<CR>", { desc = "Configure Google Test" })

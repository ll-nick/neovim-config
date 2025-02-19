return {
  "folke/snacks.nvim",
  opts = {
    lazygit = {},
  },
  config = function()
    local function open_lazygit_for_current_file()
      local git_root = vim.fn.systemlist("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --show-toplevel")[1]
      if vim.v.shell_error ~= 0 then
        print("Not inside a Git repository")
        return
      end

      -- Open lazygit
      require("snacks.lazygit").open({ cwd = git_root })
    end

    vim.api.nvim_create_user_command("LazyGitCurrentFile", open_lazygit_for_current_file, {})
  end,
  keys = {
    { "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit" },
  },
}

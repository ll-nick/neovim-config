return {
  "mbbill/undotree",
  config = function()
    -- Persistent undo configuration
    if vim.fn.has("persistent_undo") == 1 then
      local target_path = vim.fn.expand("~/.config/nvim/.undodir")

      if vim.fn.isdirectory(target_path) == 0 then
        vim.fn.mkdir(target_path, "p")
      end

      vim.opt.undodir = target_path
      vim.opt.undofile = true
    end
  end,
  keys = {
    { "<leader>ut", ":UndotreeToggle<CR>:UndotreeFocus<CR>", "Toggle undotree" },
  },
  lazy = false,
}

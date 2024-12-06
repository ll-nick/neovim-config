return {
  "rmagatti/auto-session",
  config = function()
    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
    require("auto-session").setup({
      pre_save_cmds = { "Neotree close" },
    })
  end,
}

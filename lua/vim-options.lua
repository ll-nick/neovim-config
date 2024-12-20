vim.g.mapleader = " "

-- Set indentation
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- Set line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable spell checking
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- Highlight yanked text
vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })")

-- Do not auto-comment on newline
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "r", "o" })
  end,
})

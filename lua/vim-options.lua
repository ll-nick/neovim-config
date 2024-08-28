vim.g.mapleader = " "

-- Set indentation
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- Set line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Allow pasting without overwriting the yank register
vim.keymap.set("v", "<leader>p", [["_dP]])

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Highlight yanked text
vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })")

-- Save as sudo
vim.api.nvim_set_keymap("c", "w!!", "w !sudo tee > /dev/null %", { noremap = true, silent = true })

-- Enable spell checking
vim.opt.spelllang = "en_us"
vim.opt.spell = true

-- Create new split
vim.keymap.set("n", "<leader>sh", ":split<CR>", {})
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", {})

-- Zoom in/out by moving pane to new tab
vim.keymap.set("n", "<leader>zi", ":tab split<CR>", {})
vim.keymap.set("n", "<leader>zo", ":tab close<CR>", {})

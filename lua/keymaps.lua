-- Allow pasting without overwriting the yank register
vim.keymap.set("v", "<leader>p", [["_dP]])

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Save as sudo
vim.keymap.set("c", "w!!", "w !sudo tee > /dev/null %", { silent = false })

-- Create new split
vim.keymap.set("n", "<leader>sh", ":split<CR>", {})
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", {})

-- Zoom in/out by moving pane to new tab
vim.keymap.set("n", "<leader>zi", ":tab split<CR>", {})
vim.keymap.set("n", "<leader>zo", ":tab close<CR>", {})

-- Center of half page scroll_docs
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

local set = vim.keymap.set
-- Allow pasting without overwriting the yank register
set("v", "<leader>p", [["_dP]])

-- Yank to system clipboard
set({ "n", "v" }, "<leader>y", [["+y]])
set("n", "<leader>Y", [["+Y]])

-- Save as sudo
set("c", "w!!", "w !sudo tee > /dev/null %", { silent = false })

-- Create new split
set("n", "<leader>sh", ":split<CR>", {})
set("n", "<leader>sv", ":vsplit<CR>", {})

-- Zoom in/out by moving pane to new tab
set("n", "<leader>zi", ":tab split<CR>", {})
set("n", "<leader>zo", ":tab close<CR>", {})

-- Center of half page scroll_docs
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")

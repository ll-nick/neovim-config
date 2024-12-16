local set = vim.keymap.set

-- Execute lua code
set("n", "<leader>xx", "<cmd>.lua<CR>", { desc = "Execute the current line" })
set("n", "<leader>xf", "<cmd>source %<CR>", { desc = "Execute the current file" })

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

-- Resize splits
set("n", "<M-,>", "<c-w>5<")
set("n", "<M-.>", "<c-w>5>")
set("n", "<M-u>", "<C-w>+")
set("n", "<M-d>", "<C-w>-")

-- Zoom in/out by moving pane to new tab
set("n", "<leader>zi", ":tab split<CR>", {})
set("n", "<leader>zo", ":tab close<CR>", {})

-- Center of half page scroll_docs
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u>", "<C-u>zz")

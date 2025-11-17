local set = vim.keymap.set

-- Execute lua code
set("n", "<leader>xx", "<Cmd>.lua<CR>", { desc = "Execute the current line as Lua code" })
set("n", "<leader>xf", "<Cmd>source %<CR>", { desc = "Execute the current file as Lua code" })

-- Yank to system clipboard
set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
set("n", "<leader>Y", [["+Y]], { desc = "Yank the current line to system clipboard" })

-- Save as sudo
set("c", "w!!", "w !sudo tee > /dev/null %", { silent = false, desc = "Save the file with sudo permissions" })

-- Resize splits
set("n", "<M-,>", "<c-w>5<", { desc = "Decrease split width" })
set("n", "<M-.>", "<c-w>5>", { desc = "Increase split width" })
set("n", "<M-u>", "<C-w>+", { desc = "Increase split height" })
set("n", "<M-d>", "<C-w>-", { desc = "Decrease split height" })

-- Zoom in/out by moving pane to new tab
set("n", "<leader>zi", "<Cmd>tab split<CR>", { desc = "Zoom in by moving the current pane to a new tab" })
set("n", "<leader>zo", "<Cmd>tab close<CR>", { desc = "Zoom out by closing the current tab" })

-- Center after half-page scrolling
set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half a page and center the view" })
set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half a page and center the view" })

-- Navigate quickfix list
set("n", "<leader>qq", function()
  if vim.fn.winnr("$") == 1 then
    vim.cmd("copen")
  else
    vim.cmd("cclose")
  end
end, { desc = "Toggle quickfix list" })
set("n", "<M-j>", "<Cmd>cnext<CR>", { desc = "Go to the next quickfix entry" })
set("n", "<M-k>", "<Cmd>cprev<CR>", { desc = "Go to the previous quickfix entry" })

-- Replace character by linebreak, i.e. the opposite of `J`
set("n", "gJ", "s<CR><Esc>", { desc = "Replace character by linebreak" })

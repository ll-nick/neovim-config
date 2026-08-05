local set = vim.keymap.set

-- Execute lua code
set("n", "<leader>xx", "<Cmd>.lua<CR>", { desc = "Execute the current line as Lua code" })
set("n", "<leader>xf", "<Cmd>source %<CR>", { desc = "Execute the current file as Lua code" })

-- Yank to system clipboard
set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
set("n", "<leader>Y", [["+Y]], { desc = "Yank the current line to system clipboard" })

-- Share file name/path via system clipboard, e.g. for linking files in chat.
-- In visual mode, the selected line range is appended (`path:start-end`),
-- matching the `file_path:line_number` convention used to cite code.
local function yank_file_reference(expand_pattern)
  return function()
    local reference = vim.fn.expand(expand_pattern)
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
      local start_line = vim.fn.line("v")
      local end_line = vim.fn.line(".")
      if start_line > end_line then
        start_line, end_line = end_line, start_line
      end
      local range = start_line == end_line and tostring(start_line) or (start_line .. "-" .. end_line)
      reference = reference .. ":" .. range
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
    end
    vim.fn.setreg("+", reference)
    vim.notify("Copied to clipboard: " .. reference)
  end
end

set({ "n", "v" }, "<leader>sn", yank_file_reference("%:t"), { desc = "Share file name via system clipboard" })
set({ "n", "v" }, "<leader>sr", yank_file_reference("%:."), { desc = "Share relative file path via system clipboard" })
set({ "n", "v" }, "<leader>sa", yank_file_reference("%:p"), { desc = "Share absolute file path via system clipboard" })

-- Resize splits
set("n", "<M-,>", "<c-w>5<", { desc = "Decrease split width" })
set("n", "<M-.>", "<c-w>5>", { desc = "Increase split width" })
set("n", "<M-u>", "<C-w>+", { desc = "Increase split height" })
set("n", "<M-d>", "<C-w>-", { desc = "Decrease split height" })

-- New tab
set("n", "<C-w>t", "<Cmd>tabnew<CR>", { desc = "Open a new tab" })

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

-- Restart Neovim
set("n", "<leader>rs", "<Cmd>restart<CR>", { desc = "Restart Neovim" })

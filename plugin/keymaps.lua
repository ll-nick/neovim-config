local set = vim.keymap.set

-- Execute lua code
set("n", "<leader>xx", "<Cmd>.lua<CR>", { desc = "Execute the current line as Lua code" })
set("n", "<leader>xf", "<Cmd>source %<CR>", { desc = "Execute the current file as Lua code" })

-- Yank to system clipboard
set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
set("n", "<leader>Y", [["+Y]], { desc = "Yank the current line to system clipboard" })

-- Share a file path + line range via system clipboard.g. for linking files in chat.
local function make_file_reference_operator(expand_pattern)
  return function()
    local path = vim.fn.expand(expand_pattern)
    local start_line = vim.fn.line("'[")
    local end_line = vim.fn.line("']")
    local range = start_line == end_line and tostring(start_line) or (start_line .. "-" .. end_line)
    local reference = path .. ":" .. range
    vim.fn.setreg("+", reference)
    vim.notify("Copied to clipboard: " .. reference)
  end
end

_G.NvimShareFileReference = {
  relative = make_file_reference_operator("%:."),
  absolute = make_file_reference_operator("%:p"),
}

set({ "n", "x" }, "<leader>s", function()
  vim.o.operatorfunc = "v:lua.NvimShareFileReference.relative"
  return "g@"
end, { expr = true, desc = "Share relative file path + line range over a motion" })

set({ "n", "x" }, "<leader>S", function()
  vim.o.operatorfunc = "v:lua.NvimShareFileReference.absolute"
  return "g@"
end, { expr = true, desc = "Share absolute file path + line range over a motion" })

-- Bare path only, no line number, e.g. for referencing a whole file.
local function share_bare_path(expand_pattern)
  return function()
    local path = vim.fn.expand(expand_pattern)
    vim.fn.setreg("+", path)
    vim.notify("Copied to clipboard: " .. path)
  end
end

set("n", "<leader>ss", share_bare_path("%:."), { desc = "Share relative file path via system clipboard" })
set("n", "<leader>SS", share_bare_path("%:p"), { desc = "Share absolute file path via system clipboard" })

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

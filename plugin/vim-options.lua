-- Set line numbers
vim.wo.number = true
vim.wo.relativenumber = true

-- Hide cmd line
vim.opt.cmdheight = 0

-- Add border around floating windows
vim.opt.winborder = "rounded"

-- Wrapped lines keep indentation
vim.opt.breakindent = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Prevent jumping due to sign column turning on and off
vim.opt.signcolumn = "yes"

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- Enable spell checking
vim.opt.spelllang = "en_us"
vim.opt.spell = true

vim.diagnostic.config({ virtual_text = true })

-- Highlight yanked text
vim.cmd("au TextYankPost * silent! lua vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })")

-- Always use OSC 52 as clipboard provider
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- Do not auto-comment on newline
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "r", "o" })
  end,
})

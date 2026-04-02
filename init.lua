vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim.pack plugins
for _, f in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lua/pack/*.lua", false, true)) do
  dofile(f)
end

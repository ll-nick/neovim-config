vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim.pack plugins
for _, f in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lua/pack/*.lua", false, true)) do
  dofile(f)
end

-- Collect vim.pack plugin paths so lazy preserves them when resetting rtp
local pack_paths = vim.tbl_map(function(p)
  return p.path
end, vim.pack.get())

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = {
    colorscheme = { "catppuccin-mocha" },
  },
  performance = {
    rtp = {
      -- Preserve vim.pack plugin paths so lazy doesn't evict them
      paths = pack_paths,
    },
  },
})

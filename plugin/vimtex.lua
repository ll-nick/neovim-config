local host_capabilities = require("host_capabilities")

if not host_capabilities.has_executable("latexmk") then
  return
end

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_mappings_prefix = "<leader>l"
vim.g.vimtex_quickfix_mode = 0

vim.pack.add({ "https://github.com/lervag/vimtex" })

local host_capabilities = require("host_capabilities")

return {
  "lervag/vimtex",
  enabled = host_capabilities.has_display and host_capabilities.has_executable("latexmk"),
  lazy = false,
  init = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_mappings_prefix = "<leader>l"
    vim.g.vimtex_quickfix_mode = 0
  end,
}

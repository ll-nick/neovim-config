local host_capabilities = require("host_capabilities")

return {
  "chomosuke/typst-preview.nvim",
  enabled = host_capabilities.has_display and host_capabilities.has_executable("typst"),
  ft = "typst",
  version = "1.*",
  opts = {},
  keys = {
    { "<leader>tp", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst preview" },
  },
}

local host_capabilities = require("host_capabilities")

return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  enabled = host_capabilities.has_display,
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  keys = {
    { "<leader>mp", "<Cmd>MarkdownPreview<CR>", desc = "Preview Markdown" },
  },
}

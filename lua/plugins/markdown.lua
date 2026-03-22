return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  init = function()
    vim.g.mkdp_open_to_the_world = 1
  end,
  keys = {
    { "<leader>mp", "<Cmd>MarkdownPreview<CR>", desc = "Preview Markdown" },
  },
}

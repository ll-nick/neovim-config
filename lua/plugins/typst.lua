local host_capabilities = require("host_capabilities")

return {
  "chomosuke/typst-preview.nvim",
  enabled = host_capabilities.has_display and host_capabilities.has_executable("typst"),
  ft = "typst",
  version = "1.*",
  opts = {
    dependencies_bin = { ["tinymist"] = "tinymist" },
  },
  config = function(_, opts)
    require("typst-preview").setup(opts)
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      callback = function(args)
        if not vim.api.nvim_buf_is_valid(args.buf) then
          return
        end
        if vim.bo[args.buf].filetype ~= "typst" then
          return
        end
        vim.schedule(function()
          vim.diagnostic.setqflist({ open = false })
        end)
      end,
    })
  end,
  keys = {
    { "<leader>pp", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst preview" },
    { "<leader>ps", "<cmd>TypstPreviewSyncCursor<cr>", desc = "Sync preview to cursor" },
  },
}

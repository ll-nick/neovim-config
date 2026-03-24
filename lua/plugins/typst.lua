local host_capabilities = require("host_capabilities")

return {
  "chomosuke/typst-preview.nvim",
  enabled = host_capabilities.has_display and host_capabilities.has_executable("typst"),
  ft = "typst",
  version = "1.*",
  opts = {
    dependencies_bin = { ["tinymist"] = "tinymist" },
    get_main_file = function(path)
      return require("utils.typst").get_main_typ(path) or path
    end,
  },
  config = function(_, opts)
    require("typst-preview").setup(opts)

    vim.api.nvim_create_user_command("TypstSetMain", function()
      local path = vim.api.nvim_buf_get_name(0)
      if path == "" or not path:match("%.typ$") then
        vim.notify("Current buffer is not a .typ file", vim.log.levels.ERROR)
        return
      end
      require("utils.typst").set_main_typ(path)
      for _, client in ipairs(vim.lsp.get_clients({ name = "tinymist" })) do
        client:exec_cmd({ title = "pin", command = "tinymist.pinMain", arguments = { path } }, {})
      end
      vim.notify("Typst main set to: " .. vim.fn.fnamemodify(path, ":t"))
    end, { desc = "Set current buffer as Typst main entry point" })

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
    { "<leader>pp", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle preview", ft = "typst" },
    { "<leader>ps", "<cmd>TypstPreviewSyncCursor<cr>", desc = "Sync preview to cursor" },
    { "<leader>pf", "<cmd>TypstSetMain<cr>", desc = "Set file as Typst main", ft = "typst" },
  },
}

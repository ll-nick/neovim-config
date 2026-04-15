local host_capabilities = require("host_capabilities")

if not host_capabilities.has_executable("typst") then
  return
end

vim.pack.add({
  { src = "https://github.com/chomosuke/typst-preview.nvim", version = vim.version.range("1") },
})

require("typst-preview").setup({
  dependencies_bin = { ["tinymist"] = "tinymist" },
  get_main_file = function(path)
    return require("utils.typst").get_main_typ(path) or path
  end,
})

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

vim.keymap.set("n", "<leader>pp", "<cmd>TypstPreviewToggle<cr>", { desc = "Toggle preview" })
vim.keymap.set("n", "<leader>ps", "<cmd>TypstPreviewSyncCursor<cr>", { desc = "Sync preview to cursor" })
vim.keymap.set("n", "<leader>pf", "<cmd>TypstSetMain<cr>", { desc = "Set file as Typst main" })

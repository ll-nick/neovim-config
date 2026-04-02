-- Run the node.js install script after install/update
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "markdown-preview.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("markdown-preview.nvim")
      end
      vim.fn["mkdp#util#install"]()
    end
  end,
})

vim.g.mkdp_open_to_the_world = 1

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })

vim.keymap.set("n", "<leader>mp", "<Cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle markdown preview" })

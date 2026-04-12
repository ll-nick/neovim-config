-- PackChanged fires from within a UV callback. vim.schedule escapes it.
-- Headless installs/updates are handled by the post-install hook below.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "markdown-preview.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
      vim.schedule(function()
        if not ev.data.active then
          vim.cmd.packadd("markdown-preview.nvim")
        end
        vim.fn["mkdp#util#install"]()
      end)
    end
  end,
})

require("post-install").register("markdown-preview.nvim", function(path)
  vim.system({ "yarn", "install" }, { cwd = vim.fs.joinpath(path, "app") }):wait()
end)

vim.g.mkdp_open_to_the_world = 1

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })

vim.keymap.set("n", "<leader>mp", "<Cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle markdown preview" })

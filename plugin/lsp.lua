local function format_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  -- Filter out clients we don’t want formatting from
  local filter_client = function(client)
    -- basedpyright can format Python but we use Ruff
    -- lua_ls can format Lua but we use stylua
    return client.name ~= "basedpyright" and client.name ~= "lua_ls"
  end

  vim.lsp.buf.format({
    bufnr = bufnr,
    async = false,
    filter = filter_client,
  })

  if ft == "python" then
    -- Ruff proved import organization via the linter rather than the formatter.
    -- Call the corresponding code action here to get auto sort on save behavior analogous to e.g. clang-format.
    -- See https://github.com/astral-sh/ruff/issues/8926 for reference
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd.LspRuffOrganizeImports()
    end)
  end
end

local function enable_format_on_save()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
    callback = function(args)
      format_buffer(args.buf)
    end,
  })
end

local servers = {
  "basedpyright",
  "bashls",
  "clangd",
  "lua_ls",
  "ruff",
  "rust_analyzer",
}

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
end

enable_format_on_save()

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    -- Diagnostics
    map("n", "<leader>df", vim.diagnostic.open_float, "Diagnostics float")
    map("n", "<leader>dn", vim.diagnostic.goto_next, "Next diagnostic")
    map("n", "<leader>dN", vim.diagnostic.goto_prev, "Prev diagnostic")
    map("n", "<leader>dl", vim.diagnostic.setloclist, "Diagnostics list")

    -- LSP core
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "<leader>gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "<leader>cl", vim.lsp.buf.references, "List references")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")

    -- Clangd-specific
    map("n", "<leader>gh", "<cmd>ClangdSwitchSourceHeader<cr>", "Switch header/source")

    -- Manual formatting
    map("n", "<leader>cf", function()
      format_buffer(buf)
    end, "Format buffer")
  end,
})

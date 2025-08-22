local function enable_all_servers()
  local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
  local lsp_servers = {}

  if vim.fn.isdirectory(lsp_dir) == 1 then
    for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
      if file:match("%.lua$") and file ~= "init.lua" then
        local server_name = file:gsub("%.lua$", "")
        table.insert(lsp_servers, server_name)
      end
    end
  end

  vim.lsp.enable(lsp_servers)
end

local function format_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  if ft == "python" then
    -- Ruff proved import organization via the linter rather than the formatter.
    -- Call the corresponding code action here to get auto sort on save behavior analogous to e.g. clang-format.
    -- See https://github.com/astral-sh/ruff/issues/8926 for reference
    vim.cmd("LspRuffOrganizeImportsPseudoSync")
  end

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
end

local function enable_format_on_save()
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
    callback = function(args)
      format_buffer(args.buf)
    end,
  })
end

enable_all_servers()
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
    map("n", "<leader>dn", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic")
    map("n", "<leader>dN", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Prev diagnostic")
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

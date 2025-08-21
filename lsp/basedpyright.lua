---@brief
---
--- https://detachhead.github.io/basedpyright
---
--- `basedpyright`, a static type checker and language server for python

local function set_python_path(path)
  local clients = vim.lsp.get_clients({
    bufnr = vim.api.nvim_get_current_buf(),
    name = "basedpyright",
  })
  for _, client in ipairs(clients) do
    if client.settings then
      client.settings.python = vim.tbl_deep_extend("force", client.settings.python or {}, { pythonPath = path })
    else
      client.config.settings = vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
    end
    client:notify("workspace/didChangeConfiguration", { settings = nil })
  end
end

local function get_site_packages()
  local handle = io.popen("python3 -c 'import site, json; print(json.dumps(site.getsitepackages()))'")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result then
      -- Decode JSON string to Lua table
      local ok, paths = pcall(vim.fn.json_decode, result)
      if ok and type(paths) == "table" then
        return paths
      end
    end
  end
  return {}
end

---@type vim.lsp.Config
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        extraPaths = get_site_packages(),
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspPyrightSetPythonPath", set_python_path, {
      desc = "Reconfigure basedpyright with the provided python path",
      nargs = 1,
      complete = "file",
    })
  end,
}

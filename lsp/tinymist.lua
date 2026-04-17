---@brief
---
--- https://github.com/Myriad-Dreamin/tinymist
--- An integrated language service for Typst [taɪpst]. You can also call it "微霭" [wēi ǎi] in Chinese.
---
--- Currently some of Tinymist's workspace commands are supported, namely:
--- `LspTinymistExportSvg`, `LspTinymistExportPng`, `LspTinymistExportPdf`,
--- `LspTinymistExportMarkdown`, `LspTinymistExportText`, `LspTinymistExportQuery`,
--- `LspTinymistExportAnsiHighlight`, `LspTinymistGetServerInfo`,
--- `LspTinymistGetDocumentTrace`, `LspTinymistGetWorkspaceLabels`,
--- `LspTinymistGetDocumentMetrics`, and `LspTinymistPinMain`.

---@param command_name string
---@param client vim.lsp.Client
---@param bufnr integer
---@return fun():nil run_tinymist_command, string cmd_name, string cmd_desc
local function create_tinymist_command(command_name, client, bufnr)
  local export_type = command_name:match("tinymist%.export(%w+)")
  local info_type = command_name:match("tinymist%.(%w+)")
  local cmd_display = export_type or info_type:gsub("^get", "Get"):gsub("^pin", "Pin")
  ---@return nil
  local function run_tinymist_command()
    local arguments = { vim.api.nvim_buf_get_name(bufnr) }
    local title_str = export_type and ("Export " .. cmd_display) or cmd_display
    ---@type lsp.Handler
    local function handler(err, res)
      if err then
        return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
      end
      vim.notify(vim.inspect(res), vim.log.levels.INFO)
    end
    return client:exec_cmd({
      title = title_str,
      command = command_name,
      arguments = arguments,
    }, { bufnr = bufnr }, handler)
  end
  -- Construct a readable command name/desc
  local cmd_name = export_type and ("TinymistExport" .. cmd_display) or ("Tinymist" .. cmd_display) ---@type string
  local cmd_desc = export_type and ("Export to " .. cmd_display) or ("Get " .. cmd_display) ---@type string
  return run_tinymist_command, cmd_name, cmd_desc
end

-- Pin the main .typ entry point for the given buffer if tinymist is attached.
---@param bufnr integer
local function pin_main_typ(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "tinymist" })
  if #clients == 0 then
    return
  end
  local buf_path = vim.api.nvim_buf_get_name(bufnr)
  if buf_path == "" then
    return
  end
  local main_typ = require("utils.typst").get_main_typ(buf_path)
  if not main_typ then
    return
  end
  clients[1]:exec_cmd({
    title = "pin",
    command = "tinymist.pinMain",
    arguments = { main_typ },
  }, { bufnr = bufnr })
end

-- Register the BufEnter autocmd once so it re-pins when switching
-- between .typ buffers within the same project.
local auto_pin_registered = false
local function setup_auto_pin()
  if auto_pin_registered then
    return
  end
  auto_pin_registered = true
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*.typ",
    callback = function(args)
      pin_main_typ(args.buf)
    end,
  })
end

---@type vim.lsp.Config
return {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  root_markers = { ".git" },
  settings = {
    formatterMode = "typstyle",
    formatterProseWrap = false,
    formatterPrintWidth = 90,
    formatterIndentSize = 4,
  },
  on_attach = function(client, bufnr)
    for _, command in ipairs({
      "tinymist.exportSvg",
      "tinymist.exportPng",
      "tinymist.exportPdf",
      -- 'tinymist.exportHtml', -- Use typst 0.13
      "tinymist.exportMarkdown",
      "tinymist.exportText",
      "tinymist.exportQuery",
      "tinymist.exportAnsiHighlight",
      "tinymist.getServerInfo",
      "tinymist.getDocumentTrace",
      "tinymist.getWorkspaceLabels",
      "tinymist.getDocumentMetrics",
      "tinymist.pinMain",
    }) do
      local cmd_func, cmd_name, cmd_desc = create_tinymist_command(command, client, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, "Lsp" .. cmd_name, cmd_func, { nargs = 0, desc = cmd_desc })
    end

    setup_auto_pin()
    pin_main_typ(bufnr)
  end,
}

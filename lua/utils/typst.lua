local M = {}

-- Session-level manual override for the main .typ entry point.
local override = nil

-- Walk up from start_dir looking for main.typ.
---@param start_dir string
---@return string|nil
local function find_main_typ(start_dir)
  local dir = start_dir
  while true do
    local candidate = dir .. "/main.typ"
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      return nil
    end
    dir = parent
  end
end

-- Get the main .typ file: returns the manual override if set, otherwise
-- walks up the directory tree from buf_path to find main.typ.
---@param buf_path string absolute path of the current buffer
---@return string|nil
function M.get_main_typ(buf_path)
  if override then
    return override
  end
  if buf_path == "" then
    return nil
  end
  return find_main_typ(vim.fn.fnamemodify(buf_path, ":h"))
end

-- Manually set the main .typ entry point for this session.
---@param path string
function M.set_main_typ(path)
  override = path
end

-- Clear the manual override, reverting to automatic detection.
function M.clear_main_typ()
  override = nil
end

return M

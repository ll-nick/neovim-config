local M = {}

--- Check if MRT tools are installed by verifying the presence of /opt/mrtsoftware.
---
--- @return boolean: true if the MRT tools directory exists
local function check_mrt_tools()
  local stat = vim.loop.fs_stat("/opt/mrtsoftware")
  return stat ~= nil and stat.type == "directory"
end

--- Whether MRT tools are installed (evaluated once at load time).
--- @type boolean
M.has_mrt_tools = check_mrt_tools()

--- Check if a given executable is available in the system PATH.
---
--- @param bin string: name of the executable (e.g., "git", "clangd")
--- @return boolean: true if the executable is found in PATH
function M.has_executable(bin)
  return vim.fn.executable(bin) == 1
end

return M

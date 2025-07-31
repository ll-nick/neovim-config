local M = {}

--- Check if the host system has a graphical display (Wayland or X11).
---
--- This excludes SSH sessions with X11 forwarding by only accepting
--- local X11 sessions (e.g., DISPLAY=":0") or Wayland sessions.
---
--- @return boolean: true if a local display is available
local function check_display()
  local display = os.getenv("DISPLAY")
  local wayland = os.getenv("WAYLAND_DISPLAY")

  local is_local_display = display ~= nil and display:match("^:%d+$") ~= nil
  local is_wayland = wayland ~= nil and #wayland > 0

  return is_local_display or is_wayland
end

--- Check if MRT tools are installed by verifying the presence of /opt/mrtsoftware.
---
--- @return boolean: true if the MRT tools directory exists
local function check_mrt_tools()
  local stat = vim.loop.fs_stat("/opt/mrtsoftware")
  return stat ~= nil and stat.type == "directory"
end

--- Whether the host has a local display available (evaluated once at load time).
--- @type boolean
M.has_display = check_display()

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

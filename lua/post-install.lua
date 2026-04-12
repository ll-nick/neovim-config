local M = {}
local _hooks = {}

--- Register a post-install hook for a plugin.
--- Called at plugin file load time; the hook itself only runs when M.run() is
--- explicitly invoked. Explicitly also works in headless mode.
---@param plugin_name string Plugin name as used in vim.pack.add()
---@param fn fun(path: string) Function receiving the plugin's install path
function M.register(plugin_name, fn)
  _hooks[#_hooks + 1] = { name = plugin_name, fn = fn }
end

--- Run all registered post-install hooks and quit.
--- Intended for headless use: nvim --headless -c "lua require('post-install').run()"
function M.run()
  for _, hook in ipairs(_hooks) do
    local data = vim.pack.get({ hook.name }, { info = false })
    if data[1] then
      local ok, err = pcall(hook.fn, data[1].path)
      if not ok then
        vim.notify("post-install [" .. hook.name .. "]: " .. tostring(err), vim.log.levels.ERROR)
      end
    end
  end
  vim.cmd.qa()
end

return M

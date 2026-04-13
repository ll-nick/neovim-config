-- User commands for common vim.pack interactions.

-- Provide plugin name completion for commands that take plugin names as arguments.
local function complete_plugin(arglead)
  return vim
    .iter(vim.pack.get())
    :map(function(x)
      return x.spec.name
    end)
    :filter(function(name)
      return name:find(arglead, 1, true) ~= nil
    end)
    :totable()
end

-- Expand "owner/repo" shorthand to a full GitHub URL.
local function expand_spec(spec)
  if type(spec) == "string" and not spec:match("^https?://") and not spec:match("^git@") then
    return "https://github.com/" .. spec
  end
  return spec
end

-- :Pack  — show current plugin state (no download)
vim.api.nvim_create_user_command("Pack", function()
  vim.pack.update(nil, { offline = true })
end, {
  desc = "Show current vim.pack plugin state",
})

-- :PackAdd <spec ...>  — install and load plugin(s)
-- Accepts full URLs or "owner/repo" shorthand (resolved to GitHub).
vim.api.nvim_create_user_command("PackAdd", function(opts)
  local specs = vim.tbl_map(expand_spec, opts.fargs)
  vim.pack.add(specs)
end, {
  nargs = "+",
  desc = "Install and load vim.pack plugin(s)",
})

-- :PackUpdate [name ...]  — update all or named plugins
-- :PackUpdate!            — skip confirmation buffer
vim.api.nvim_create_user_command("PackUpdate", function(opts)
  local names = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(names, { force = opts.bang })
end, {
  nargs = "*",
  bang = true,
  complete = complete_plugin,
  desc = "Update vim.pack plugins",
})

-- :PackSync [name ...]  — sync to lockfile revisions
-- :PackSync!            — skip confirmation buffer
vim.api.nvim_create_user_command("PackSync", function(opts)
  local names = #opts.fargs > 0 and opts.fargs or nil
  vim.pack.update(names, { force = opts.bang, target = "lockfile" })
end, {
  nargs = "*",
  bang = true,
  complete = complete_plugin,
  desc = "Sync vim.pack plugins to lockfile revisions",
})

-- :PackDelete <name ...>  — remove plugin(s) from disk and lockfile
-- :PackDelete!            — allow deleting active plugins
vim.api.nvim_create_user_command("PackDelete", function(opts)
  vim.pack.del(opts.fargs, { force = opts.bang })
end, {
  nargs = "+",
  bang = true,
  complete = complete_plugin,
  desc = "Delete vim.pack plugin(s) from disk",
})

-- :PackClean   — remove orphaned plugins (on disk but not vim.pack.add()'d)
-- :PackClean!  — force-remove even active ones
vim.api.nvim_create_user_command("PackClean", function(opts)
  local orphans = vim
    .iter(vim.pack.get())
    :filter(function(x)
      return not x.active
    end)
    :map(function(x)
      return x.spec.name
    end)
    :totable()

  if #orphans == 0 then
    vim.notify("vim.pack: nothing to clean", vim.log.levels.INFO)
    return
  end

  vim.notify(
    "vim.pack: removing " .. #orphans .. " orphaned plugin(s): " .. table.concat(orphans, ", "),
    vim.log.levels.INFO
  )
  vim.pack.del(orphans, { force = opts.bang })
end, {
  bang = true,
  desc = "Remove orphaned (inactive) vim.pack plugins",
})

local host_capabilities = require("host_capabilities")

return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    local sources = {
      null_ls.builtins.formatting.clang_format,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.shfmt.with({
        extra_args = { "--indent", "4", "--case-indent", "--space-redirects" },
      }),
    }

    if host_capabilities.has_executable("nix") then
      table.insert(sources, null_ls.builtins.formatting.alejandra)
    end

    null_ls.setup({ sources = sources })
  end,
}

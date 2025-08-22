---@brief
---
--- https://github.com/astral-sh/ruff
---
--- A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code formatter, written in Rust. It can be installed via `pip`.
---
--- ```sh
--- pip install ruff
--- ```
---
--- **Available in Ruff `v0.4.5` in beta and stabilized in Ruff `v0.5.3`.**
---
--- This is the new built-in language server written in Rust. It supports the same feature set as `ruff-lsp`, but with superior performance and no installation required. Note that the `ruff-lsp` server will continue to be maintained until further notice.
---
--- Server settings can be provided via:
---
--- ```lua
--- vim.lsp.config('ruff', {
---   init_options = {
---     settings = {
---       -- Server settings should go here
---     }
---   }
--- })
--- ```
---
--- Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.

---@type vim.lsp.Config
return {
  cmd = { "ruff", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  settings = {},
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspRuffOrganizeImports", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
        buffer = bufnr,
      })
    end, {
      desc = "Organize Imports",
    })

    vim.api.nvim_buf_create_user_command(bufnr, "LspRuffOrganizeImportsPseudoSync", function()
      local done = false

      vim.lsp.buf.code_action({
        ---@diagnostic disable-next-line: missing-fields
        context = { only = { "source.organizeImports" } },
        apply = true,
        buffer = bufnr,
        on_result = function()
          done = true
        end,
      })

      -- Wait for the LSP edits to apply (max 1000 ms)
      -- Slightly hacky but there is no synchronous version of code_action
      -- See https://github.com/neovim/neovim/issues/31176
      vim.wait(1000, function()
        return done
      end, 10)
    end, {
      desc = "Organize Imports (Pseudo Sync)",
    })
  end,
}

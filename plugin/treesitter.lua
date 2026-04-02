-- Run :TSUpdate after install/update
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
})

require("nvim-treesitter").install({
  -- core
  "vim",
  "vimdoc",
  -- web
  "javascript",
  "typescript",
  "html",
  "css",
  -- shell
  "bash",
  "nu",
  -- data / config
  "json",
  "yaml",
  "toml",
  -- docs
  "markdown",
  "markdown_inline",
  "latex",
  "typst",
  -- programming languages
  "c",
  "cpp",
  "lua",
  "python",
  "rust",
  -- misc
  "query",
  "regex",
  "diff",
  "gitcommit",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("nvim-treesitter-textobjects").setup({
  select = { lookahead = true },
  move = { set_jumps = true },
})

local sel = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

-- select
local sel_maps = {
  ["a="] = { "@assignment.outer", "Select outer assignment" },
  ["i="] = { "@assignment.inner", "Select inner assignment" },
  ["l="] = { "@assignment.lhs", "Select assignment LHS" },
  ["r="] = { "@assignment.rhs", "Select assignment RHS" },
  ["aa"] = { "@parameter.outer", "Select outer parameter" },
  ["ia"] = { "@parameter.inner", "Select inner parameter" },
  ["ai"] = { "@conditional.outer", "Select outer conditional" },
  ["ii"] = { "@conditional.inner", "Select inner conditional" },
  ["al"] = { "@loop.outer", "Select outer loop" },
  ["il"] = { "@loop.inner", "Select inner loop" },
  ["af"] = { "@call.outer", "Select outer call" },
  ["if"] = { "@call.inner", "Select inner call" },
  ["am"] = { "@function.outer", "Select outer function" },
  ["im"] = { "@function.inner", "Select inner function" },
  ["ac"] = { "@class.outer", "Select outer class" },
  ["ic"] = { "@class.inner", "Select inner class" },
}
for key, val in pairs(sel_maps) do
  vim.keymap.set({ "x", "o" }, key, function()
    sel.select_textobject(val[1], "textobjects")
  end, { desc = val[2] })
end

-- move
local move_maps = {
  ["]f"] = { move.goto_next_start, "@call.outer", "Next call start" },
  ["]m"] = { move.goto_next_start, "@function.outer", "Next function start" },
  ["]c"] = { move.goto_next_start, "@class.outer", "Next class start" },
  ["]i"] = { move.goto_next_start, "@conditional.outer", "Next conditional start" },
  ["]l"] = { move.goto_next_start, "@loop.outer", "Next loop start" },
  ["]s"] = { move.goto_next_start, "@scope", "Next scope", "locals" },
  ["]F"] = { move.goto_next_end, "@call.outer", "Next call end" },
  ["]M"] = { move.goto_next_end, "@function.outer", "Next function end" },
  ["]C"] = { move.goto_next_end, "@class.outer", "Next class end" },
  ["]I"] = { move.goto_next_end, "@conditional.outer", "Next conditional end" },
  ["]L"] = { move.goto_next_end, "@loop.outer", "Next loop end" },
  ["[f"] = { move.goto_previous_start, "@call.outer", "Prev call start" },
  ["[m"] = { move.goto_previous_start, "@function.outer", "Prev function start" },
  ["[c"] = { move.goto_previous_start, "@class.outer", "Prev class start" },
  ["[i"] = { move.goto_previous_start, "@conditional.outer", "Prev conditional start" },
  ["[l"] = { move.goto_previous_start, "@loop.outer", "Prev loop start" },
  ["[F"] = { move.goto_previous_end, "@call.outer", "Prev call end" },
  ["[M"] = { move.goto_previous_end, "@function.outer", "Prev function end" },
  ["[C"] = { move.goto_previous_end, "@class.outer", "Prev class end" },
  ["[I"] = { move.goto_previous_end, "@conditional.outer", "Prev conditional end" },
  ["[L"] = { move.goto_previous_end, "@loop.outer", "Prev loop end" },
}
for key, val in pairs(move_maps) do
  vim.keymap.set("n", key, function()
    val[1](val[2], val[4] or "textobjects")
  end, { desc = val[3] })
end

-- swap
vim.keymap.set("n", "<leader>na", function()
  swap.swap_next("@parameter.inner")
end, { desc = "Swap next parameter" })
vim.keymap.set("n", "<leader>nm", function()
  swap.swap_next("@function.outer")
end, { desc = "Swap next function" })
vim.keymap.set("n", "<leader>pa", function()
  swap.swap_previous("@parameter.inner")
end, { desc = "Swap prev parameter" })
vim.keymap.set("n", "<leader>pm", function()
  swap.swap_previous("@function.outer")
end, { desc = "Swap prev function" })

-- repeatable f/t
local rep = require("nvim-treesitter-textobjects.repeatable_move")
vim.keymap.set({ "n", "x", "o" }, ";", rep.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", rep.repeat_last_move_opposite)
vim.keymap.set({ "n", "x", "o" }, "f", rep.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", rep.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", rep.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", rep.builtin_T_expr, { expr = true })

-- PackChanged fires from within a UV callback (async install/update coroutine),
-- so vim.system():wait() → vim.wait() would raise E5560. Use vim.schedule to
-- escape that context for interactive updates.
-- Headless installs/updates are handled by the post-install hook below.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    if ev.data.spec.name == "telescope-fzf-native.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
      local path = ev.data.path
      vim.schedule(function()
        vim.system({ "make" }, { cwd = path }):wait()
      end)
    end
  end,
})

require("post-install").register("telescope-fzf-native.nvim", function(path)
  vim.system({ "make" }, { cwd = path }):wait()
end)

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
})

local telescope = require("telescope")

local function get_git_dir()
  local output = vim.fn.systemlist(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
  if vim.v.shell_error ~= 0 or #output == 0 then
    return nil
  end
  return output[1]
end

local function find_files_in_repository()
  require("telescope.builtin").find_files({ cwd = get_git_dir() or vim.fn.getcwd() })
end

local function live_grep_in_repository()
  require("telescope.builtin").live_grep({ cwd = get_git_dir() or vim.fn.getcwd() })
end

telescope.setup({
  -- Disable treesitter-based previewer since it seems to be broken right now
  defaults = {
    preview = { treesitter = false },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
  pickers = {
    find_files = { find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" } },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")

vim.keymap.set(
  "n",
  "<leader>/",
  "<Cmd>Telescope current_buffer_fuzzy_find<CR>",
  { desc = "Fuzzy find in current buffer" }
)
vim.keymap.set("n", "<leader>fb", "<Cmd>Telescope buffers<CR>", { desc = "Find open buffers" })
vim.keymap.set("n", "<leader>ff", find_files_in_repository, { desc = "Find file in current git repository" })
vim.keymap.set("n", "<leader>fF", function()
  require("telescope.builtin").find_files({ no_ignore = true })
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", live_grep_in_repository, { desc = "Grep in the current git repository" })
vim.keymap.set("n", "<leader>fG", "<Cmd>Telescope live_grep<CR>", { desc = "Grep across all files" })
vim.keymap.set("n", "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", { desc = "Find document symbols" })
vim.keymap.set("n", "<leader>fh", "<Cmd>Telescope help_tags<CR>", { desc = "Telescope help" })
vim.keymap.set("n", "<leader>fr", "<Cmd>Telescope resume<CR>", { desc = "Resume last Telescope picker" })

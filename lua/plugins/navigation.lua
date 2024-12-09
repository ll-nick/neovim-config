return {
  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
    end,
    keys = (function()
      local bindings = {
        {
          "<leader>hh",
          function()
            local harpoon = require("harpoon")
            harpoon.ui:toggle_quick_menu(harpoon:list())
          end,
          desc = "Toggle Harpoon menu",
        },
        {
          "<leader>ha",
          function()
            local harpoon = require("harpoon")
            harpoon:list():add()
          end,
          desc = "Add file to Harpoon",
        },
        {
          "<leader>hp",
          function()
            local harpoon = require("harpoon")
            harpoon:list():prev()
          end,
          desc = "Select previous Harpoon item",
        },
        {
          "<leader>hn",
          function()
            local harpoon = require("harpoon")
            harpoon:list():next()
          end,
          desc = "Select next Harpoon item",
        },
      }

      for i = 1, 9 do
        table.insert(bindings, {
          string.format("<leader>h%d", i),
          function()
            local harpoon = require("harpoon")
            harpoon:list():select(i)
          end,
          desc = string.format("Select Harpoon item %d", i),
        })
      end

      return bindings
    end)(),
  },
  -- Oil
  {
    "stevearc/oil.nvim",
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    config = function()
      require("oil").setup({
        keymaps = {
          ["<C-h"] = false,
        },
        view_options = {
          show_hidden = true,
        },
      })
    end,
    keys = {
      { "<C-n>", ":Oil<CR>", desc = "Open Oil" },
    },
  },
  -- Telescope
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local function get_git_dir()
        local git_dir = vim.fn.system(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
        git_dir = string.gsub(git_dir, "\n", "") -- remove newline character
        if git_dir == "" then
          return nil -- Not a git directory
        end
        return git_dir
      end

      function _G.telescope_live_grep_in_repository()
        local git_dir = get_git_dir()
        if git_dir then
          local opts = { cwd = git_dir }
          require("telescope.builtin").live_grep(opts)
        else
          print("Not a git repository")
        end
      end

      function _G.telescope_find_files_in_repository()
        local git_dir = get_git_dir()
        if git_dir then
          local opts = { cwd = git_dir }
          require("telescope.builtin").find_files(opts)
        else
          print("Not a git repository")
        end
      end

      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            ".git/",
            "build/",
            "build_debug/",
            "devel/",
            "devel_debug/",
            "logs/",
            "logs_debug/",
            ".cache/",
            ".catkin_tools/",
            ".mrt_tools/",
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })

      require("telescope").load_extension("ui-select")
    end,

    keys = {
      { "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy find in current buffer" },
      { "<leader>fb", ":Telescope buffers<CR>", desc = "Find open buffers" },
      {
        "<leader>ff",
        ":lua telescope_find_files_in_repository()<CR>",
        desc = "Find file in current git repository",
      },
      { "<leader>fF", ":Telescope find_files<CR>", desc = "Find files" },
      {
        "<leader>fg",
        ":lua telescope_live_grep_in_repository()<CR>",
        desc = "Grep in the current git repository",
      },
      { "<leader>fG", ":Telescope live_grep<CR>", desc = "Grep across all files" },
      { "<leader>fh", ":Telescope help_tags<CR>", desc = "Telescope help" },
      { "<leader>fr", ":Telescope resume<CR>", desc = "Resume last Telescope picker" },
    },
  },
  -- Vim-tmux-navigator
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
}

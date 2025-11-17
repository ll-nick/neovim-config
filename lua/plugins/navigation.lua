return {
  -- Leap
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
    end,
    keys = {
      -- Manually define defaults due to https://github.com/ggandor/leap.nvim/issues/224
      { "s", "<Plug>(leap-forward)", mode = { "n", "x", "o" }, desc = "Leap forward" },
      { "S", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap backward" },
      { "gs", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "Leap from window" },
    },
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
      {
        "<C-n>",
        function()
          require("oil").toggle_float()
        end,
        desc = "Open Oil",
      },
    },
  },
  -- Telescope
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    config = function()
      local function get_git_dir()
        local output = vim.fn.systemlist(string.format("git -C %s rev-parse --show-toplevel", vim.fn.expand("%:p:h")))
        if vim.v.shell_error ~= 0 or #output == 0 then
          return nil
        end
        return output[1]
      end

      function _G.telescope_live_grep_in_repository()
        local git_dir = get_git_dir()
        -- If not in a git repository, fall back to the current working directory
        local opts = { cwd = git_dir or vim.fn.getcwd() }
        require("telescope.builtin").live_grep(opts)
      end

      function _G.telescope_find_files_in_repository()
        local git_dir = get_git_dir()
        -- If not in a git repository, fall back to the current working directory
        local opts = { cwd = git_dir or vim.fn.getcwd() }
        require("telescope.builtin").find_files(opts)
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
          fzf = {},
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })

      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
    end,

    keys = {
      { "<leader>/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy find in current buffer" },
      { "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Find open buffers" },
      {
        "<leader>ff",
        function()
          telescope_find_files_in_repository()
        end,
        desc = "Find file in current git repository",
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({ no_ignore = true })
        end,
        desc = "Find files",
      },
      {
        "<leader>fg",
        function()
          telescope_live_grep_in_repository()
        end,
        desc = "Grep in the current git repository",
      },
      { "<leader>fG", "<Cmd>Telescope live_grep<CR>", desc = "Grep across all files" },
      { "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Find document symbols" },
      { "<leader>fh", "<Cmd>Telescope help_tags<CR>", desc = "Telescope help" },
      { "<leader>fr", "<Cmd>Telescope resume<CR>", desc = "Resume last Telescope picker" },
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
      { "<c-h>", "<Cmd><C-U>TmuxNavigateLeft<CR>" },
      { "<c-j>", "<Cmd><C-U>TmuxNavigateDown<CR>" },
      { "<c-k>", "<Cmd><C-U>TmuxNavigateUp<CR>" },
      { "<c-l>", "<Cmd><C-U>TmuxNavigateRight<CR>" },
      { "<c-\\>", "<Cmd><C-U>TmuxNavigatePrevious<CR>" },
    },
  },
}

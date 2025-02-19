return {
  "echasnovski/mini.surround",
  version = false,
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "<leader>sa", -- Add surrounding in Normal and Visual modes
        delete = "<leader>sd", -- Delete surrounding
        find = "<leader>sf", -- Find surrounding (to the right)
        find_left = "<leader>sF", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "<leader>sr", -- Replace surrounding
        update_n_lines = "<leader>sn", -- Update `n_lines`
      },
    })
  end,
}

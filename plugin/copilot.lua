vim.pack.add({ "https://github.com/zbirenbaum/copilot.lua" })

require("copilot").setup({
  server_opts_overrides = {
    settings = {
      telemetry = {
        telemetryLevel = "off",
      },
    },
  },
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = "<M-y>",
      accept_line = "<M-$>",
      accept_word = "<M-w>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<M-e>",
    },
  },
  filetypes = {
    yaml = true,
    markdown = true,
    gitcommit = true,
    gitrebase = true,
    cvs = true,
    ["."] = true,
  },
})

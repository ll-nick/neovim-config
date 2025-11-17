local host_capabilities = require("host_capabilities")
return {
  "ll-nick/mrt.nvim",
  enabled = host_capabilities.has_mrt_tools,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope.nvim" },
    {
      "stevearc/overseer.nvim",
      opts = {
        task_list = {
          max_width = { 100, 0.5 },
          min_width = { 60, 0.4 },
          max_height = { 40, 0.5 },
          min_height = { 20, 0.3 },
          bindings = {
            ["<leader>qq"] = "OpenQuickFix",
            ["L"] = "IncreaseDetail",
            ["H"] = "DecreaseDetail",
            ["<C-l>"] = false,
            ["<C-h>"] = false,
            ["<C-L>"] = false,
            ["<C-H>"] = false,
            ["<C-u>"] = "ScrollOutputUp",
            ["<C-d>"] = "ScrollOutputDown",
          },
        },
      },
      keys = {
        { "<leader>oo", "<Cmd>OverseerToggle<CR>", desc = "Toggle overseer" },
      },
    },
  },
  config = function()
    require("mrt.overseer").register_build_template(
      "MRT Build: Simulation",
      { "build", "-j4", "--release", "simulation_adenauerring" }
    )
    require("mrt.overseer").register_build_template(
      "MRT Build: Behavior Node",
      { "build", "-j4", "behavior_arbitration_ros_tool" }
    )
  end,
  keys = {
    { "<leader>bw", "<Cmd>MrtBuildWorkspace<CR>", desc = "Build workspace" },
    { "<leader>bp", "<Cmd>MrtBuildCurrentPackage<CR>", desc = "Build current package" },
    { "<leader>bt", "<Cmd>MrtBuildCurrentPackageTests<CR>", desc = "Build tests for current package" },
    { "<leader>fp", "<Cmd>MrtPickCatkinPackage<CR>", desc = "Pick catkin package" },
    { "<leader>sp", "<Cmd>MrtSwitchCatkinProfile<CR>", desc = "Switch catkin profile" },
    {
      "<leader>bs",
      function()
        require("overseer").run_template({ name = "MRT Build: Simulation" })
      end,
      desc = "Build simulation",
    },
    {
      "<leader>bb",
      function()
        require("overseer").run_template({ name = "MRT Build: Behavior Node" })
      end,
      desc = "Build behavior node",
    },
  },
}

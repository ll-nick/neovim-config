return {
  "ll-nick/mrt.nvim",

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
        { "<leader>oo", "<cmd>OverseerToggle<cr>", desc = "Toggle overseer" },
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
    { "<leader>bw", "<cmd>MrtBuildWorkspace<cr>", desc = "Build workspace" },
    { "<leader>bp", "<cmd>MrtBuildCurrentPackage<cr>", desc = "Build current package" },
    { "<leader>bt", "<cmd>MrtBuildCurrentPackageTests<cr>", desc = "Build tests for current package" },
    { "<leader>fp", "<cmd>MrtPickCatkinPackage<cr>", desc = "Pick catkin package" },
    { "<leader>sp", "<cmd>MrtSwitchCatkinProfile<cr>", desc = "Switch catkin profile" },
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

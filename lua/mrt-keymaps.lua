local execute_in_new_pane = function(command)
	local pane_height = 10
	local split_window = "silent !tmux split-window -v -l " .. pane_height
	local execute_command_and_wait = string.format("bash -c \"%s; read -p 'Press Enter to exit'\"", command)
	local tmux_command = split_window .. " " .. execute_command_and_wait
	vim.cmd(tmux_command)
end

local execute_in_current_file_directory = function(command)
	local current_file_directory = vim.fn.expand("%:p:h")
	local execute_command = "cd " .. current_file_directory .. " && " .. command
	execute_in_new_pane(execute_command)
end

local map_compile_commands = function()
	local command =
		"!jq -s 'map(.[])' $(echo \"build_$(cat .catkin_tools/profiles/profiles.yaml | sed 's/active: //')\" | sed 's/_release//')/**/compile_commands.json > compile_commands.json"
	vim.cmd(command)
end

local build_workspace = function()
	local build_command = "source ~/.config/bash/mrt.bash && mrt catkin build -j4 -c --no-coverage"
	execute_in_new_pane(build_command)
end

local build_current_package = function()
	local build_command = "source ~/.config/bash/mrt.bash && mrt catkin build -j4 -c --this --no-coverage"
	execute_in_current_file_directory(build_command)
end

local build_and_run_tests = function()
	local build_command = "source ~/.config/bash/mrt.bash && mrt run_tests --this --no-deps -j4"
	execute_in_current_file_directory(build_command)
end

local set_catkin_profile = function(profile)
	local set_profile_command = "!mrt catkin profile set " .. profile
	vim.cmd(set_profile_command)
end

vim.keymap.set("n", "<Leader>bw", build_workspace, { desc = "Build workspace" })
vim.keymap.set("n", "<Leader>bp", build_current_package, { desc = "Build current package" })
vim.keymap.set("n", "<Leader>bt", build_and_run_tests, { desc = "Run tests" })

vim.keymap.set("n", "<Leader>mc", map_compile_commands, { desc = "Map compile commands" })

vim.keymap.set("n", "<Leader>pr", function()
	set_catkin_profile("release")
end, { desc = "Set catkin profile to 'release'" })
vim.keymap.set("n", "<Leader>pd", function()
	set_catkin_profile("debug")
end, { desc = "Set catkin profile to 'debug'" })

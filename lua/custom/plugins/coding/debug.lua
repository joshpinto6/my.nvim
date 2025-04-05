-- Thanks to:
-- https://miguelcrespo.co/posts/debugging-javascript-applications-with-neovim/
-- https://theosteiner.de/debugging-javascript-frameworks-in-neovim#i-have-to-make-a-confession

return {
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			{
				"mfussenegger/nvim-dap",
        -- stylua: ignore
        keys = {
          { "<leader>db", function() require 'dap'.toggle_breakpoint() end, desc = "[D]ebug: [B]reakpoint Toggle" },
          { "<leader>dB", function() require 'dap'.step_out() end,          desc = "[D]ebug: [B]reakpoint Condition" },
          { "<leader>dc", function() require 'dap'.continue() end,          desc = "[D]ebug: [C]ontinue" },
          { "<leader>dn", function() require 'dap'.step_over() end,         desc = "[D]ebug: [N]ext (Step Over)" },
          { "<leader>di", function() require 'dap'.step_into() end,         desc = "[D]ebug: Step [I]nto" },
          { "<leader>do", function() require 'dap'.step_out() end,          desc = "[D]ebug: Step [O]ut" },
        },
				dependencies = {

					{
						"mxsdev/nvim-dap-vscode-js",
						config = function()
							require("dap-vscode-js").setup({
								-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
								debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
								-- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
								adapters = {
									"chrome",
									"pwa-node",
									"pwa-chrome",
									"pwa-msedge",
									"node-terminal",
									"pwa-extensionHost",
									"node",
									"chrome",
								}, -- which adapters to register in nvim-dap
								-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
								-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
								-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
							})
						end,
					},
				},
				config = function()
					local js_based_languages = { "typescript", "javascript", "typescriptreact" }
					for _, language in ipairs(js_based_languages) do
						require("dap").configurations[language] = {
							{ -- It will help you debug single Node.js files
								type = "pwa-node",
								request = "launch",
								name = "Launch file",
								program = "${file}",
								cwd = "${workspaceFolder}",
							},
							{ -- It will help you debug node processes like `express` applications
								type = "pwa-node",
								request = "attach",
								name = "Attach",
								processId = require("dap.utils").pick_process,
								cwd = "${workspaceFolder}",
							},
							{ -- It will help you debug web applications
								type = "pwa-chrome",
								request = "launch",
								name = 'Start Chrome with "localhost"',
								url = "http://localhost:3000",
								webRoot = "${workspaceFolder}",
								userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir", -- will let you save your Chrome profile in a file
							},
						}
					end
				end,
			},
			{
				"nvim-neotest/nvim-nio",
			},
		},
		config = function()
			require("dapui").setup()

			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			vim.keymap.set("n", "<leader>dm", require("dapui").toggle, { desc = "[D]ebug: [M]enu (DAP UI)" })
		end,
	},
}

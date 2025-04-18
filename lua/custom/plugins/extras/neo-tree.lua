-- link: https://github.com/nvim-neo-tree/neo-tree.nvim

return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>ue", "<cmd>Neotree toggle<cr>", desc = "[U]I: [E]xplorer (NeoTree)" },
		-- {
		--   '<leader>fe',
		--   function()
		--     require('neo-tree.command').execute { toggle = true, dir = LazyVim.root() }
		--   end,
		--   desc = 'Explorer NeoTree (Root Dir)',
		-- },
		-- {
		--   '<leader>fE',
		--   function()
		--     require('neo-tree.command').execute { toggle = true, dir = vim.uv.cwd() }
		--   end,
		--   desc = 'Explorer NeoTree (cwd)',
		-- },
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		if vim.fn.argc(-1) == 1 then
			local stat = vim.uv.fs_stat(vim.fn.argv(0))
			if stat and stat.type == "directory" then
				require("neo-tree")
			end
		end
	end,
	opts = {
		sources = { "filesystem", "buffers", "git_status", "document_symbols" },
		open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = true,
			},
		},
		window = {
			position = "left",
			mappings = {
				["<space>"] = "none",
				["Y"] = {
					function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.fn.setreg("+", path, "c")
					end,
					desc = "Copy Path to Clipboard",
				},
				["O"] = {
					function(state)
						require("lazy.util").open(state.tree:get_node().path, { system = true })
					end,
					desc = "Open with System Application",
				},
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
		},
	},
	config = function(_, opts)
		-- local function on_move(data)
		--   LazyVim.lsp.on_rename(data.source, data.destination)
		-- end

		-- local events = require 'neo-tree.events'
		opts.event_handlers = opts.event_handlers or {}
		-- vim.list_extend(opts.event_handlers, {
		--   { event = events.FILE_MOVED, handler = on_move },
		--   { event = events.FILE_RENAMED, handler = on_move },
		-- })
		require("neo-tree").setup(opts)
		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "*lazygit",
			callback = function()
				if package.loaded["neo-tree.sources.git_status"] then
					require("neo-tree.sources.git_status").refresh()
				end
			end,
		})
	end,
}

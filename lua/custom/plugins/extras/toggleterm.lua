return {
	-- Toggle Term
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			open_mapping = [[<c-\>]],
			direction = "float", --'horizontal' | 'vertical' | 'tab' | 'float'
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)

			local Terminal = require("toggleterm.terminal").Terminal
			local gitui = Terminal:new({
				cmd = "gitui",
				direction = "float",
				on_exit = function(term, job, exit_code, name)
					term:close()
				end,
			})
			function _GITUI_TOGGLE()
				gitui:toggle()
			end
			vim.keymap.set("n", "<leader>gu", "<cmd>lua _GITUI_TOGGLE()<CR>", { noremap = true, silent = true })
			-- vim.keymap.set('n', '<leader>gu', ':ToggleTerm direction=float<CR>gitui<CR>', { noremap = true, silent = true })
		end,
	},

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration

			-- Only one of these is needed, not both.
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},

	-- Toggle Term Manager
	{
		"ryanmsnyder/toggleterm-manager.nvim",
		-- No need dependencies because I use them all
		-- dependencies = {
		-- 'akinsho/nvim-toggleterm.lua',
		--   "nvim-telescope/telescope.nvim",
		--   "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
		-- },
		config = function()
			local toggleterm_manager = require("toggleterm-manager")
			local actions = require("toggleterm-manager").actions

			toggleterm_manager.setup({
				mappings = { -- key mappings bound inside the telescope window
					i = {
						["<CR>"] = { action = actions.toggle_term, exit_on_action = true }, -- toggles terminal open/closed
						["<C-i>"] = { action = actions.create_term, exit_on_action = false }, -- creates a new terminal buffer
						["<C-d>"] = { action = actions.delete_term, exit_on_action = false }, -- deletes a terminal buffer
						["<C-r>"] = { action = actions.rename_term, exit_on_action = false }, -- provides a prompt to rename a terminal
					},
				},
				titles = {
					preview = "Preview", -- title of the preview buffer in telescope
					prompt = " Terminals", -- title of the prompt buffer in telescope
					results = "Results", -- title of the results buffer in telescope
				},
				results = {
					fields = { -- fields that will appear in the results of the telescope window
						"state", -- the state of the terminal buffer: h = hidden, a = active
						"space", -- adds space between fields, if desired
						"term_icon", -- a terminal icon
						"term_name", -- toggleterm's display_name if it exists, else the terminal's id assigned by toggleterm
					},
					separator = " ", -- the character that will be used to separate each field provided in results.fields
					term_icon = "", -- the icon that will be used for term_icon in results.fields
				},
				search = {
					field = "term_name", -- the field that telescope fuzzy search will use when typing in the prompt
				},
				sort = {
					field = "term_name", -- the field that will be used for sorting in the telesocpe results
					ascending = true, -- whether or not the field provided above will be sorted in ascending or descending order
				},
			})
			vim.keymap.set("n", [[<C-|>]], "<cmd>Telescope toggleterm_manager<cr>", { desc = "ToggleTerm Manager" })
		end,
	},
}

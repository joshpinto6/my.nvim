return {
	-- NOTE: Plugins can also be added by using a table,
	-- with the first argument being the link and the following
	-- keys can be used to configure plugin behavior/loading/etc.
	--
	-- Use `opts = {}` to force a plugin to be loaded.
	--
	--  This is equivalent to:
	--    require('Comment').setup({})

	-- "gc" to comment visual regions/lines
	{
		"numToStr/Comment.nvim",
		dependencies = {
			{ "JoosepAlviste/nvim-ts-context-commentstring", opts = {} },
		},
		config = function()
			local comment = require("Comment")
			-- local api = require 'Comment.api'
			comment.setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
				mappings = {
					basic = true,
					extra = false,
				},
			})
			vim.keymap.del("n", "gcc")
			vim.keymap.set("n", "gc", require("Comment.api").toggle.linewise.current)

			-- Function to toggle comment in insert mode
			local function toggle_comment_insert_mode()
				-- Exit insert mode, toggle the comment, and go back to insert mode
				vim.api.nvim_feedkeys(
					vim.api.nvim_replace_termcodes("<Esc><Plug>(comment_toggle_linewise)gi", true, false, true),
					"n",
					true
				)
			end

			-- Remap <C-/> in normal, visual, and insert modes

			-- vim.keymap.set('n', '<C-_>', api.toggle.linewise.current)
			-- vim.keymap.set('n', '<C-/>', api.toggle.linewise.current, {})
			-- vim.keymap.set('v', '<C-/>', 'gc', {})
			-- vim.keymap.set('i', '<C-/>', api.toggle.linewise.current, { noremap = true, silent = true })
		end,
	},
}

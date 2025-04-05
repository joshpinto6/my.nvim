-- Mini is Collection of various small independent plugins/modules
-- Check out: https://github.com/echasnovski/mini.nvim

return {
	"echasnovski/mini.nvim",
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		-- require('mini.surround').setup()

		-- local mini_animate = require 'mini.animate'
		-- mini_animate.setup {
		--   scroll = {
		--     -- Whether to enable this animation
		--     enable = true,
		--
		--     -- Timing of animation (how steps will progress in time)
		--     timing = mini_animate.gen_timing.linear { duration = 50, unit = 'total' }, --<function: implements linear total 250ms animation duration>,
		--
		--     -- Subscroll generator based on total scroll
		--     -- subscroll = --<function: implements equal scroll with at most 60 steps>,
		--   },
		-- }

		-- Simple and easy statusline.
		--  You could remove this setup call if you don't like it,
		--  and try some other statusline plugin
		local statusline = require("mini.statusline")
		-- set use_icons to true if you have a Nerd Font
		statusline.setup({ use_icons = vim.g.have_nerd_font })

		-- You can configure sections in the statusline by overriding their
		-- default behavior. For example, here we set the section for
		-- cursor location to LINE:COLUMN
		---@diagnostic disable-next-line: duplicate-set-field
		statusline.section_location = function()
			return "%2l:%-2v"
		end

		-- ... and there is more!
		--  Check out: https://github.com/echasnovski/mini.nvim
	end,
}

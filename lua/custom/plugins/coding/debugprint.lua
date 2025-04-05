local leader = "<leader>p"

return {
	"andrewferrier/debugprint.nvim",
	dependencies = {
		"echasnovski/mini.nvim", -- Needed to enable :ToggleCommentDebugPrints for NeoVim 0.9
	},
	-- Remove the following line to use development versions,
	-- not just the formal releases
	version = "*",
	opts = {
		keymaps = {
			normal = {
				plain_below = leader .. "p",
				plain_above = leader .. "P",
				variable_below = leader .. "v",
				variable_above = leader .. "V",
				variable_below_alwaysprompt = leader .. "a",
				variable_above_alwaysprompt = leader .. "A",
				textobj_below = leader .. "o",
				textobj_above = leader .. "O",
				toggle_comment_debug_prints = leader .. "c",
				delete_debug_prints = leader .. "d",
			},
			visual = {
				variable_below = leader .. "p",
				variable_above = leader .. "P",
			},
		},
		commands = {
			toggle_comment_debug_prints = "ToggleCommentDebugPrints",
			delete_debug_prints = "DeleteDebugPrints",
		},
	},
	config = function(_, opts)
		require("debugprint").setup(opts)
		require("which-key").add({
			{ leader, group = "[P]rint to Debug" },
		})
	end,
}

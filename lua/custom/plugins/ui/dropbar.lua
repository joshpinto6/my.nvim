return {
	"Bekaboo/dropbar.nvim",
	enabled = true, -- I disable it because it need neovim version >= 10
	dependencies = {
		-- optional, but required for fuzzy finder support
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	-- config = function()
	--   require('dropbar').setup()
	-- end,
}

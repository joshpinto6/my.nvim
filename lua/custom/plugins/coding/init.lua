return {
	--NOTE: For colorizing tailwind
	{
		"NvChad/nvim-colorizer.lua",
		opts = {
			user_default_options = {
				tailwind = true,
			},
		},
	},

	{
		"0x100101/lab.nvim",
		enabled = false,
		config = function()
			require("lab").setup({
				quick_data = {
					enabled = true,
				},
			})
		end,
	},

	--NOTE: Catalyze your Fenced Markdown Code-block editing!
	--
	-- {
	--   'AckslD/nvim-FeMaco.lua',
	--   ft = { 'tex', 'plaintex', 'markdown' },
	--   keys = {
	--     { '<localleader>e', '<cmd>FeMaco<cr>', desc = '[E]dit with FeMaco' },
	--   },
	--   opts = {},
	-- },
}

return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- keys = {
	-- { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
	-- { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
	-- { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
	-- {
	--   '<leader>cS',
	--   '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
	--   desc = 'LSP references/definitions/... (Trouble)',
	-- },
	-- { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
	-- { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
	-- },
	opts = {
		position = "bottom", -- position of the list can be: bottom, top, left, right
	},
	config = function(_, opts)
		require("trouble").setup(opts)
		vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>", { desc = "Trouble Menu" })
	end,
}

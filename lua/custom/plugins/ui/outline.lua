return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = { -- Example mapping to toggle outline
		{ "<leader>uo", "<cmd>Outline<CR>", desc = "[U]I: [O]utline Toggle" },
	},
	opts = {
		outline_window = {
			-- Where to open the split window: right/left
			position = "left",
		},
	},
}

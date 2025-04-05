local leader = "<leader>i"
local desc_prefix = "[I]con: "

return {
	"ziontee113/icon-picker.nvim",
	lazy = false,
	enabled = true,
	keys = {
		{ leader .. "i", mode = { "n" }, "<cmd>IconPickerNormal<cr>", desc = desc_prefix .. "[I]con Picker" },
		{
			leader .. "y",
			mode = { "n" },
			"<cmd>IconPickerYank<cr>",
			desc = desc_prefix .. "[Y]nk Selected Icon into Register",
		},
		{
			"<C-i>",
			mode = { "i" },
			"<cmd>IconPickerInsert<cr>",
			desc = desc_prefix .. "[I]nsert Icon (Icon Picker)",
		},
	},
	config = function()
		require("icon-picker").setup({ disable_legacy_commands = true })
		require("which-key").add({
			{ "<leader>i", group = "[I]con Picker" },
		})
	end,
}

-- Treesitter: Highlight, edit, and navigate code

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"vim",
			"vimdoc",
		},
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { "ruby" },
		},
		-- It is uses in Comment.nvim
		--context_commentstring = {
		--	config = {
		--		-- support comment on jsx element
		--		javascript = {
		--			__default = "// %s",
		--			jsx_element = "{/* %s */}",
		--			jsx_fragment = "{/* %s */}",
		--			jsx_attribute = "// %s",
		--			comment = "// %s",
		--		},
		--		-- support comment on tsx element
		--		typescript = { __default = "// %s", __multiline = "/* %s */" },
		--	},
		--},
		indent = { enable = true, disable = { "ruby" } },
	},
	}

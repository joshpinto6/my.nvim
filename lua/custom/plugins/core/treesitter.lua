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
			"bibtex",
			"latex",
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
		context_commentstring = {
			config = {
				-- support comment on jsx element
				javascript = {
					__default = "// %s",
					jsx_element = "{/* %s */}",
					jsx_fragment = "{/* %s */}",
					jsx_attribute = "// %s",
					comment = "// %s",
				},
				-- support comment on tsx element
				typescript = { __default = "// %s", __multiline = "/* %s */" },
			},
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	config = function(_, opts)
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

		-- dofile(vim.g.base46_cache .. 'syntax')

		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup(opts)

		vim.filetype.add({
			extension = {
				mdx = "mdx",
			},
		})

		-- tell treesitter to use the markdown parser for mdx files
		-- local ft_to_parser = require('nvim-treesitter.parsers').filetype_to_parsername
		-- ft_to_parser.mdx = 'markdown'

		-- tell treesitter to use the markdown parser for mdx files
		vim.treesitter.language.register("markdown", "mdx")

		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	end,
}

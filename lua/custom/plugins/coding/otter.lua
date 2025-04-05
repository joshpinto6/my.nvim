local notes_based_ft = { "markdown", "norg", "rmd", "org" }
local prefix = "<localleader>s" -- use 's' because it easier to type
local desc = "Otter: "

return {
	"jmbuhr/otter.nvim",
	enabled = true,
	ft = notes_based_ft,
	dependencies = {
		"hrsh7th/nvim-cmp", -- optional, for completion
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		lsp = {
			hover = {
				border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
			},
			-- `:h events` that cause the diagnostics to update. Set to:
			-- { "BufWritePost", "InsertLeave", "TextChanged" } for less performant
			-- but more instant diagnostic updates
			diagnostic_update_events = { "BufWritePost" },
		},
		buffers = {
			-- if set to true, the filetype of the otterbuffers will be set.
			-- otherwise only the autocommand of lspconfig that attaches
			-- the language server will be executed without setting the filetype
			set_filetype = false,
			-- write <path>.otter.<embedded language extension> files
			-- to disk on save of main buffer.
			-- usefule for some linters that require actual files
			-- otter files are deleted on quit or main buffer close
			write_to_disk = false,
		},
		strip_wrapping_quote_characters = { "'", '"', "`" },
		-- Otter may not work the way you expect when entire code blocks are indented (eg. in Org files)
		-- When true, otter handles these cases fully. This is a (minor) performance hit
		handle_leading_whitespace = false,
	},
	config = function(_, opts)
		local otter = require("otter")
		otter.setup(opts)

		-- [All Keymaps]
		-- This keymaps is not work if it place with "keys" property from lazy.nvim

		vim.keymap.set("n", prefix .. "a", function()
			-- table of embedded languages to look for.
			-- default = nil, which will activate
			-- any embedded languages found
			-- local languages = { 'python', 'lua' }
			local languages = nil

			-- enable completion/diagnostics
			-- defaults are true
			local completion = true
			local diagnostics = true
			-- treesitter query to look for embedded languages
			-- uses injections if nil or not set
			local tsquery = nil

			otter.activate(languages, completion, diagnostics, tsquery)
		end, { desc = "[A]ctivate Otter" })

		vim.keymap.set("n", prefix .. "k", function()
			require("otter").ask_hover()
		end, { desc = desc .. "Hover Help", noremap = true, silent = true })

		vim.keymap.set("n", prefix .. "d", function()
			require("otter").ask_definition()
		end, { desc = desc .. "[D]efinition" })

		vim.keymap.set("n", prefix .. "t", function()
			require("otter").ask_type_definition()
		end, { desc = desc .. "[T]ype Definition", noremap = true, silent = true })

		vim.keymap.set("n", prefix .. "s", function()
			require("otter").ask_document_symbols()
		end, { desc = desc .. "Document [S]ymbols" })

		vim.keymap.set("n", prefix .. "R", function()
			require("otter").ask_rename()
		end, { desc = desc .. "[R]ename" })

		vim.keymap.set("n", prefix .. "f", function()
			require("otter").ask_format()
		end, { desc = desc .. "[F]ormat" })
	end,
}

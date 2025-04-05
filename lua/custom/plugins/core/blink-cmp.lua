return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},

	-- use a release tag to download pre-built binaries
	version = "*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
fuzzy = { implementation = "lua" },
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- See the full "keymap" documentation for information on defining your own keymap.
		keymap = {
			-- preset = 'super-tab',
			["<M-k>"] = { "select_prev", "fallback" },
			["<M-j>"] = { "select_next", "fallback" },
			["<Tab>"] = { "accept" },
		},

		completion = {
			trigger = {
				show_in_snippet = false,
			},
		},

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		cmdline = {
			enabled = true,
			completion = {
				menu = {
					auto_show = true,
				},
			},
			keymap = {
				["<Tab>"] = { "select_and_accept" },
				["<M-j>"] = { "select_next", "fallback" },
				["<M-k>"] = { "select_prev", "fallback" },
			},
		},

		snippets = {
			expand = function(snippet)
				local ls = require("luasnip")
				ls.lsp_expand(snippet)
				local s = ls.snippet
				local t = ls.text_node

				-- For golang
				ls.add_snippets("go", {
					s("ifer", {
						t({ "if err != nil {", "\treturn err", "}" }),
					}),
				})
			end,
			active = function(filter)
				if filter and filter.direction then
					return require("luasnip").jumpable(filter.direction)
				end
				return require("luasnip").in_snippet()
			end,
			jump = function(direction)
				require("luasnip").jump(direction)
			end,
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
	},
	opts_extend = { "sources.default" },
}

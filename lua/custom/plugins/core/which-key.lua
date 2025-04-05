-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		require("which-key").setup({
			preset = "helix",
			triggers = {
				-- { "<auto>", mode = "nixsotc" }, -- Default
				--
				-- So... I disable trigger for 'x' (visual mode) and 't' (terminal mode).
				-- Reason for 'x' mode: I used to <c-d> and <c-u> after I enter the x mode
				-- Reason for 't' mode: Terminal based app like lazygit use <esc> to close, but which-key will be force to use <esc> as entering normal mode.
				{ "<auto>", mode = "nixsoc" },
			},
			colors = false,
			-- It will make the transparancy broken
			-- win = {
			--   no_overlap = false,
			--   wo = {
			--     winblend = 90, -- value between 0-100 0 for fully opaque and 100 for fully transparent
			--   },
			-- },
			-- triggers_nowait = {
			--   -- marks
			--   ';',
			--   '`',
			--   "'",
			--   'g`',
			--   "g'",
			--   -- registers
			--   '"',
			--   '<c-r>',
			--   -- spelling
			--   'z=',
			-- },
		})

		require("which-key").add({
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ebug" },
			{ "<leader>r", group = "[R]ename" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>C", group = "[C]onfiguration" },
			{ "<leader>m", group = "[M]ason" },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>x", group = "Fi[X] Wrong (Trouble)" },
			{ "<leader>u", group = "[U]I" },

			-- [G]
			{ "g?", group = "Print Debug" },

			-- [F]
			{ "<leader>f", group = "Movement" },

			-- [Local]
			{ "<localLeader>l", group = "[L]atex" },
			{ "<localLeader>o", group = "[O]bsidian" },
		})
	end,
}

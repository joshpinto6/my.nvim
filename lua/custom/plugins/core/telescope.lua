-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			{
				"nvim-telescope/telescope-file-browser.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },

			-- Useful for sorting recent file
			{ "mollerhoj/telescope-recent-files.nvim" },

			-- Import modules with ease
			-- { 'piersolenski/telescope-import.nvim' },

			"andrew-george/telescope-themes",

			-- 'nvim-telescope/telescope-file-browser.nvim',
		},
		config = function()
			-- Telescope is a fuzzy finder that comes with a lot of different things that
			-- it can fuzzy find! It's more than just a "file finder", it can search
			-- many different aspects of Neovim, your workspace, LSP, and more!
			--
			-- The easiest way to use Telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- After running this command, a window will open up and you're able to
			-- type in the prompt window. You'll see a list of `help_tags` options and
			-- a corresponding preview of the help.
			--
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- This opens a window that shows you all of the keymaps for the current
			-- Telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it!

			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				defaults = {
					-- path_display = function(_, path)
					--   local tail = require('telescope.utils').path_tail(path)
					--   return string.format('%s - (%s)', tail, path), { { { 1, #tail }, 'Comment' } }
					-- end,
					mappings = {
						-- i = { ['<c-enter>'] = 'to_fuzzy_refine' },
						i = {
							["<A-j>"] = "move_selection_next",
							["<A-k>"] = "move_selection_previous",
							["<C-S-v>"] = { "<C-r>+", type = "command" },
						},
					},
					layout_config = {
						-- prompt_position = 'top',
						horizontal = {
							width = 0.9,
							height = 0.9,
							preview_cutoff = 120,
							prompt_position = "top",
							preview_width = 0.3,
						},
						vertical = {
							prompt_position = "top",
							enable_live_preview = true,
							preview_cutoff = 10,
							width_padding = 0.05,
							height_padding = 1,
							preview_height = 0.3,
						},
					},
					layout_strategy = "horizontal",
					-- layout_config = {
					--   vertical = {
					--     prompt_position = 'top',
					--   },
					--   -- horizontal = {
					--   --   prompt_position = 'top',
					--   -- },
					-- },

					sorting_strategy = "ascending",

					-- configure to use ripgrep
					vimgrep_arguments = {
						"rg",
						"--follow", -- Follow symbolic links
						"--hidden", -- Search for hidden files
						"--no-heading", -- Don't group matches by each file
						"--with-filename", -- Print the file path with the matched lines
						"--line-number", -- Show line numbers
						"--column", -- Show column numbers
						"--smart-case", -- Smart case search

						-- Exclude some patterns from search
						"--glob=!**/.git/*",
						"--glob=!**/.github/*",
						"--glob=!**/.idea/*",
						"--glob=!**/.vscode/*",
						"--glob=!**/build/*",
						"--glob=!**/dist/*",
						"--glob=!**/yarn.lock",
						"--glob=!**/package-lock.json",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						-- needed to exclude some files & dirs from general search
						-- when not included or specified in .gitignore
						find_command = {
							"rg",
							"--files",
							"--hidden",
							"--glob=!**/.git/*",
							"--glob=!**/.github/*",
							"--glob=!**/.idea/*",
							"--glob=!**/.vscode/*",
							"--glob=!**/build/*",
							"--glob=!**/dist/*",
							"--glob=!**/yarn.lock",
							"--glob=!**/package-lock.json",
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
					themes = {
						-- you can add regular telescope config
						-- that you want to apply on this picker only
						layout_config = {
							horizontal = {
								width = 0.8,
								height = 0.7,
							},
						},
						-- extension specific config
						enable_previewer = true, -- (boolean) -> show/hide previewer window
						enable_live_preview = true, -- (boolean) -> enable/disable live preview
						ignore = { "default", "desert", "elflord", "habamax" },
						-- (table) -> provide table of theme names to ignore
						-- all builtin themes are ignored by default
						persist = {
							enabled = true, -- enable persisting last theme choice

							-- override path to file that execute colorscheme command
							-- path = vim.fn.stdpath 'config' .. '/lua/colorscheme.lua',
						},
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
			pcall(require("telescope").load_extension, "recent-files")
			pcall(require("telescope").load_extension, "themes")
			pcall(require("telescope").load_extension, "file_browser")
			-- pcall(require('telescope').load_extension, 'import')

			local telescopePickers = require("custom.module.telescope-picker")

			-- See `:help telescope.builtin`
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sH", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", function()
				telescopePickers.prettyGrepPicker({ picker = "grep_string" })
			end, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", function()
				telescopePickers.prettyGrepPicker({ picker = "live_grep" })
			end, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			-- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' }) -- I already use `recent-files` extension

			-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
			-- Solution: https://github.com/nvim-telescope/telescope.nvim/issues/791
			vim.keymap.set("n", "<leader>sb", function()
				-- builtin.buffers { sort_mru = true, ignore_current_buffer = true }
				require("custom.module.telescope-picker").prettyBuffersPicker({
					-- initial_mode = 'normal',
					attach_mappings = function(prompt_bufnr, map)
						local delete_buf = function()
							local action_state = require("telescope.actions.state")
							local current_picker = action_state.get_current_picker(prompt_bufnr)
							current_picker:delete_selection(function(selection)
								vim.api.nvim_buf_delete(selection.bufnr, { force = true })
							end)
						end
						map("i", "<c-d>", delete_buf)
						return true
					end,
					sort_mru = true,
					ignore_current_buffer = true,
				})
			end, { desc = "[S]earch [B]uffers" })

			-- I use sorted telescope result basaed on recent open files
			-- vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' }) --NOTE: This is unsorted
			vim.keymap.set("n", "<leader><leader>", function()
				-- require('telescope').extensions['recent-files'].recent_files {}
				telescopePickers.prettyFilesPicker({ picker = "find_files_recent" })
			end, { noremap = true, silent = true, desc = "Search Files" })

			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set("n", "<leader>/", function()
				-- You can pass additional configuration to Telescope to change the theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					-- winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set("n", "<leader>s/", function()
				telescopePickers.prettyGrepPicker({
					picker = "live_grep",
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			-- Shortcut for searching your Neovim configuration files
			vim.keymap.set("n", "<leader>Cn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[C]onfig: [N]eovim files" })

			vim.keymap.set("n", "<leader>ut", "<cmd>Telescope themes<cr>", { desc = "[U]I: [T]hemes" })

			vim.keymap.set(
				"n",
				"<leader>sf",
				"<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
				{ desc = "[S]earch [F]ile Browser" }
			)
		end,
	},
}

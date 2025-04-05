return {
	{ -- Git command
		"tpope/vim-fugitive",
		cmd = { "Git" },
	},

	{ -- Git menu (complex)
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>gl", "<cmd>LazyGit<cr>", desc = "[L]azyGit" },
		},
		config = function()
			require("telescope").load_extension("lazygit")
		end,
	},

	{ -- Git graph
		"rbong/vim-flog",
		lazy = true,
		cmd = { "Flog", "Flogsplit", "Floggit" },
		dependencies = {
			"tpope/vim-fugitive",
		},
		keys = {
			{ "<leader>gv", "<cmd>Flog<CR>", desc = "Git Graph [V]iew" },
		},
	},

	{ -- Git sign
		"lewis6991/gitsigns.nvim",
		opts = {},
	},

	{ -- Git blame
		"f-person/git-blame.nvim",
		config = function()
			-- This setter must be execute before the setup function
			vim.g.gitblame_delay = 100
			vim.g.gitblame_highlight_group = "Comment"

			require("gitblame").setup({
				--Note how the `gitblame_` prefix is omitted in `setup`
				enabled = false,
			})
			vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "[G]it [B]lame Toggle" })
		end,
	},
}

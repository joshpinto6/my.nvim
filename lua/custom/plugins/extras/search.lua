return {
	{
		"kevinhwang91/nvim-hlslens",
		config = function()
			require("hlslens").setup()
			local kopts = { noremap = true, silent = true }

			vim.api.nvim_set_keymap(
				"n",
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap(
				"n",
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

			-- [Debugprint integration]
			-- Search debugprint number
			-- vim.keymap.set('n', '<leader>ps', function()
			--   vim.ui.input({ prompt = 'Debugprint Number: ' }, function(str)
			--     if str then
			--       -- Create the search pattern
			--       local pattern = 'DEBUGPRINT\\[' .. vim.fn.escape(str, '\\/') .. '\\]'
			--       -- Execute the search
			--       vim.fn.search(pattern)
			--       -- To ensure highlighting, set the last search pattern and redraw the screen
			--       vim.fn.setreg('/', pattern)
			--       vim.cmd 'redraw!'
			--       vim.cmd 'set hlsearch'
			--       vim.cmd [[execute('normal! ' . v:count1 . 'n')]]
			--       vim.cmd [[lua require('hlslens').start()]]
			--     end
			--   end)
			-- end, { desc = 'Search Debugprint' })

			-- Search all debugprint
			-- vim.keymap.set('n', '<leader>pS', function()
			--   -- Create the search pattern
			--   local pattern = 'DEBUGPRINT'
			--   -- Execute the search
			--   vim.fn.search(pattern)
			--   -- To ensure highlighting, set the last search pattern and redraw the screen
			--   vim.fn.setreg('/', pattern)
			--   vim.cmd 'redraw!'
			--   vim.cmd 'set hlsearch'
			--   vim.cmd [[execute('normal! ' . v:count1 . 'n')]]
			--   vim.cmd [[lua require('hlslens').start()]]
			-- end, { desc = 'Search All Debugprint' })

			vim.api.nvim_set_keymap(
				"n",
				"<leader>pS",
				"/DEBUGPRINT<CR>",
				{ noremap = true, silent = true, desc = "Search All Debugprint" }
			)

			function SearchDebugPrint()
				local number = vim.fn.input("Enter the DEBUGPRINT number: ")
				if string.match(number, "^%d+$") then
					-- Use vim.fn.search to perform the search directly.
					vim.fn.search("DEBUGPRINT\\[" .. number .. "\\]")
					-- It is to trigger the nvim-hlens plugin
					vim.cmd([[execute('normal! ' . v:count1 . 'n')]])
					vim.cmd([[lua require('hlslens').start()]])
					vim.cmd([[execute('normal! ' . v:count1 . 'N')]])
					vim.cmd([[lua require('hlslens').start()]])
				else
					print("Please enter a valid number")
				end
			end
			vim.api.nvim_set_keymap("n", "<leader>ps", ":lua SearchDebugPrint()<CR>", { noremap = true, silent = true })
		end,
	},
}

return {
	--NOTE: Autoformat
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		-- keys = {
		--   {
		--     '<leader>cf',
		--     function()
		--       require('conform').format { async = true, lsp_fallback = true }
		--     end,
		--     mode = '',
		--     desc = '[F]ormat buffer',
		--   },
		-- },
		config = function()
			vim.lsp.buf.format({ async = true })
			local conform = require("conform")

			conform.setup({
				notify_on_error = false,
				-- format_on_save = function(bufnr)
				--   -- Disable "format_on_save lsp_fallback" for languages that don't
				--   -- have a well standardized coding style. You can add additional
				--   -- languages here or re-enable it for the disabled ones.
				--   local disable_filetypes = { c = true, cpp = true }
				--   local lsp_format_opt
				--   if disable_filetypes[vim.bo[bufnr].filetype] then
				--     lsp_format_opt = 'never'
				--   else
				--     lsp_format_opt = 'fallback'
				--   end
				--   return {
				--     timeout_ms = 3000,
				--     lsp_format = lsp_format_opt,
				--   }
				-- end,
				format_after_save = {
					lsp_format = "fallback",
					timeout_ms = 500,
				},
				-- formatters = {
				--   prettierd = {
				--     -- args = function(self, ctx)
				--     --   -- if vim.endswith(ctx.filename, '.astro') then
				--     --   --   return {
				--     --   --     '--stdin-filepath',
				--     --   --     '$FILENAME',
				--     --   --     '--plugin',
				--     --   --     'prettier-plugin-astro',
				--     --   --   }
				--     --   -- end
				--     --   return { '--stdin-filepath', '$FILENAME' }
				--     -- end,
				--     command = 'prettierd',
				--     -- args = { '--stdin-filepath', vim.fn.expand '%:p' },
				--     args = function()
				--       local filepath = vim.fn.expand '%:p'
				--       print '=== FROM prettier ==='
				--       print('Prettierd file path: ', filepath)
				--       return { '--stdin-filepath', filepath }
				--     end,
				--     stdin = true,
				--   },
				--   prettier = {
				--     command = 'prettierd',
				--     -- args = { vim.api.nvim_buf_get_name(0) },
				--     -- args = { '--stdin-filepath', vim.fn.expand '%:p' },
				--     args = function()
				--       local filepath = vim.fn.expand '%:p'
				--       print '=== FROM prettierD ==='
				--       print('Prettierd file path: ', filepath)
				--       return { '--stdin-filepath', filepath }
				--     end,
				--     stdin = true,
				--     env = {
				--       string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand '~/.config/nvim/utils/linter-config/.prettierrc.json'),
				--     },
				--   },
				-- },
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					javascript = { "prettier", "eslint_d" },
					typescript = { "prettier", "eslint_d" },
					javascriptreact = { "prettier", "eslint_d" },
					typescriptreact = { "prettier", "eslint_d" },
					svelte = { "prettierd", "prettier" },
					css = { "prettierd", "prettier" },
					html = { "prettierd", "prettier" },
					json = { "prettierd", "prettier" },
					yaml = { "prettierd", "prettier" },
					["markdown"] = { "prettierd", "prettier", "markdownlint", "markdown-toc" },
					["markdown.mdx"] = { "prettierd", "prettier", "markdownlint", "markdown-toc" },
					graphql = { "prettierd", "prettier" },
					tex = { "latexindent" },
					plaintex = { "latexindent" },
					go = { "goimports", "gofumpt" },
				},
			})

			-- conform.format { async = true, lsp_fallback = true }

			-- Customise the default "prettier" command to format Markdown files as well
			conform.formatters.prettierd = {
				prepend_args = { "--prose-wrap", "always" },
			}
			conform.formatters.prettier = {
				prepend_args = { "--prose-wrap", "always" },
			}

			vim.keymap.set({ "n", "v" }, "<leader>cf", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "[F]ormat buffer" })
		end,

		-- opts = {
		--   format = {
		--     -- It's from lazyvim
		--     timeout_ms = 3000,
		--     async = false, -- not recommended to change
		--     quiet = false, -- not recommended to change
		--     lsp_fallback = true, -- not recommended to change
		--   },
		--   notify_on_error = false,
		--   format_on_save = function(bufnr)
		--     -- Disable "format_on_save lsp_fallback" for languages that don't
		--     -- have a well standardized coding style. You can add additional
		--     -- languages here or re-enable it for the disabled ones.
		--     local disable_filetypes = { c = true, cpp = true }
		--     return {
		--       timeout_ms = 500,
		--       lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
		--     }
		--   end,
		--   ---@type table<string, conform.FormatterUnit[]>
		--   formatters_by_ft = {
		--     lua = { { 'stylua' } },
		--     -- Conform can also run multiple formatters sequentially
		--     python = { { 'isort', 'black' } },
		--     --
		--     -- You can use a sub-list to tell conform to run *until* a formatter
		--     -- is found.
		--     javascript = { { 'prettierd', 'prettier' } },
		--     typescript = { { 'prettierd', 'prettier' } },
		--     javascriptreact = { { 'prettierd', 'prettier' } },
		--     typescriptreact = { { 'prettierd', 'prettier' } },
		--     svelte = { { 'prettierd', 'prettier' } },
		--     css = { { 'prettierd', 'prettier' } },
		--     html = { { 'prettierd', 'prettier' } },
		--     json = { { 'prettierd', 'prettier' } },
		--     yaml = { { 'prettierd', 'prettier' } },
		--     ['markdown'] = { { 'prettierd', 'prettier' }, 'markdownlint', 'markdown-toc' },
		--     ['markdown.mdx'] = { { 'prettierd', 'prettier' }, 'markdownlint', 'markdown-toc' },
		--     graphql = { { 'prettierd', 'prettier' } },
		--     tex = { { 'latexindent' } },
		--     plaintex = { { 'latexindent' } },
		--   },
		-- },
	},
}

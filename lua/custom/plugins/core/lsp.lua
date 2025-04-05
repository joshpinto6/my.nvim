-- local yamlls = require 'lspconfig.configs.yamlls'
return {
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{
				"williamboman/mason.nvim",
				keys = {
					{ "<leader>mm", "<cmd>Mason<CR>", desc = "[M]ason [M]enu" },
					{ "<leader>mu", "<cmd>MasonUpdate<CR>", desc = "[M]ason [U]pdate" },
				},
				config = function()
					require("mason").setup({
						ui = {
							border = "rounded",
						},
					})
				end,
			},
			"saghen/blink.cmp",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						window = {
							winblend = 0,
							border = "none",
							zindex = 45,
							max_width = 0,
							max_height = 0,
							x_padding = 1,
							y_padding = 0,
							align = "bottom",
							relative = "editor",
						},
					},
				},
			},
			{
				"folke/neoconf.nvim",
				cmd = "Neoconf",
				opts = {},
			},
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- To activate Inlay Hints
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.inlayHintProvider then
						vim.keymap.set("n", "<leader>ui", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
						end)
					end

					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("gR", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("<leader>ct", require("telescope.builtin").lsp_type_definitions, "[T]ype Definition")
					map(
						"<leader>s,",
						require("custom.module.telescope-picker").prettyDocumentSymbols,
						"[S]earch Document Symbols"
					)
					map(
						"<leader>s;",
						require("custom.module.telescope-picker").prettyWorkspaceSymbols,
						"[S]earch Workspace Symbols"
					)
					map("<leader>cr", vim.lsp.buf.rename, "[R]ename")
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					map("K", vim.lsp.buf.hover, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("<leader>xD", "<cmd>Telescope diagnostics bufnr=0<cr>", "Buffer [D]iagnostic")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.server_capabilities.documentHighlightProvider then
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})

			-- Replace the old capabilities setup with blink.cmp
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = false,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
							semanticTokens = true,
						},
					},
				},
				jsonls = {
					on_new_config = function(new_config)
						new_config.settings.json.schemas = new_config.settings.json.schemas or {}
						vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
					end,
					settings = {
						json = {
							format = {
								enable = true,
							},
							validate = { enable = true },
						},
					},
				},
				texlab = {
					keys = {
						{ "<Leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex Docs", silent = true },
					},
				},
				ts_ls = {
					enabled = false,
				},
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = true,
								url = "https://www.schemastore.org/api/json/catalog.json",
							},
							schemas = {
								kubernetes = "*.yaml",
								["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
								["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
								["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/**/*.{yml,yaml}",
								["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
								["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
								["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
								["http://json.schemastore.org/circleciconfig"] = ".circleci/**/*.{yml,yaml}",
							},
							validate = true,
							completion = true,
							customTags = {
								"!Ref scalar",
								"!Sub scalar",
							},
						},
					},
				},
				eslint = {
					settings = {
						workingDirectories = { mode = "auto" },
					},
				},
				vtsls = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					settings = {
						complete_function_calls = true,
						vtsls = {
							enableMoveToFileCodeAction = true,
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
									entriesLimit = 40,
								},
							},
						},
						typescript = {
							tsserver = {
								maxTsServerMemory = 5120,
							},
							updateImportsOnFileMove = { enabled = "always" },
							suggest = {
								completeFunctionCalls = true,
							},
							inlayHints = {
								enumMemberValues = { enabled = true },
								functionLikeReturnTypes = { enabled = true },
								parameterNames = { enabled = "literals" },
								parameterTypes = { enabled = true },
								propertyDeclarationTypes = { enabled = true },
								variableTypes = { enabled = false },
							},
						},
					},
				},
			}

			local original_open_floating_preview = vim.lsp.util.open_floating_preview
			vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				return original_open_floating_preview(contents, syntax, opts, ...)
			end

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",

				-- Go tools
				"goimports",
				"gofumpt",
				"gomodifytags",
				"impl",
				"delve",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- Updated mason-lspconfig setup to use blink.cmp
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- Use blink.cmp's capabilities instead of the old nvim-cmp setup
						server.capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities)
						server.handlers = handlers
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
}

-- return {
--   { -- LSP Configuration & Plugins
--     'neovim/nvim-lspconfig',
--     event = { 'BufReadPre', 'BufNewFile' },
--     dependencies = {
--       -- Automatically install LSPs and related tools to stdpath for Neovim
--       {
--         'williamboman/mason.nvim',
--         keys = {
--           { '<leader>mm', '<cmd>Mason<CR>', desc = '[M]ason [M]enu' },
--           { '<leader>mu', '<cmd>MasonUpdate<CR>', desc = '[M]ason [U]pdate' },
--         },
--         config = function()
--           require('mason').setup {
--             ui = {
--               border = 'rounded', -- or "single", "double", "shadow", etc.
--             },
--           }
--         end,
--       },
--       'saghen/blink.cmp',
--       'williamboman/mason-lspconfig.nvim',
--       'WhoIsSethDaniel/mason-tool-installer.nvim',
--
--       -- Useful status updates for LSP.
--       -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
--       {
--         'j-hui/fidget.nvim',
--         opts = {
--           notification = {
--             -- Options related to the notification window and buffer
--             window = {
--               -- https://github.com/j-hui/fidget.nvim/issues/240
--               winblend = 0,
--               border = 'none', -- Border around the notification window
--               zindex = 45, -- Stacking priority of the notification window
--               max_width = 0, -- Maximum width of the notification window
--               max_height = 0, -- Maximum height of the notification window
--               x_padding = 1, -- Padding from right edge of window boundary
--               y_padding = 0, -- Padding from bottom edge of window boundary
--               align = 'bottom', -- How to align the notification window
--               relative = 'editor', -- What the notification window position is relative to
--             },
--           },
--         },
--       },
--
--       {
--         'folke/neoconf.nvim',
--         cmd = 'Neoconf',
--         opts = {},
--       },
--
--       -- {
--       --   'yioneko/nvim-vtsls',
--       --   config = function()
--       --     require('vtsls').config {
--       --       settings = {
--       --         vtsls = {
--       --           experimental = {
--       --             completion = {
--       --               enableServerSideFuzzyMatch = true,
--       --               entriesLimit = 100,
--       --             },
--       --           },
--       --         },
--       --         typescript = {
--       --           inlayHints = {
--       --             parameterNames = { enabled = 'literals' },
--       --             parameterTypes = { enabled = true },
--       --             variableTypes = { enabled = true },
--       --             propertyDeclarationTypes = { enabled = true },
--       --             functionLikeReturnTypes = { enabled = true },
--       --             enumMemberValues = { enabled = true },
--       --           },
--       --           tsserver = {
--       --             maxTsServerMemory = 5120,
--       --           },
--       --         },
--       --       },
--       --       -- customize handlers for commands
--       --       handlers = {
--       --         source_definition = function(err, locations) end,
--       --         file_references = function(err, locations) end,
--       --         code_action = function(err, actions) end,
--       --       },
--       --       -- automatically trigger renaming of extracted symbol
--       --       refactor_auto_rename = true,
--       --       refactor_move_to_file = {
--       --         -- If dressing.nvim is installed, telescope will be used for selection prompt. Use this to customize
--       --         -- the opts for telescope picker.
--       --         telescope_opts = function(items, default) end,
--       --       },
--       --     }
--       --
--       --     -- [[ Handler for codelens command ]]
--       --     vim.lsp.commands['editor.action.showReferences'] = function(command, ctx)
--       --       local locations = command.arguments[3]
--       --       local client = vim.lsp.get_client_by_id(ctx.client_id)
--       --       if locations and #locations > 0 then
--       --         local items = vim.lsp.util.locations_to_items(locations, client.offset_encoding)
--       --         vim.fn.setloclist(0, {}, ' ', { title = 'References', items = items, context = ctx })
--       --         vim.api.nvim_command 'lopen'
--       --       end
--       --     end
--       --   end,
--       -- },
--     },
--     config = function()
--       -- Brief aside: **What is LSP?**
--       --
--       -- LSP is an initialism you've probably heard, but might not understand what it is.
--       --
--       -- LSP stands for Language Server Protocol. It's a protocol that helps editors
--       -- and language tooling communicate in a standardized fashion.
--       --
--       -- In general, you have a "server" which is some tool built to understand a particular
--       -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
--       -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
--       -- processes that communicate with some "client" - in this case, Neovim!
--       --
--       -- LSP provides Neovim with features like:
--       --  - Go to definition
--       --  - Find references
--       --  - Autocompletion
--       --  - Symbol Search
--       --  - and more!
--       --
--       -- Thus, Language Servers are external tools that must be installed separately from
--       -- Neovim. This is where `mason` and related plugins come into play.
--       --
--       -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
--       -- and elegantly composed help section, `:help lsp-vs-treesitter`
--
--       --  This function gets run when an LSP attaches to a particular buffer.
--       --    That is to say, every time a new file is opened that is associated with
--       --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--       --    function will be executed to configure the current buffer
--       vim.api.nvim_create_autocmd('LspAttach', {
--         group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
--         callback = function(event)
--           -- NOTE: Remember that Lua is a real programming language, and as such it is possible
--           -- to define small helper and utility functions so you don't have to repeat yourself.
--           --
--           -- In this case, we create a function that lets us more easily define mappings specific
--           -- for LSP related items. It sets the mode, buffer and description for us each time.
--           local map = function(keys, func, desc)
--             vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
--           end
--
--           -- Jump to the definition of the word under your cursor.
--           --  This is where a variable was first declared, or where a function is defined, etc.
--           --  To jump back, press <C-t>.
--           map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
--
--           -- Find references for the word under your cursor.
--           map('gR', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--
--           -- Jump to the implementation of the word under your cursor.
--           --  Useful when your language has ways of declaring types without an actual implementation.
--           map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
--
--           -- Jump to the type of the word under your cursor.
--           --  Useful when you're not sure what type a variable is and you want to see
--           --  the definition of its *type*, not where it was *defined*.
--           map('<leader>ct', require('telescope.builtin').lsp_type_definitions, '[T]ype Definition')
--
--           -- Fuzzy find all the symbols in your current document.
--           --  Symbols are things like variables, functions, types, etc.
--           map('<leader>s,', require('custom.module.telescope-picker').prettyDocumentSymbols, '[S]earch Document Symbols')
--
--           -- Fuzzy find all the symbols in your current workspace.
--           --  Similar to document symbols, except searches over your entire project.
--           map('<leader>s;', require('custom.module.telescope-picker').prettyWorkspaceSymbols, '[S]earch Workspace Symbols')
--
--           -- Rename the variable under your cursor.
--           --  Most Language Servers support renaming across files, etc.
--           map('<leader>cr', vim.lsp.buf.rename, '[R]ename')
--
--           -- Execute a code action, usually your cursor needs to be on top of an error
--           -- or a suggestion from your LSP for this to activate.
--           map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
--
--           -- Opens a popup that displays documentation about the word under your cursor
--           --  See `:help K` for why this keymap.
--           map('K', vim.lsp.buf.hover, 'Hover Documentation')
--
--           -- WARN: This is not Goto Definition, this is Goto Declaration.
--           --  For example, in C this would take you to the header.
--           map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--
--           -- map('<leader>d', vim.diagnostic.open_float, 'Show [D]iagnostic')
--           map('<leader>xD', '<cmd>Telescope diagnostics bufnr=0<cr>', 'Buffer [D]iagnostic')
--
--           -- The following two autocommands are used to highlight references of the
--           -- word under your cursor when your cursor rests there for a little while.
--           --    See `:help CursorHold` for information about when this is executed
--           --
--           -- When you move your cursor, the highlights will be cleared (the second autocommand).
--
--           local client = vim.lsp.get_client_by_id(event.data.client_id)
--           if client and client.server_capabilities.documentHighlightProvider then
--             vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--               buffer = event.buf,
--               callback = vim.lsp.buf.document_highlight,
--             })
--
--             vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--               buffer = event.buf,
--               callback = vim.lsp.buf.clear_references,
--             })
--           end
--         end,
--       })
--
--       -- LSP servers and clients are able to communicate to each other what features they support.
--       --  By default, Neovim doesn't support everything that is in the LSP specification.
--       --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--       --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
--       local capabilities = vim.lsp.protocol.make_client_capabilities()
--       capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
--
--       -- Enable the following language servers
--       --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--       --
--       --  Add any additional override configuration in the following tables. Available keys are:
--       --  - cmd (table): Override the default command used to start the server
--       --  - filetypes (table): Override the default list of associated filetypes for the server
--       --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--       --  - settings (table): Override the default settings passed when initializing the server.
--       --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
--       local servers = {
--         -- clangd = {},
--         -- gopls = {},
--         -- pyright = {},
--         -- rust_analyzer = {},
--         -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
--         --
--         -- Some languages (like typescript) have entire language plugins that can be useful:
--         --    https://github.com/pmizio/typescript-tools.nvim
--         --
--         -- But for many setups, the LSP (`tsserver`) will work just fine
--         -- tsserver = {},
--         --
--
--         lua_ls = {
--           -- cmd = {...},
--           -- filetypes = { ...},
--           -- capabilities = {},
--           settings = {
--             Lua = {
--               completion = {
--                 callSnippet = 'Replace',
--               },
--               -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
--               -- diagnostics = { disable = { 'missing-fields' } },
--             },
--           },
--         },
--         -- I got this from Lazyvim
--         jsonls = {
--           -- lazy-load schemastore when needed
--           on_new_config = function(new_config)
--             new_config.settings.json.schemas = new_config.settings.json.schemas or {}
--             vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
--           end,
--           settings = {
--             json = {
--               format = {
--                 enable = true,
--               },
--               validate = { enable = true },
--             },
--           },
--         },
--         -- tailwindcss = {},
--         texlab = {
--           keys = {
--             { '<Leader>K', '<plug>(vimtex-doc-package)', desc = 'Vimtex Docs', silent = true },
--           },
--         },
--         ts_ls = {
--           enabled = false,
--         },
--         vtsls = {
--           -- explicitly add default filetypes, so that we can extend
--           -- them in related extras
--           filetypes = {
--             'javascript',
--             'javascriptreact',
--             'javascript.jsx',
--             'typescript',
--             'typescriptreact',
--             'typescript.tsx',
--           },
--           settings = {
--             complete_function_calls = true,
--             vtsls = {
--               enableMoveToFileCodeAction = true,
--               autoUseWorkspaceTsdk = true,
--               experimental = {
--                 completion = {
--                   enableServerSideFuzzyMatch = true,
--                   entriesLimit = 40,
--                 },
--               },
--             },
--             typescript = {
--               tsserver = {
--                 maxTsServerMemory = 5120,
--               },
--               updateImportsOnFileMove = { enabled = 'always' },
--               suggest = {
--                 completeFunctionCalls = true,
--               },
--               inlayHints = {
--                 enumMemberValues = { enabled = true },
--                 functionLikeReturnTypes = { enabled = true },
--                 parameterNames = { enabled = 'literals' },
--                 parameterTypes = { enabled = true },
--                 propertyDeclarationTypes = { enabled = true },
--                 variableTypes = { enabled = false },
--               },
--             },
--           },
--           -- I got this from Lazyvim
--           eslint = {
--             settings = {
--               -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
--               workingDirectories = { mode = 'auto' },
--             },
--           },
--         },
--       }
--
--       local original_open_floating_preview = vim.lsp.util.open_floating_preview
--       ---@diagnostic disable-next-line: duplicate-set-field
--       vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
--         opts = opts or {}
--         opts.border = opts.border or 'rounded' -- or "single", "double", "shadow", etc.
--         return original_open_floating_preview(contents, syntax, opts, ...)
--       end
--
--       -- Ensure the servers and tools above are installed
--       --  To check the current status of installed tools and/or manually install
--       --  other tools, you can run
--       --    :Mason
--       --
--       --  You can press `g?` for help in this menu.
--       require('mason').setup()
--
--       -- You can add other tools here that you want Mason to install
--       -- for you, so that they are available from within Neovim.
--       local ensure_installed = vim.tbl_keys(servers or {})
--       vim.list_extend(ensure_installed, {
--         'stylua', -- Used to format Lua code
--       })
--       require('mason-tool-installer').setup { ensure_installed = ensure_installed }
--
--       require('mason-lspconfig').setup {
--         handlers = {
--           function(server_name)
--             local server = servers[server_name] or {}
--             -- This handles overriding only values explicitly passed
--             -- by the server configuration above. Useful when disabling
--             -- certain features of an LSP (for example, turning off formatting for tsserver)
--             server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
--             server.handlers = handlers
--             require('lspconfig')[server_name].setup(server)
--           end,
--         },
--       }
--     end,
--   },
-- }

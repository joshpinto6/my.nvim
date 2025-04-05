-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{ import = "custom.plugins.core" },
	{ import = "custom.plugins.ui" }, -- The UI is important part. So it has to be first

	{ import = "custom.plugins.coding" },
	{ import = "custom.plugins.lang" },
	{ import = "custom.plugins.extras" },

	-- ---------------------------------------------------------------
	-- [Place here if you don't know where you will be put the plugin]
	-- ---------------------------------------------------------------
}

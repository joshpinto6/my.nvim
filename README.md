# My Text Editor/Terminal Config

### About:

At a high level, I use:
- Wezterm (for terminal management and in future as a partial tmux replacement)
- Neovim (accessed through wezterm) for editing code and text

#### Neovim Plugins (Lazy)

- Avante.nvim - AI chat/editing (GitHub copilot)
- Barbar.nvim - file tab bar
- Blink.cmp - LSP completion
- Comment.nvim - for (un)commenting lines
- conform.nvim - formatter (prettier)
- debugprint.nvim
- Dropbar.nvim - breadcrumbs
- git-blame.nvim - viewing blames
- gitsigns.nvim - git status indicators
- harpoon
- hop.nvim - movement
- icon-picker.nvim
- indent-blankline.nvim
- lua-json5.nvim - json editing
- lualine.nvim - statusline
- neogit
- neoscroll
- nvim-colorizer
- nvim-dap-ui
- nvim-hlslens
- nvim-lint - file linting (eslint)
- nvim-numbertoggle
- nvim-spectre
- nvim-ts-autotag
- otter.nvim
- outline.nvim
- telescope.nvim - searching
- toggleterm.nvim 
- toggleterm-manager - terminal ui
- tokyonight.nvim
- trouble.nvim
- ts-error-translator.nvim
- vim-sleuth
- vim-wakatime - time tracking

### Notes:

This config was based on kickstart.nvim by @nvim-lua.

A HUGE amount of this config is difrectly taken from @Alfarizi's config (bc i got frustrated with development slowdowns after making the switch from vscode) Over time, I hope that my config will diverge greatly.

Wezterm config inspiration from @vimichael

### Todo:

- [x] Make avante work
- [ ] Implement session management Neovim plugin
- [ ] Add wakatime to lualine

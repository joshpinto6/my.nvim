--NOTE: Fold
--WARNING: This makes editing kubernetes yaml file to have error.
-- Using the default fold method is enough for me.
return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  enabled = false,
  -- Not works using keys
  -- keys = {
  -- }
  opts = {
    provider_selector = function()
      return { 'lsp', 'indent' }
    end,
  },
  config = function(_, opts)
    require('ufo').setup(opts)

    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
    vim.keymap.set('n', 'zK', function()
      local winid = require('ufo').peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end, { desc = 'Peek fold' })
  end,
}

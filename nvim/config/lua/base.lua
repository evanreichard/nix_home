-- Disable NetRW
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set Term Colors
vim.opt.termguicolors = true

-- Synchronize with system clipboard
vim.opt.clipboard = "unnamed"

-- Always show the signcolumn
vim.opt.signcolumn = "yes"

-- Set nowrap, line numbers, hightlight search
vim.opt.wrap = false
vim.opt.nu = true
vim.opt.hlsearch = true
vim.opt.shiftwidth = 2

-- Set fold settings
vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 10
vim.opt.foldlevel = 2

-- Lightline config
vim.g['lightline'] = {
  colorscheme = 'embark',
  separator = {
    left = "\u{e0b0}",
    right = "\u{e0b2}"
  },
  subseparator = {
    left = "\u{e0b1}",
    right = "\u{e0b3}"
  }
}

-- Set Color Scheme
vim.cmd('colorscheme embark')
vim.diagnostic.config({
  virtual_text = false,
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

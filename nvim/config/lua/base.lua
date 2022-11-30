-- Set Leader
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

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

-- Set Color Scheme
-- vim.cmd('colorscheme embark')
-- vim.cmd('colorscheme OceanicNext')
-- vim.cmd('colorscheme material')
-- vim.g.material_style = "oceanic"

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

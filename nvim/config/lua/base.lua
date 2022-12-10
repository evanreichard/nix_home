-- Set Theme
vim.g.nord_borders = true
vim.g.nord_contrast = true
vim.cmd('colorscheme nord')

-- Set Leader
vim.keymap.set("n", "<Space>", "<Nop>", {silent = true})
vim.g.mapleader = " "

-- Set Timeout
vim.opt.timeoutlen = 250

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

-- Diagnostics Mappings
local diagnostics_active = true
local toggle_diagnostics = function()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end

local diagnostics_loclist_active = false
local toggle_diagnostics_loclist = function()
    diagnostics_loclist_active = not diagnostics_loclist_active
    if diagnostics_loclist_active then
        vim.diagnostic.setloclist()
    else
        vim.cmd('lclose')
    end
end

local opts = {noremap = true, silent = true}
vim.keymap.set('n', '<leader>qt', toggle_diagnostics, opts)
vim.keymap.set('n', '<leader>qN',
               function() vim.diagnostic.goto_prev({float = false}) end, opts)
vim.keymap.set('n', '<leader>qn',
               function() vim.diagnostic.goto_next({float = false}) end, opts)
vim.keymap.set('n', '<leader>qq', toggle_diagnostics_loclist, opts)
vim.keymap.set('n', '<leader>qe', vim.diagnostic.open_float, opts)

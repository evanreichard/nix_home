require("toggleterm").setup({open_mapping = [[<c-\>]]})

-- Duplicate C-w & Esc Behavior
function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.opt.signcolumn = "no"
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

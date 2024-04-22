require("toggleterm").setup({open_mapping = [[<c-\>]]})

-- Get PR status on terminal load
-- require("toggleterm").setup({
--     open_mapping = [[<c-\>]],
--     on_create = function(term)
--         vim.cmd("startinsert")
--         term:send("gh pr checks")
--     end
-- })

-- Duplicate C-w & Esc Behavior
function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.opt.signcolumn = "no"
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

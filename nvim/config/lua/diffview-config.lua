vim.keymap.set('n', '<leader>go', '<cmd>DiffviewOpen<CR>')
vim.keymap.set('n', '<leader>gO', '<cmd>DiffviewOpen origin/main...HEAD<CR>')
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>')
vim.keymap.set('n', '<leader>gH',
               '<cmd>DiffviewFileHistory --range=origin..HEAD<CR>')
vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<CR>')

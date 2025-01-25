local silicon = require('silicon')
silicon.setup({})

vim.keymap.set('v', '<Leader>ss', function() silicon.visualise_api({}) end)
vim.keymap.set('v', '<Leader>sb',
               function() silicon.visualise_api({show_buf = true}) end)
vim.keymap.set('n', '<Leader>sv',
               function() silicon.visualise_api({visible = true}) end)
vim.keymap.set('n', '<Leader>sb',
               function() silicon.visualise_api({show_buf = true}) end)

require('gitsigns').setup {
    on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<leader>gb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>gB', function()
            gitsigns.blame_line {full = true}
        end)
    end
}

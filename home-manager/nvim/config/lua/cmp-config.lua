local cmp = require('cmp')
require("luasnip.loaders.from_vscode").lazy_load()

-- Check Tab Completion
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match("%s") == nil
end

cmp.setup({
    snippet = {
        expand = function(args) require'luasnip'.lsp_expand(args.body) end
    },

    mapping = cmp.mapping.preset.insert({

        -- Tab Completion
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, {"i", "s"}),

        -- Reverse Tab Completion
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, {"i", "s"}),

        -- Misc Mappings
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({select = true})

    }),

    -- Default Sources
    sources = cmp.config.sources({
        {name = 'nvim_lsp'}, {name = 'luasnip'}, {name = 'path'},
        {name = 'buffer'}
    })

})

-- Completion - `/` and `?`
cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{name = 'buffer'}}
})

-- Completion = `:`
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{name = 'path'}, {name = 'cmdline'}})
})

-- Autopairs
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

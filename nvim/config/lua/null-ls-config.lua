local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.nixpkgs_fmt,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.prettier.with({
            filetypes = {"json", "yaml", "markdown"}
        }), null_ls.builtins.diagnostics.sqlfluff
            .with({extra_args = {"--dialect", "ansi"}}),
        null_ls.builtins.formatting.sqlfluff
            .with({extra_args = {"--dialect", "ansi"}})
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({async = true})
                end
            })
        end
    end
})

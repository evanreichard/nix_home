------------------------------------------------------
-------------------- Built-in LSP --------------------
------------------------------------------------------
local nix_vars = require("nix-vars")
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    local bufopts = {noremap = true, silent = true, buffer = bufnr}
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', '<leader>ld', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>lf',
                   function() vim.lsp.buf.format {async = true} end, bufopts)
end

local on_attach_no_formatting = function(client, bufnr)
    -- Disable Formatting (Prettiers Job - null-ls)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
end

-- Define LSP Flags & Capabilities
local lsp_flags = {debounce_text_changes = 150}
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Python LSP Configuration
nvim_lsp.pyright.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
}

-- HTML LSP Configuration
nvim_lsp.html.setup {
    on_attach = on_attach_no_formatting,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.vscodels .. "/bin/vscode-html-language-server", "--stdio"}
}

-- JSON LSP Configuration
nvim_lsp.jsonls.setup {
    on_attach = on_attach_no_formatting,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.vscodels .. "/bin/vscode-json-language-server", "--stdio"}
}

-- CSS LSP Configuration
nvim_lsp.cssls.setup {
    on_attach = on_attach_no_formatting,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.vscodels .. "/bin/vscode-css-language-server", "--stdio"}
}

-- Typescript / Javascript LSP Configuration
nvim_lsp.tsserver.setup {
    on_attach = on_attach_no_formatting,
    flags = lsp_flags,
    handlers = {
        -- Disable Diagnostics (ESLints Job)
        ["textDocument/publishDiagnostics"] = function() end
    },
    capabilities = capabilities,
    cmd = {nix_vars.tsserver, "--stdio", "--tsserver-path", nix_vars.tslib}
}

-- Javascript / Typescript LSP Configuration
nvim_lsp.eslint.setup {
    on_attach = on_attach_no_formatting,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.vscodels .. "/bin/vscode-eslint-language-server", "--stdio"}
}

------------------------------------------------------
--------------------- Null-LS LSP --------------------
------------------------------------------------------
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.nixpkgs_fmt,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.diagnostics.sqlfluff
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

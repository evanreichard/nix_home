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
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.htmlserver, "--stdio"}
}

-- Typescript / Javascript LSP Configuration
nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.tsserver, "--stdio", "--tsserver-path", nix_vars.tslib}
}

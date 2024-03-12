------------------------------------------------------
-------------------- Built-in LSP --------------------
------------------------------------------------------
local nix_vars = require("nix-vars")
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    local bufopts = {noremap = true, silent = true, buffer = bufnr}

    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({async = false}) end
        })
    end

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
    -- Disable Formatting
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
end

local organize_go_imports = function()
    local encoding = vim.lsp.util._get_offset_encoding()
    local params = vim.lsp.util.make_range_params(nil, encoding)
    params.context = {only = {"source.organizeImports"}}

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction",
                                            params, 3000)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, encoding)
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
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
    cmd = {nix_vars.vscls .. "/bin/vscode-html-language-server", "--stdio"}
}

-- JSON LSP Configuration
nvim_lsp.jsonls.setup {
    on_attach = on_attach_no_formatting,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.vscls .. "/bin/vscode-html-language-server", "--stdio"}
}

-- CSS LSP Configuration
nvim_lsp.cssls.setup {
    on_attach = on_attach_no_formatting,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.vscls .. "/bin/vscode-html-language-server", "--stdio"}
}

-- Typescript / Javascript LSP Configuration
nvim_lsp.tsserver.setup {
    on_attach = on_attach_no_formatting,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.tsls, "--stdio"}
}

-- Svelte LSP Configuration
nvim_lsp.svelte.setup {
    on_attach = on_attach_no_formatting,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.sveltels, "--stdio"}
}

-- Go LSP Configuration
nvim_lsp.gopls.setup {
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = organize_go_imports
        })
    end,
    flags = lsp_flags,
    capabilities = capabilities,
    cmd = {nix_vars.gopls}
}

------------------------------------------------------
--------------------- Null-LS LSP --------------------
------------------------------------------------------
local null_ls = require("null-ls")

local function has_file_in_parents(current_dir, file_pattern)
    -- Check if directory has file pattern
    local function has_file(dir)
        local handle = vim.loop.fs_scandir(dir)
        if handle then
            while true do
                local name, type = vim.loop.fs_scandir_next(handle)
                if not name then break end
                if type == "file" and name:match(file_pattern) then
                    return true
                end
            end
        end
        return false
    end

    -- Continously walk upwards
    while true do
        if has_file(current_dir) then return true end
        local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
        if parent_dir == current_dir then break end
        current_dir = parent_dir
    end

    -- No match found
    return false
end

null_ls.setup({
    sources = {
        -- Prettier Formatting
        null_ls.builtins.formatting.prettier.with({
            condition = function(utils)
                return not has_file_in_parents(vim.fn.getcwd(), "^%.eslintrc%.")
            end
        }), -- ESLint Diagnostics & Formatting
        null_ls.builtins.diagnostics.eslint_d.with({
            condition = function(utils)
                return has_file_in_parents(vim.fn.getcwd(), "^%.eslintrc%.")
            end
        }), null_ls.builtins.formatting.eslint_d.with({
            condition = function(utils)
                return has_file_in_parents(vim.fn.getcwd(), "^%.eslintrc%.")
            end
        }), null_ls.builtins.formatting.djlint.with({filetypes = {"template"}}),
        null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.nixpkgs_fmt,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.diagnostics.sqlfluff,
        null_ls.builtins.formatting.sqlfluff
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({async = false})
                end
            })
        end
    end
})

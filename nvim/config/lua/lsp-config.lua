------------------------------------------------------
------------------- Custom Settings ------------------
------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	callback = function()
		vim.bo.textwidth = 120
	end,
})

------------------------------------------------------
-------------------- Built-in LSP --------------------
------------------------------------------------------
local nix_vars = require("nix-vars")
local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
			end,
		})
	end

	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "<leader>lf", function()
		vim.lsp.buf.format({ async = true, timeout_ms = 2000 })
	end, bufopts)
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
	params.context = { only = { "source.organizeImports" } }

	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
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
local lsp_flags = { debounce_text_changes = 150 }
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Python LSP Configuration
nvim_lsp.pyright.setup({
	on_attach = on_attach,
	flags = lsp_flags,
	capabilities = capabilities,
})

-- HTML LSP Configuration
nvim_lsp.html.setup({
	on_attach = on_attach_no_formatting,
	flags = lsp_flags,
	capabilities = capabilities,
	cmd = { nix_vars.vscls .. "/bin/vscode-html-language-server", "--stdio" },
})

-- JSON LSP Configuration
nvim_lsp.jsonls.setup({
	on_attach = on_attach_no_formatting,
	flags = lsp_flags,
	capabilities = capabilities,
	cmd = { nix_vars.vscls .. "/bin/vscode-html-language-server", "--stdio" },
})

-- CSS LSP Configuration
nvim_lsp.cssls.setup({
	on_attach = on_attach_no_formatting,
	flags = lsp_flags,
	capabilities = capabilities,
	cmd = { nix_vars.vscls .. "/bin/vscode-html-language-server", "--stdio" },
})

-- Typescript / Javascript LSP Configuration
nvim_lsp.tsserver.setup({
	on_attach = on_attach_no_formatting,
	flags = lsp_flags,
	capabilities = capabilities,
	cmd = { nix_vars.tsls, "--stdio" },
})

-- Svelte LSP Configuration
nvim_lsp.svelte.setup({
	on_attach = on_attach_no_formatting,
	flags = lsp_flags,
	capabilities = capabilities,
	cmd = { nix_vars.sveltels, "--stdio" },
})

-- Lua LSP Configuration
nvim_lsp.lua_ls.setup({
	on_attach = on_attach_no_formatting,
	flags = lsp_flags,
	capabilities = capabilities,
	cmd = { nix_vars.luals },
})

-- Go LSP Configuration
nvim_lsp.gopls.setup({
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = organize_go_imports,
		})
	end,
	flags = lsp_flags,
	capabilities = capabilities,
	cmd = { nix_vars.gopls },
})

-- Go LSP Linting
nvim_lsp.golangci_lint_ls.setup({
	on_attach = on_attach_no_formatting,
	flags = lsp_flags,
	capabilities = capabilities,
	cmd = { nix_vars.golintls },
	init_options = {
		command = {
			"golangci-lint",
			"run",
			"--out-format",
			"json",
			"--issues-exit-code=1",
		},
	},
})

------------------------------------------------------
--------------------- Null-LS LSP --------------------
------------------------------------------------------
local null_ls = require("null-ls")

local eslintFiles = {
	".eslintrc",
	".eslintrc.js",
	".eslintrc.cjs",
	".eslintrc.yaml",
	".eslintrc.yml",
	".eslintrc.json",
	"eslint.config.js",
	"eslint.config.mjs",
	"eslint.config.cjs",
	"eslint.config.ts",
	"eslint.config.mts",
	"eslint.config.cts",
}

has_eslint_in_parents = function(fname)
	root_file = nvim_lsp.util.insert_package_json(eslintFiles, "eslintConfig", fname)
	return nvim_lsp.util.root_pattern(unpack(root_file))(fname)
end

null_ls.setup({
	sources = {
		-- Prettier Formatting
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.prettier.with({ filetypes = { "template" } }),
		require("none-ls.diagnostics.eslint_d").with({
			condition = function(utils)
				return has_eslint_in_parents(vim.fn.getcwd())
			end,
		}),
		null_ls.builtins.completion.spell,
		null_ls.builtins.formatting.nixpkgs_fmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.sqlfluff,
		null_ls.builtins.formatting.sqlfluff,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
				end,
			})
		end
	end,
})

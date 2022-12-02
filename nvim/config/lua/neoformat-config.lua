vim.g.neoformat_sql_sqlformat = {
  exe = "sqlformat",
  args = { "--reindent", "-k", "upper", "-" },
  stdin = 1
}

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.sql" },
    command = "Neoformat",
})

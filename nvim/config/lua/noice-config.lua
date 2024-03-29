-- Noice Doc Scrolling
vim.keymap.set("n", "<c-f>", function()
    if not require("noice.lsp").scroll(4) then return "<c-f>" end
end, {silent = true, expr = true})

vim.keymap.set("n", "<c-b>", function()
    if not require("noice.lsp").scroll(-4) then return "<c-b>" end
end, {silent = true, expr = true})

-- Noice Setup
require("noice").setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = false
        },
        signature = {enabled = false}
    },
    presets = {
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false -- add a border to hover docs and signature help
    }
})

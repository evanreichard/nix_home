require("neo-tree").setup({ window = { mappings = { ["<space>"] = "none" } } })
vim.keymap.set("n", "<leader>t", ":Neotree toggle<CR>", { silent = true })

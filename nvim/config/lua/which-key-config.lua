local wk = require("which-key")

wk.setup({})

wk.register({
    K = {"Definition Hover"},
    ["<C-k>"] = {"Signature Help"},
    ["<leader>"] = {
        q = {"Show Diagnostics"},
        e = {"Show Line Diagnostics"},
        f = {
            name = "Find - Telescope",
            f = {"<cmd>Telescope find_files<cr>", "Find File"},
            g = {"<cmd>Telescope live_grep<cr>", "Live Grep"},
            b = {"<cmd>Telescope buffers<cr>", "Find Buffer"},
            h = {"<cmd>Telescope help_tags<cr>", "Help Tags"}
        },
        l = {
            name = "LSP",
            D = {"Declaration"},
            d = {"Definition"},
            f = {"Format"},
            i = {"Implementation"},
            n = {"Rename"},
            r = {"References"},
            t = {"Type Definition"}
        },
        s = {
            name = "Screenshot",
            mode = {'v', 'n'},
            b = {"Buffer Screenshot", mode = {'v', 'n'}},
            s = {"Selected Screenshot", mode = 'v'},
            v = {"Visual Screenshot", mode = 'n'}
        }
    }
})

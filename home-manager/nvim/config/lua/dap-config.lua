local dap = require("dap")
local dapui = require("dapui")
local dapgo = require("dap-go")

dapui.setup({
    controls = {
        element = "repl",
        enabled = true,
        icons = {
            disconnect = "",
            pause = "",
            play = "",
            run_last = "",
            step_back = "",
            step_into = "",
            step_out = "",
            step_over = "",
            terminate = ""
        }
    },
    element_mappings = {},
    expand_lines = false,
    floating = {border = "single", mappings = {close = {"q", "<Esc>"}}},
    force_buffers = true,
    icons = {collapsed = "", current_frame = "", expanded = ""},
    layouts = {
        {
            elements = {{id = "repl", size = 0.5}, {id = "scopes", size = 0.5}},
            position = "bottom",
            size = 10
        }, {
            elements = {
                {id = "breakpoints", size = 0.5}, {id = "stacks", size = 0.5}
            },
            position = "left",
            size = 40
        }
    },
    mappings = {
        edit = "e",
        expand = {"<CR>", "<2-LeftMouse>"},
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
    },
    render = {indent = 1, max_value_lines = 100}
})
dapgo.setup()

-- Auto Open UI
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end

-- Continue Hotkey ("c")
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    callback = function()
        vim.api.nvim_buf_set_keymap(0, 'n', 'c',
                                    "<cmd>lua require'dap'.continue()<CR>",
                                    {noremap = true, silent = true})
    end
})

-- Leader Keys
local opts = {noremap = true, silent = true}
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<leader>du', dapui.toggle, opts)
vim.keymap.set('n', '<leader>dc', dap.continue, opts)
vim.keymap.set('n', '<leader>dt', dapgo.debug_test, opts)

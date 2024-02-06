local dap = require("dap")
local dapui = require("dapui")
local dapgo = require("dap-go")

dapui.setup()
dapgo.setup()

-- Auto Open UI
dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config =
    function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

-- Leader Keys
local opts = {noremap = true, silent = true}
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<leader>du', dapui.toggle, opts)
vim.keymap.set('n', '<leader>dc', dap.continue, opts)
vim.keymap.set('n', '<leader>dt', dapgo.debug_test, opts)

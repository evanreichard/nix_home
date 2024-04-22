-- Cached variable
local cached_pr_status = ""

-- Read process output
local function read_output(err, data)
    if err then return end
    if not data then return end
    cached_pr_status = data
end

-- Spawn process
local function execute_command()
    local stdout = vim.loop.new_pipe(false)

    local spawn_opts = {
        detached = true,
        stdio = {nil, stdout, nil},
        args = {"-c", "gh pr checks | awk '{ print $2 }'"}
    }

    vim.loop.spawn("bash", spawn_opts,
                   function() stdout:read_start(read_output) end)
end

-- Spawn & schedule process
execute_command()
vim.fn.timer_start(300000, execute_command)

-- Return status from cache
function pr_status()
    --   
    --   
    --
    -- PENDING COLOR - #d29922
    -- PASS COLOR - #3fb950
    -- FAIL COLOR - #f85149
    return cached_pr_status:gsub("\n", ""):gsub("fail", " "):gsub("pass",
                                                                     " ")
               :gsub("pending", " "):sub(1, -2)
end

require('lualine').setup({
    options = {
        theme = "gruvbox_dark"
        -- theme = "nord"
        -- theme = "OceanicNext",
    },
    sections = {lualine_c = {{pr_status}}}
})

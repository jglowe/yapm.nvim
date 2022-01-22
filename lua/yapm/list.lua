--------------------------------------------------------------------------------
--
--                         _ _     _     _
--                        | (_)   | |   | |
--                        | |_ ___| |_  | |_   _  __ _
--                        | | / __| __| | | | | |/ _` |
--                        | | \__ \ |_ _| | |_| | (_| |
--                        |_|_|___/\__(_)_|\__,_|\__,_|
--
-- Jonathan Lowe
-- github : https://github.com/jglowe
-- figlet font : big
--
-- List the plugins that are loaded in a popup gui
--------------------------------------------------------------------------------

local state = require("yapm.state")

local close_popup = function()
    pcall(vim.api.nvim_win_close, state.get_popup_id(), true)
    state.set_popup_id(nil)
    state.set_popup_opts(nil)
end

local open_popup = function()

    local plugin_list = state.get_loaded_plugins()

    table.insert(plugin_list, 1, "Installed Plugins")
    table.insert(plugin_list, 2, "")

    local bufnr = vim.api.nvim_create_buf(false, true)
    assert(bufnr, "Failed to create buffer")
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, plugin_list)

    local window_options = {}
    window_options.relative = "editor"
    window_options.style = "minimal"
    window_options.width = 30
    window_options.height = 30
    window_options.col = math.floor((vim.o.columns - window_options.width) / 2)
    window_options.row = math.floor((vim.o.lines - window_options.height) / 2)

    local popup_id = vim.api.nvim_open_win(bufnr, false, window_options)
    state.set_popup_id(popup_id)
    -- state.set_popup_opts(popup_opts)

    print(popup_id)

    vim.cmd(
        "autocmd BufLeave <buffer> ++once lua pcall(vim.api.nvim_win_close, require('yapm.state').get_popup_id(), true)")
    -- vim.cmd(
    --     "autocmd BufLeave <buffer> ++once lua pcall(vim.api.nvim_win_close, require('yapm.state').get_popup_opts().border.win_id, true)")
end

return {open_popup = open_popup, close_popup = close_popup}


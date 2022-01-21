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
local load_plugin = require("yapm.load")
local state = require("yapm.state")

load_plugin("plenary.nvim")

local close_popup = function()
    pcall(vim.api.nvim_win_close, state.get_popup_id(), true)
    state.set_popup_id(nil)
    state.set_popup_opts(nil)
end

local open_popup = function()
    local plugin_list = state.get_loaded_plugins()

    table.insert(plugin_list, 1, "Installed Plugins")
    table.insert(plugin_list, 2, "")

    local popup = require("plenary.popup")
    local popup_id, popup_opts = popup.create(plugin_list, {
        border = true,
        padding = {0, 3, 0, 3}
    })

    state.set_popup_id(popup_id)
    state.set_popup_opts(popup_opts)

    print(popup_id)

    vim.cmd(
        "autocmd BufLeave <buffer> ++once lua pcall(vim.api.nvim_win_close, require('yapm.state').get_popup_id(), true)")
    vim.cmd(
        "autocmd BufLeave <buffer> ++once lua pcall(vim.api.nvim_win_close, require('yapm.state').get_popup_opts().border.win_id, true)")
end

return {open_popup = open_popup, close_popup = close_popup}


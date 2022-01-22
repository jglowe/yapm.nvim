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
end

local open_popup = function()

    local plugin_list = state.get_loaded_plugins()
    local popup_width = math.floor(vim.fn.winwidth(0) * .8)
    local max_plugin_length = 0

    for _, plugin in pairs(plugin_list) do
        if max_plugin_length < string.len(plugin) then
            max_plugin_length = plugin:len()
        end
    end

    local lines_to_show = {}
    table.insert(lines_to_show, "")
    -- Roughly Center the title
    table.insert(lines_to_show,
                 string.rep(" ", math.floor(popup_width / 2) - 8) ..
                     "Installed Plugins")
    table.insert(lines_to_show, "")
    table.insert(lines_to_show, "")
    local current_line = ""

    -- Format the plugins to fit within the window width
    for _, plugin in pairs(plugin_list) do
        if current_line:len() + 1 + max_plugin_length + 1 < popup_width then
            current_line = current_line .. " " .. plugin ..
                               string.rep(" ", max_plugin_length - plugin:len())
        else
            -- Remove the trailing whitespace as the popup width takes care of
            -- sizing the popup
            current_line = current_line:gsub("%s-$", "")
            table.insert(lines_to_show, current_line)
            current_line = ""
        end
    end

    table.insert(lines_to_show, current_line)
    table.insert(lines_to_show, "")

    local bufnr = vim.api.nvim_create_buf(false, true)
    assert(bufnr, "Failed to create buffer")
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines_to_show)

    local window_options = {}
    window_options.relative = "editor"
    window_options.style = "minimal"
    window_options.width = popup_width
    window_options.height = #lines_to_show
    window_options.col = math.floor(
                             (vim.fn.winwidth(0) - window_options.width) / 2)
    window_options.row = math.floor(
                             (vim.fn.winheight(0) - window_options.height) / 2)
    window_options.border = "single"

    local popup_id = vim.api.nvim_open_win(bufnr, false, window_options)
    state.set_popup_id(popup_id)
    -- state.set_popup_opts(popup_opts)

    print(popup_id)
    vim.api.nvim_set_current_win(popup_id)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<esc>",
                                ":lua require('yapm.list').close_popup()<cr>",
                                {noremap = true})

    vim.cmd(
        "autocmd BufLeave <buffer> ++once lua pcall(vim.api.nvim_win_close, require('yapm.state').get_popup_id(), true)")
end

return {open_popup = open_popup, close_popup = close_popup}


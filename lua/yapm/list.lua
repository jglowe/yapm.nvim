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
local popup = require("yapm.popup")

local popup_contents = function()
    local plugin_list = state.get_loaded_plugins()
    local popup_width = math.floor(vim.opt.columns:get() * .8)
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

    return lines_to_show
end

local list = function() popup.open(popup_contents) end

return list


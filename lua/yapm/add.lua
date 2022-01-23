--------------------------------------------------------------------------------
--
--                                _     _   _
--                               | |   | | | |
--                       __ _  __| | __| | | |_   _  __ _
--                      / _` |/ _` |/ _` | | | | | |/ _` |
--                     | (_| | (_| | (_| |_| | |_| | (_| |
--                      \__,_|\__,_|\__,_(_)_|\__,_|\__,_|
--
-- Jonathan Lowe
-- github : https://github.com/jglowe
-- figlet font : big
--
-- Adds a plugin via git
--------------------------------------------------------------------------------
local state = require("yapm.state")
local popup = require("yapm.popup")

local add = function(plugin)
    local settings = state.get_settings()
    local slash_index = string.find(plugin, "/")
    local plugin_name = string.sub(plugin, slash_index + 1, string.len(plugin))
    local plugin_destination = settings.plugin_path .. "/" .. plugin_name

    if vim.fn.isdirectory(settings.repo_path .. "/" .. plugin_destination) == 0 then
        local git_executable = settings.git.executable
        local git_options = settings.git.add.options
        local repo_path = settings.repo_path
        local plugin_url = "https://github.com/" .. plugin .. ".git"

        local shell_command = "cd " .. repo_path .. "; " .. git_executable ..
                                  " " .. git_options .. " submodule add --name " ..
                                  plugin_name .. " " .. plugin_url .. " " ..
                                  plugin_destination .. " 2>&1"
        local output = vim.fn.systemlist(shell_command)

        local content_function = function()
            local lines = {"", " Loading Plugin " .. plugin_name, ""}
            for _, line in pairs(output) do
                table.insert(lines, " " .. line)
            end
            table.insert(lines, "")
            table.insert(lines, " Finished")
            table.insert(lines, "")
            return lines
        end

        if state.get_popup_id() ~= nil then
            local current_lines = state.get_content_function()()
            for _, line in pairs(content_function()) do
                table.insert(current_lines, line)
            end
            local fn = function()
                return current_lines
            end
            popup.close()
            popup.open(fn)
        else
            popup.open(content_function)
        end
    else
        local content_functon = function()
            return {"", " Plugin " .. plugin_name .. " is already there", ""}
        end
        popup.open(content_functon)
    end
end

return add

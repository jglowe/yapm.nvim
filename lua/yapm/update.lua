--------------------------------------------------------------------------------
--
--                               _       _         _
--                              | |     | |       | |
--               _   _ _ __   __| | __ _| |_ ___  | |_   _  __ _
--              | | | | '_ \ / _` |/ _` | __/ _ \ | | | | |/ _` |
--              | |_| | |_) | (_| | (_| | ||  __/_| | |_| | (_| |
--               \__,_| .__/ \__,_|\__,_|\__\___(_)_|\__,_|\__,_|
--                    | |
--                    |_|
--
-- Jonathan Lowe
-- github : https://github.com/jglowe
-- figlet font : big
--
-- This file contains the functions needed to update the plugins
--------------------------------------------------------------------------------
local update = function(name)
    local plugins_folder = vim.fn.stdpath("config") .. "/pack/all/opt/"
    local settings = require("yapm.state").get_settings()
    local to_update = {}

    if name == nil then
        local ls_output = vim.fn.system("ls " .. plugins_folder)

        for str in string.gmatch(ls_output, "([^\n]+)") do
            table.insert(to_update, str)
        end

        print(vim.inspect(to_update))
    else

        local slash_index = string.find(name, "/")
        local plugin_name = string.sub(name, slash_index + 1, string.len(name))
        to_update = {plugin_name}
    end

    for _, plugin in pairs(to_update) do
        local plugin_folder = plugins_folder .. "/" .. plugin
        local git_executable = settings.git.executable
        local git_options = settings.git.update.options
        local git_command = settings.git.update.command
        local output = vim.fn.system("pushd " .. plugin_folder .. "; " ..
                                         git_executable .. " " .. git_options ..
                                         " " .. git_command .. "; popd")

        print(output)

    end
end

return update

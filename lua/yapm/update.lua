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
local state = require("yapm.state")
local popup = require("yapm.popup")

local update = function(name)
    local plugins_folder = vim.fn.stdpath("config") .. "/pack/all/opt/"
    local settings = state.get_settings()
    local to_update = {}

    if name == nil then
        local ls_output = vim.fn.system("ls " .. plugins_folder)

        for str in string.gmatch(ls_output, "([^\n]+)") do
            table.insert(to_update, str)
        end
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
        local output = vim.fn.systemlist(
                           "cd " .. plugin_folder .. "; " .. git_executable ..
                               " " .. git_options .. " " .. git_command)

        table.insert(output, 1, "Updating " .. plugin)
        table.insert(output, 2, "")

        if state.get_popup_id() == nil then
            local content_function = function() return output end
            popup.open(content_function)
        else
            local bufnr = vim.api.nvim_win_get_buf(state.get_popup_id())
            local current_lines = vim.api
                                      .nvim_buf_get_lines(bufnr, 0, -1, false)

            for _, line in pairs(output) do
                table.insert(current_lines, line)
            end

            local window_height
            if math.floor(vim.opt.lines:get() * .8) < #current_lines then
                window_height = math.floor(vim.opt.lines:get() * .8)
            else
                window_height = #current_lines
            end
            local content_function = function() return current_lines end
            -- vim.api.nvim_win_set_config(state.get_popup_id(), {
            --     row = math.floor((vim.opt.lines:get() - window_height) / 2)
            -- })
            vim.api.nvim_win_set_height(state.get_popup_id(), window_height)
            state.set_content_function(content_function)
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, current_lines)
        end
    end
end

return update

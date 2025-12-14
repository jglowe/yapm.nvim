--------------------------------------------------------------------------------
--
--                     _                 _   _
--                    | |               | | | |
--                    | | ___   __ _  __| | | |_   _  __ _
--                    | |/ _ \ / _` |/ _` | | | | | |/ _` |
--                    | | (_) | (_| | (_| |_| | |_| | (_| |
--                    |_|\___/ \__,_|\__,_(_)_|\__,_|\__,_|
--
-- Jonathan Lowe
-- github : https://github.com/jglowe
-- figlet font : big
--
-- The function to load plugins
--------------------------------------------------------------------------------

local add = require("yapm.add")
local state = require("yapm.state")

local load_plugin = function(plugin)
    if vim.v.vim_did_enter == 1 then
        -- Adds the optional plugin to the runtime path and sources it now
        vim.cmd.packadd(plugin)
    else
        -- Adds the optional plugin to the runtime path and sources it later as
        -- a part of the startup process
        vim.cmd.packadd(plugin)
    end
end

local load = function(plugin)

    -- Support both github_user/plugin_name and plugin_name
    local slash_index = string.find(plugin, "/")
    local plugin_name
    if slash_index ~= nil then
        plugin_name = string.sub(plugin, slash_index + 1, string.len(plugin))
    else
        plugin_name = plugin
    end

    local settings = state.get_settings()

    -- If enabled and the plugin name inclues the git user/path, it will add
    -- newly specified plugins via the add function
    if settings.add_new_plugins and slash_index ~= nil then
        local plugin_folder = settings.repo_path .. "/" ..
                                  settings.plugin_path .. "/" ..
                                  plugin_name
        if vim.fn.isdirectory(plugin_folder) == 0 then add(plugin) end
    end

    -- keep track of the plugins that are loaded and prevent them from being
    -- loaded twice
    if not state.is_plugin_loaded(plugin_name) then
        load_plugin(plugin_name)
        state.add_loaded_plugin(plugin_name)
    end
end

return load

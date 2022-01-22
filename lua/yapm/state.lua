--------------------------------------------------------------------------------
--
--                         _        _         _
--                        | |      | |       | |
--                     ___| |_ __ _| |_ ___  | |_   _  __ _
--                    / __| __/ _` | __/ _ \ | | | | |/ _` |
--                    \__ \ || (_| | ||  __/_| | |_| | (_| |
--                    |___/\__\__,_|\__\___(_)_|\__,_|\__,_|
--
-- Jonathan Lowe
-- github : https://github.com/jglowe
-- figlet font : bit
--
-- This file contains the global state variable for the plugin as well as
-- functions for manipulating it.
--------------------------------------------------------------------------------

_G.plugin__state = {}

local get_settings = function()
    return _G.plugin__state["settings"]
end

local set_settings = function(settings)
    _G.plugin__state["settings"] = settings
end

local get_loaded_plugins = function()
    if _G.plugin__state["loaded_plugins"] == nil then
        return {}
    else
        local plugin_list = {}
        for plugin, loaded in pairs(_G.plugin__state["loaded_plugins"]) do
            if loaded then table.insert(plugin_list, plugin) end
        end
        table.sort(plugin_list)
        return plugin_list
    end
end

local is_plugin_loaded = function(plugin)
    if _G.plugin__state["loaded_plugins"] == nil then
        return false
    else
        if _G.plugin__state["loaded_plugins"][plugin] == nil then
            return false
        else
            return _G.plugin__state["loaded_plugins"][plugin]
        end
    end
end

local add_loaded_plugin = function(plugin)
    if _G.plugin__state["loaded_plugins"] == nil then
        _G.plugin__state["loaded_plugins"] = {}
        _G.plugin__state["loaded_plugins"][plugin] = true
    else
        if _G.plugin__state["loaded_plugins"][plugin] == nil or
            _G.plugin__state["loaded_plugins"][plugin] == false then

            _G.plugin__state["loaded_plugins"][plugin] = true
        end
    end
end

local get_popup_id = function()
    return _G.plugin__state["popup_id"]
end

local set_popup_id = function(popup_id)
    _G.plugin__state["popup_id"] = popup_id
end

local state = {
    get_settings = get_settings,
    set_settings = set_settings,
    get_loaded_plugins = get_loaded_plugins,
    is_plugin_loaded = is_plugin_loaded,
    add_loaded_plugin = add_loaded_plugin,
    get_popup_id = get_popup_id,
    set_popup_id = set_popup_id,
}

return state

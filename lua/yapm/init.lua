--------------------------------------------------------------------------------
--
--                        _       _ _     _
--                       (_)     (_) |   | |
--                        _ _ __  _| |_  | |_   _  __ _
--                       | | '_ \| | __| | | | | |/ _` |
--                       | | | | | | |_ _| | |_| | (_| |
--                       |_|_| |_|_|\__(_)_|\__,_|\__,_|
--
-- Jonathan Lowe
-- github : https://github.com/jglowe
-- figlet font : big
--
-- The plugin module assembly
--------------------------------------------------------------------------------

local M = {}

M.add = require("yapm.add")
M.list = require("yapm.list")
M.load = require("yapm.load")
M.setup = require("yapm.setup")
M.state = require("yapm.state")
M.update = require("yapm.update")

return M

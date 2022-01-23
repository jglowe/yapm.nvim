--------------------------------------------------------------------------------
--
--                                                _
--                                               | |
--                 _ __   ___  _ __  _   _ _ __  | |_   _  __ _
--                | '_ \ / _ \| '_ \| | | | '_ \ | | | | |/ _` |
--                | |_) | (_) | |_) | |_| | |_) || | |_| | (_| |
--                | .__/ \___/| .__/ \__,_| .__(_)_|\__,_|\__,_|
--                | |         | |         | |
--                |_|         |_|         |_|
--
-- Jonathan Lowe
-- github : https://github.com/jglowe
-- figlet font : big
--
-- This file contains the code needed to manage popups
--------------------------------------------------------------------------------
local state = require("yapm.state")

local get_popup_options = function(height)
    local window_options = {}
    window_options.relative = "editor"
    window_options.style = "minimal"
    window_options.width = math.floor(vim.opt.columns:get() * .8)
    window_options.height = height
    window_options.col = math.floor((vim.opt.columns:get() -
                                        window_options.width) / 2)
    window_options.row = math.floor(
                             (vim.opt.lines:get() - window_options.height) / 2)
    window_options.border = "single" -- { '─', '│', '─', '│', '┌', '┐', '┘', '└'}

    return window_options
end

local close = function()
    local popup_id = state.get_popup_id()
    if popup_id ~= nil then
        pcall(vim.api.nvim_win_close, popup_id, true)
        state.set_popup_id(nil)
        state.set_content_function(nil)
    end

    vim.cmd("autocmd! yapm_popup")
end

local resize = function(bufnr)
    local buf_contents = state.get_content_function()()
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_contents)

    vim.api.nvim_win_set_config(state.get_popup_id(),
                                get_popup_options(#buf_contents))
end

local open = function(content_function)
    local buf_contents = content_function()
    state.set_content_function(content_function)

    local bufnr = vim.api.nvim_create_buf(false, true)
    assert(bufnr, "Failed to create buffer")
    vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_contents)

    local popup_id = vim.api.nvim_open_win(bufnr, false,
                                           get_popup_options(#buf_contents))
    state.set_popup_id(popup_id)
    vim.api.nvim_set_current_win(popup_id)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "<esc>",
                                ":lua require('yapm.popup').close()<cr>",
                                {noremap = true})
    vim.api.nvim_win_set_option(
      popup_id,
      "winhl",
      "Normal:Normal,EndOfBuffer:Normal,FloatBorder:Normal"
    )

    vim.cmd(string.format([[
    augroup yapm_popup
        autocmd VimEnter * ++once ++nested lua pcall(vim.api.nvim_set_current_win, %s)
        autocmd BufLeave <buffer=%d> ++once lua require('yapm.popup').close()
        autocmd VimResized <buffer=%d> ++nested lua require('yapm.popup').resize(%d)
    augroup END
    ]], popup_id, bufnr, bufnr, bufnr))
end

return {open = open, resize = resize, close = close}

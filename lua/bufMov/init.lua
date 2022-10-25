local api = vim.api

local getCursorPosition = function(direction)
    local cursor = {}

    if direction == "up" then
        cursor.x = api.nvim_win_get_position(0)[2] + vim.fn.wincol()
        cursor.y = api.nvim_win_get_position(0)[1]
    elseif direction == "down" then
        cursor.x = api.nvim_win_get_position(0)[2] + vim.fn.wincol()
        cursor.y = api.nvim_win_get_position(0)[1] + api.nvim_win_get_height(0)
    elseif direction == "left" then
        cursor.x = api.nvim_win_get_position(0)[2]
        cursor.y = api.nvim_win_get_position(0)[1] + vim.fn.winline()
    elseif direction == "right" then
        cursor.x = api.nvim_win_get_position(0)[2] + api.nvim_win_get_width(0)
        cursor.y = api.nvim_win_get_position(0)[1] + vim.fn.winline()
    end

    cursor.tab = api.nvim_get_current_tabpage()

    return cursor
end

local moveCursor = function(cursor, direction)
    if direction == "up" then
        cursor.y = cursor.y - 1
    elseif direction == "down" then
        cursor.y = cursor.y + 1
    elseif direction == "left" then
        cursor.x = cursor.x - 1
    elseif direction == "right" then
        cursor.x = cursor.x + 1
    end

    return cursor
end

local cursorOnEdge = function(cursor, direction)
    if direction == "up" and cursor.y == 0 then
        return true
    elseif direction == "down" and cursor.y == api.nvim_get_option("lines") - api.nvim_get_option("cmdheight") - 1 then
        return true
    elseif direction == "left" and cursor.x == 0 then
        return true
    elseif direction == "right" and cursor.x == api.nvim_get_option("columns") then
        return true
    end

    return false
end

local collisionWithWindow = function(cursor, window)
    if
        cursor.x <= (window.x + window.width) -- checks if cursor is to the left of the window
        and cursor.x >= window.x -- checks if cursor is to the right of the window
        and cursor.y <= (window.y + window.height) -- checks if the cursor is height than the window
        and cursor.y >= window.y -- checks if the cursor is lower than the window
        and cursor.tab == window.tab
    then -- checks if cursor and window is on the same tab
        return true
    end

    return false
end

local getWindowList = function()
    local windows = {}
    local windowList = api.nvim_list_wins()

    for i, win in pairs(windowList) do
        local window = {}
        window.id = win
        window.x = api.nvim_win_get_position(win)[2]
        window.y = api.nvim_win_get_position(win)[1]
        window.width = api.nvim_win_get_width(win)
        window.height = api.nvim_win_get_height(win)
        window.tab = api.nvim_win_get_tabpage(win)

        windows[i] = window
    end

    return windows
end

local collisionWithAnyWindow = function(cursor)
    local windows = getWindowList()

    for _, window in pairs(windows) do
        if collisionWithWindow(cursor, window) then
            return window
        end
    end
end

local values = function(t)
    local i = 0
    return function()
        i = i + 1
        return t[i]
    end
end

local windowOptions = {
    "number",
    "relativenumber",
    "list",
}

local getWindowOptions = function(window)
    local options = {}

    for option in values(windowOptions) do
        options[option] = api.nvim_win_get_option(window, option)
    end

    return options
end

local setWindowOptions = function(window, options)
    for option, value in pairs(options) do
        api.nvim_win_set_option(window, option, value)
    end
end

local M = {}

M.movBuf = function(direction)
    local currentBuffer = api.nvim_get_current_buf()
    local currentWindow = api.nvim_get_current_win()
    local currentWindowOptionr = getWindowOptions(currentWindow)
    local currentCursor = api.nvim_win_get_cursor(currentWindow)

    local cursor = getCursorPosition(direction)

    if cursorOnEdge(cursor, direction) then
        return
    end

    local targetWindow = collisionWithAnyWindow(cursor)
    while targetWindow.id == currentWindow do
        cursor = moveCursor(cursor, direction)
        targetWindow = collisionWithAnyWindow(cursor)
    end

    local targetBuffer = api.nvim_win_get_buf(targetWindow.id)
    local targetWindowOptions = getWindowOptions(targetWindow.id)
    local targetCursor = api.nvim_win_get_cursor(targetWindow.id)

    api.nvim_win_set_buf(targetWindow.id, currentBuffer)
    api.nvim_win_set_buf(currentWindow, targetBuffer)

    setWindowOptions(currentWindow, targetWindowOptions)
    setWindowOptions(targetWindow.id, currentWindowOptionr)

    api.nvim_win_set_cursor(currentWindow, targetCursor)
    api.nvim_win_set_cursor(targetWindow.id, currentCursor)

    -- This should check the 'textlock' before calling set_current_window
    pcall(api.nvim_set_current_win, targetWindow.id)
end

return M

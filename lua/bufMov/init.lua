local api = vim.api

-- Get current window data
-- Buffer ID
-- Windows ID
-- Tabpage ID

-- Get windows overview of all windwos

-- Deduce target window from cursor position and window positions
--
-- Get cursor position relative to window position, add to get absolute cursor position
--
-- nvim_win_set_buf({window}, {buffer})                      *nvim_win_set_buf()*
--                 Sets the current buffer in a window, without side effects
--
--                 Attributes: ~
--                     not allowed when |textlock| is active
--
--                 Parameters: ~
--                     {window}  Window handle, or 0 for current window
--                     {buffer}  Buffer handle


local M = {}


M.getBuffer = function(direction)
  -- Get current windows data --
  local currentBuffer = api.nvim_get_current_buf()
  local currentWindowNumber = api.nvim_get_current_win()
  local currentCursor = api.nvim_win_get_cursor(0)
  local currentWindowPos = api.nvim_win_get_position(0)
  local currentCursorColumn = currentWindowPos[2] + currentCursor[2]
  local currentCursorLine = currentWindowPos[1] + currentCursor[1]
  local currentTab = api.nvim_get_current_tabpage()


  print('--- Current ---')
  print('Cursor: ' .. vim.inspect(currentCursor))
  print('Cursor colum: ' .. currentCursorColumn)
  print('Cursor line: ' .. currentCursorLine)
  print('Buffer num: ' .. currentBuffer)
  print('Tab: ' .. currentTab)
  print('Window num: ' .. currentWindowNumber)


  local windowList = api.nvim_list_wins()

  for _, window in pairs(windowList) do
    local windowCursor = api.nvim_win_get_cursor(window)
    local buffer = api.nvim_win_get_buf(window)
    local windowNumber = api.nvim_win_get_number(window)
    local windowPosition = api.nvim_win_get_position(window)
    local tabPage = api.nvim_win_get_tabpage(window)

    print('---------------')
    print('Window: ' .. window)
    print('Buffer num: ' .. buffer)
    print('Cursor: ' .. vim.inspect(windowCursor))
    print('Window num: ' .. windowNumber)
    print('Window pos: ' .. vim.inspect(windowPosition))
    print('Tabpage: ' .. tabPage)
  end
end


return M

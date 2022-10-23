local loaded = _G["bufMov_loaded"]

if loaded then
    return
end

local bufMov = require("bufMov")

local up = function()
    bufMov.movBuf("up")
end

local down = function()
    bufMov.movBuf("down")
end

local left = function()
    bufMov.movBuf("left")
end

local right = function()
    bufMov.movBuf("right")
end

vim.api.nvim_create_user_command("MoveBufferUp", up, {})
vim.api.nvim_create_user_command("MoveBufferDown", down, {})
vim.api.nvim_create_user_command("MoveBufferLeft", left, {})
vim.api.nvim_create_user_command("MoveBufferRight", right, {})

_G["bufMov_loaded"] = true

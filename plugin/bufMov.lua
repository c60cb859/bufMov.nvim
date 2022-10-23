vim.cmd([[ command! MoveBufferUp lua require('bufMov').movBuf('up') ]])
vim.cmd([[ command! MoveBufferDown lua require('bufMov').movBuf('down') ]])
vim.cmd([[ command! MoveBufferLeft lua require('bufMov').movBuf('left') ]])
vim.cmd([[ command! MoveBufferRight lua require('bufMov').movBuf('right') ]])

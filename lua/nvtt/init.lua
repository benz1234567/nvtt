local nvtt = {}

vim.cmd('normal! gg0')
--vim.cmd('setlocal buftype=nofile') -- Set buffer type to nofile to avoid saving changes

local startTime = os.time()
local buf = vim.api.nvim_get_current_buf() 
local win = vim.api.nvim_get_current_win()
local origfile = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    callback = function()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, origfile)
      local cursorPos = vim.api.nvim_win_get_cursor(win)
      if cursorPos[2] > 0 then
        -- it keeps unhighlighting because it does set lines every time, make it just delete the one letter or something
        vim.api.nvim_buf_add_highlight(buf, 0, 'Error', cursorPos[1] - 1, cursorPos[2] - 1, cursorPos[2])
      end
    end
})

return nvtt

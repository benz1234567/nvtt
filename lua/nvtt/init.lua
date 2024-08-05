local nvtt = {}

vim.cmd('normal! gg0')
vim.cmd('setlocal buftype=nofile') -- Set buffer type to nofile to avoid saving changes

local startTime = os.time()
local buf = vim.api.nvim_get_current_buf() 
local win = vim.api.nvim_get_current_win()
local origfile = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
local mistakesx = { }
local mistakesy = { }

vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    callback = function()
      local current = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local cursorPos = vim.api.nvim_win_get_cursor(win)
      local origString = string.sub(origfile[cursorPos[1]], 1, cursorPos[2])
      local currentString = string.sub(current[cursorPos[1]], 1, cursorPos[2])

      if origString == currentString then
        goto continue
      else
        if cursorPos[2] > 0 then
          for idx = #origString, 1, -1 do
            if string.sub(origString, idx, idx) == string.sub(currentString, idx, idx) then
              goto continue
            else
              table.insert(mistakesy, cursorPos[1] - 1)
              table.insert(mistakesx, idx)
            end
          end
        end
      end

      ::continue::
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, origfile)
      for idx = 1, #mistakesx do
        vim.api.nvim_buf_add_highlight(buf, 0, 'Error', mistakesy[idx], mistakesx[idx] - 1, mistakesx[idx])
      end

    end
})

return nvtt

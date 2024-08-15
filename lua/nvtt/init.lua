nvtt = {}

function nvtt:play(time)
  vim.opt.autoindent = false
  vim.opt.smartindent = false
  vim.opt_local.formatoptions:remove("r")
  vim.opt.cindent = false
  vim.opt.copyindent = false
  vim.opt.preserveindent = false
  vim.opt.indentexpr = ""
  vim.opt.modeline = false
  vim.api.nvim_command('startinsert')
  vim.bo.expandtab = false
  vim.cmd('setlocal buftype=nofile') -- Set buffer type to nofile to avoid saving changes

  if time and time ~= "" then
    timer = time * 1000
  else
    timer = 60000
  end

  startTime = os.time()
  buf = vim.api.nvim_get_current_buf()
  origwin = vim.api.nvim_get_current_win()
  origfile = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  mistakesx = { }
  mistakesy = { }
  mistakes = 0
  lettersTyped = 0

  wpmbuf = vim.api.nvim_create_buf(false, true)
  opts = {
    relative = 'editor',
    width = 15,
    height = 2,
    row = 1,
    col = vim.o.columns - 3,
    anchor = 'NE',
    style = 'minimal',
  }
  win = vim.api.nvim_open_win(wpmbuf, false, opts)
  vim.api.nvim_win_set_option(win, 'winblend', 0)
  vim.api.nvim_buf_set_lines(wpmbuf, 0, -1, false, {"WPM: 0"})

  autocmd = vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    callback = function()
      endTime = os.time()
      current = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      cursorPos = vim.api.nvim_win_get_cursor(origwin)
      currentString = string.sub(current[cursorPos[1]], 1, cursorPos[2])

      lettersTyped = #table.concat(current) - #table.concat(origfile) + lettersTyped

      if origfile[cursorPos[1]] then
        origString = string.sub(origfile[cursorPos[1]], 1, cursorPos[2])
      else
        if time and time ~= '' then
          vim.cmd('normal! gg0')
          mistakesy = {}
          mistakesx = {}
          goto continue
        else
          endGame()
          return
        end
      end

      if origString == currentString then
        goto continue
      elseif #origString > #currentString then
        goto continue
      else
        if cursorPos[2] > 0 then
          for idx = #currentString, 1, -1 do
            if string.sub(currentString, idx, idx) == string.sub(origString, idx, idx) then
              goto continue
            else
              table.insert(mistakesy, cursorPos[1] - 1)
              table.insert(mistakesx, idx)
              mistakes = mistakes + 1
            end
          end
        end
      end

      ::continue::
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, origfile)

      WPM = math.floor(((lettersTyped - mistakes) / (endTime - startTime)) * 12)
      vim.api.nvim_buf_set_lines(wpmbuf, 0, -1, false, {"WPM: " .. WPM})

      for idx = 1, #mistakesx do
        vim.api.nvim_buf_add_highlight(buf, 0, 'Error', mistakesy[idx], mistakesx[idx] - 1, mistakesx[idx])
      end

    end
  })


  if time and time ~= '' then
    vim.defer_fn(endGame, timer)
  end
end

function endGame()
  endTime = os.time()
  WPM = math.floor(((lettersTyped - mistakes) / (endTime - startTime)) * 12)
  vim.api.nvim_del_autocmd(autocmd)
  vim.api.nvim_win_close(win, true)
  vim.api.nvim_buf_delete(wpmbuf, { force = true })
  vim.api.nvim_buf_clear_namespace(0, 0, 0, -1)
  vim.defer_fn(function() print("Test Completed") 
    vim.fn.system("sleep 2")
    print("Your total WPM was " .. WPM .. ", with " .. mistakes .. " mistakes") 
    vim.fn.system("sleep 2")
    vim.api.nvim_command('stopinsert')
  end, 1)
end

return nvtt

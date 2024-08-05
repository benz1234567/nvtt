vim.api.nvim_create_user_command(
  'NVTT',
  function()
    local nvtt = require("nvtt")
    nvtt:play()
  end,
  {}
)

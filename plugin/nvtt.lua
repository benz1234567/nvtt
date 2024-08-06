vim.api.nvim_create_user_command(
  'NVTT',
  function(opts)
    local nvtt = require("nvtt")
    nvtt:play(opts.args)
  end,
  { nargs = "?" }
)

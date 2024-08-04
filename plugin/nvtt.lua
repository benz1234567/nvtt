vim.api.nvim_create_user_command(
  'NVTT',
  function()
    require("nvtt")
  end,
  {}
)

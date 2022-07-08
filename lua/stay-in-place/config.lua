local config = {}

config.options = {}

function config.setup(options)
  local default_values = {
    set_keymaps = true,
    preserve_visual_selection = true,
  }

  config.options = vim.tbl_deep_extend("force", default_values, options or {})
end

return config

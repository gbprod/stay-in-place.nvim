local config = require("stay-in-place.config")

local stayinplace = {}

stayinplace.state = {}

function stayinplace.setup(options)
  config.setup(options)

  if config.options.set_keymaps then
    stayinplace.set_keymaps()
  end
end

function stayinplace.set_keymaps()
  vim.keymap.set("n", ">", stayinplace.shift_right, { noremap = true, expr = true })
  vim.keymap.set("n", "<", stayinplace.shift_left, { noremap = true, expr = true })
  vim.keymap.set("n", "=", stayinplace.filter, { noremap = true, expr = true })

  vim.keymap.set("n", ">>", stayinplace.shift_right_line, { noremap = true })
  vim.keymap.set("n", "<<", stayinplace.shift_left_line, { noremap = true })
  vim.keymap.set("n", "==", stayinplace.filter_line, { noremap = true })

  vim.keymap.set("x", ">", stayinplace.shift_right_visual, { noremap = true })
  vim.keymap.set("x", "<", stayinplace.shift_left_visual, { noremap = true })
  vim.keymap.set("x", "=", stayinplace.filter_visual, { noremap = true })
end

function stayinplace.preserve(func)
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local len_before = vim.api.nvim_get_current_line():len()
  local winview = vim.fn.winsaveview()

  func()

  vim.fn.winrestview(winview)
  local len_after = vim.api.nvim_get_current_line():len()
  local new_col = math.max(0, col - len_before + len_after)
  vim.api.nvim_win_set_cursor(0, { line, new_col })
end

function stayinplace.shift_right_line()
  stayinplace.preserve(function()
    vim.cmd(string.format("silent keepjumps normal! %s>>", vim.v.count))
  end)
end

function stayinplace.shift_left_line()
  stayinplace.preserve(function()
    vim.cmd(string.format("silent keepjumps normal! %s<<", vim.v.count))
  end)
end

function stayinplace.filter_line()
  stayinplace.preserve(function()
    vim.cmd("silent keepjumps normal! ==")
  end)
end

function stayinplace.operator(type)
  stayinplace.state.count = vim.v.count
  stayinplace.state.type = type
  stayinplace.state.cursor = vim.api.nvim_win_get_cursor(0)
  stayinplace.state.len_before = vim.api.nvim_get_current_line():len()
  stayinplace.state.winview = vim.fn.winsaveview()

  vim.o.operatorfunc = "v:lua.require'stay-in-place'.operator_callback"

  return "g@"
end

function stayinplace.operator_callback(_)
  vim.cmd(string.format("keepjumps execute\"'[,']normal! %s %s\"", stayinplace.state.type, stayinplace.state.count))

  vim.fn.winrestview(stayinplace.state.winview)
  local len_after = vim.api.nvim_get_current_line():len()
  local new_col = math.max(0, stayinplace.state.cursor[2] - stayinplace.state.len_before + len_after)
  vim.api.nvim_win_set_cursor(0, { stayinplace.state.cursor[1], new_col })

  stayinplace.state = {}
end

function stayinplace.shift_right()
  return stayinplace.operator(">")
end

function stayinplace.shift_left()
  return stayinplace.operator("<")
end

function stayinplace.filter()
  return stayinplace.operator("=")
end

function stayinplace.shift_right_visual()
  stayinplace.preserve(function()
    vim.cmd(
      string.format(
        "silent keepjumps normal! %s>%s",
        vim.v.count,
        config.options.preserve_visual_selection and "gv" or ""
      )
    )
  end)
end

function stayinplace.shift_left_visual()
  stayinplace.preserve(function()
    vim.cmd(
      string.format(
        "silent keepjumps normal! %s<%s",
        vim.v.count,
        config.options.preserve_visual_selection and "gv" or ""
      )
    )
  end)
end

function stayinplace.filter_visual()
  stayinplace.preserve(function()
    vim.cmd(
      string.format(
        "silent keepjumps normal! %s=%s",
        vim.v.count,
        config.options.preserve_visual_selection and "gv" or ""
      )
    )
  end)
end

return stayinplace

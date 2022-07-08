local stayinplace = require("stay-in-place")

local function create_test_buffer()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_command("buffer " .. bufnr)

  vim.api.nvim_buf_set_lines(0, 0, -1, true, {
    "Lorem ipsum dolor sit amet,",
    "consectetur adipiscing elit.",
    "      Nulla malesuada lacus at ornare accumsan.",
    "",
    "Arcu dui vivamus arcu felis bibendum ut tristique et.",
    "Amet purus gravida quis blandit turpis cursus in.",
    "Auctor eu augue ut lectus arcu bibendum at.",
  })
end

local function execute_keys(feedkeys)
  local keys = vim.api.nvim_replace_termcodes(feedkeys, true, false, true)
  vim.api.nvim_feedkeys(keys, "x", false)
end

describe("Shift or filter line", function()
  before_each(create_test_buffer)

  it("should keep cursor position", function()
    execute_keys("jll")
    execute_keys(">>")
    assert.are.same({ 2, 3 }, vim.api.nvim_win_get_cursor(0))
  end)

  it("should keep cursor position", function()
    execute_keys("2j6l")
    execute_keys("<<")
    assert.are.same({ 3, 2 }, vim.api.nvim_win_get_cursor(0))
  end)

  it("should keep cursor position", function()
    execute_keys("2j6l")
    execute_keys("==")
    assert.are.same({ 3, 0 }, vim.api.nvim_win_get_cursor(0))
  end)
end)

describe("Shift or filter operator", function()
  before_each(create_test_buffer)

  it("should keep cursor position", function()
    execute_keys("jll")
    execute_keys(">ip")
    assert.are.same({ 2, 3 }, vim.api.nvim_win_get_cursor(0))
  end)

  it("should keep cursor position", function()
    execute_keys("2j6l")
    execute_keys("<ip")
    assert.are.same({ 3, 2 }, vim.api.nvim_win_get_cursor(0))
  end)

  it("should keep cursor position", function()
    execute_keys("2j6l")
    execute_keys("=ip")
    assert.are.same({ 3, 3 }, vim.api.nvim_win_get_cursor(0))
  end)
end)

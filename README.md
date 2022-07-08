# 🛑 stay-in-place.nvim

**This plugin still under development, use at your own risk.**

![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/gbprod/stay-in-place.nvim/Integration?style=for-the-badge)](https://github.com/gbprod/stay-in-place.nvim/actions/workflows/integration.yml)

`stay-in-place.nvim` is a Neovim plugin that prevent the cursor from moving when
using shift and filter actions.

## ✨ Features

When you use `shift` (`>` or `<` keys) or filter (`=` key), Neovim move your
cursor at the beginning of the selected region or doesn't keep the cursor on the
same character in line mode. I think it's annoying.

This plugin will:

- keep your cursor at the same position when using `>`, `<` or `=` operators  
  Eg. `>ip` will not put your cursor at the beginning of the paragraph
- keep your cursor on the same character when using line `>>`, `<<` or `==` operators
- keep visual selection when using `>`, `<` or `=` operators in visual mode

## ⚡️ Requirements

Neovim >= 0.7.0

## 📦 Installation

Install the plugin with your preferred package manager:

### [packer](https://github.com/wbthomason/packer.nvim)

```lua
-- Lua
use({
  "gbprod/stay-in-place.nvim",
  config = function()
    require("stay-in-place").setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    })
  end
})
```

## ⚙️ Configuration

Stay-in-place comes with the following defaults:

```lua
{
  set_keymaps = true,
  preserve_visual_selection = true,
}
```

More details on these options is available in the sections below corresponding to the different features.

#### `set_keymaps`

Default : `true`

If true, this will automaticly set keymaps, you can refer to [`set_keymaps`]()
function if you want to set keymaps by yourself.

#### `preserve_visual_selection`

Default : `true`

If `true`, when performing a shift or a filter in visual mode, this will keep
visual selection instead of discarding it.

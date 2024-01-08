<h1 align="center">

yazi.nvim

</h1>
<h3 align="right">

*—— A [Neovim](https://github.com/neovim/neovim) plugin for [Yazi](https://github.com/sxyazi/yazi)*

</h3>

<!--toc:start-->
- [yazi.nvim](#yazi.nvim)
  - [Dependencies](#dependencies)
  - [Install](#install)
  - [Configuration](#configuration)
  - [Using](#using)
<!--toc:end-->

#### Disclaimer:
I straight-up copied most of the code in this plugin from [ranger.nvim](https://github.com/Kicamon/ranger.nvim) because I just wanted something working asap. The only reason I didn't fork [ranger.nvim](https://github.com/Kicamon/ranger.nvim) but made a new repository instead was because this is plugin for a completely different purpose (not for using [Ranger](https://github.com/ranger/ranger)). I want to give credits to [the author of ranger.nvim](https://github.com/Kicamon) for writing awesome code and thank him for using the MIT licence.

## Dependencies
- [Yazi](https://github.com/sxyazi/yazi)
## Install
**lazy.nvim**
```lua
{
  "Kicamon/ranger.nvim",
  opts = {
    -- ...
  }
}
```
## Configuration
**defualt config**
```lua
{
  window = {
    size = {
      width = 0.9,
      height = 0.8,
    },
    pos = "cc",           -- see `:h yazi-win-position`
    style = "minimal",    -- "" | "minimal"
    border = "single",    -- "none" | "single" | "double" | "rounded" | "solid" | "shadow"
    title = " Yazi ",
    title_pos = "center", -- "center" | "left" | "right"
  },
}
```
## Using
**Open selected files in new buffers:**
```vim
:Yazi
```
or
```vim
:lua require("yazi").yazi()
```
**If you want to open the file in a new tab, and the working directory is `/` for yazi, you can execute this command:**
```vim
:lua require("yazi").yazi({ open_command = "tabedit", cwd = "/" })
```
**And you will be able to use the following `open_command` arguments:**
| arguments       | description                    |
|-----------------|--------------------------------|
| `edit`(default) | open files in buffers          |
| `tabedit`       | open files in tabs             |
| `split`         | open files in horizontal split |
| `vsplit`        | open files in vertical split   |

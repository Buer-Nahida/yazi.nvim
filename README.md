<h1 align="center"> yazi.nvim </h1>
<h3 align="right">

*—— A [Neovim](https://github.com/neovim/neovim) plugin for [Yazi](https://github.com/sxyazi/yazi)*

</h3>

> [!WARNING]
>
> ### **I gave up this project, because I haven't extra time to care it and I found a plugin \([mikavilpas/yazi.nvim](https://github.com/mikavilpas/yazi.nvim)\) same as and better than this plugin, you can use that plugin instead of this.**

<!--toc:start-->
- [Disclaimer](#disclaimer)
- [Dependencies](#dependencies)
- [Install](#install)
- [Configuration](#configuration)
- [Using](#using)
<!--toc:end-->

#### Disclaimer

I straight-up copied most of the code in this plugin from [ranger.nvim](https://github.com/Kicamon/ranger.nvim) because I just wanted something working asap. The only reason I didn't fork [ranger.nvim](https://github.com/Kicamon/ranger.nvim) but made a new repository instead was because this is plugin for a completely different purpose (not for using [Ranger](https://github.com/ranger/ranger)). I want to give credits to [the author of ranger.nvim](https://github.com/Kicamon) for writing awesome code and thank him for using the MIT licence.

## Dependencies

- [Yazi](https://github.com/sxyazi/yazi)

## Install

**lazy.nvim**

```lua
{
  "SR-MyStar/yazi.nvim",
  opts = {
    -- ...
  },
}
```

or use Lazy-load feature

```lua
{
  "SR-Mystar/yazi.nvim",
  lazy = true,
  cmd = "Yazi",
  opts = {
    -- ...
  },
  keys = {
    -- ...
  },
}
```

## Configuration

**defualt config**

```lua
{
  size = {
    width = 0.9,
    height = 0.8,
  },
  command_args = {
    open_dir = vim.cmd.edit,
    open_file = vim.cmd.edit,
    cwd = nil,
    on_open = nil,
  },
  pos = "cc",           -- see `:h yazi-win-position`
  style = "minimal",    -- "" | "minimal"
  border = "single",    -- "none" | "single" | "double" | "rounded" | "solid" | "shadow"
  title = " Yazi ",
  title_pos = "center", -- "center" | "left" | "right"
}
```

## Using

**Open selected files in new buffers:**

```vim
:Yazi
```

or

```vim
:lua require("yazi").open()
```

**You will be able to use the following arguments:**
| arguments         | description                  |
|-------------------|------------------------------|
| `open_file(path)` | use a function to open files |
| `cwd`             | change working directory     |
| `on_open()`       | do something on opening yazi |
| `open_dir(path)`  | use a function to open dir   |

# [yazi](https://github.com/sxyazi/yazi).nvim
### A [Neovim](https://github.com/neovim/neovim) plugin for [Yazi](https://github.com/sxyazi/yazi)

Disclaimer: I straight-up copied most of the code in this plugin from [ranger.nvim](https://github.com/Kicamon/ranger.nvim) because I just wanted something working asap. The only reason I didn't fork [ranger.nvim](https://github.com/Kicamon/ranger.nvim) but made a new repository instead was because this is plugin for a completely different purpose (not for using [Ranger](https://github.com/ranger/ranger)). I want to give credits to [the author of ranger.nvim](https://github.com/Kicamon) for writing awesome code and thank him for using the MIT licence.

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
  win = {
    width = 0.8,
    height = 0.8,
    position = 'cc', -- see `:h yazi-win-position`
  },
}
```
## Using
##### Open selected files in new buffers:
```vim
:Yazi
```
or
```vim
:lua require("yazi").yazi()
```
##### If you want to open the file in a new tab, you can execute this command:
```vim
:Yazi tabedit
```
or
```vim
:lua require("yazi").yazi("tabedit")
```
##### And you will be able to use the following **command arguments**:
| arguments | description                    |
|-----------|--------------------------------|
| `edit`    | open files in buffers          |
| `tabedit` | open files in tabs             |
| `split`   | open files in horizontal split |
| `vsplit`  | open files in vertical split   |

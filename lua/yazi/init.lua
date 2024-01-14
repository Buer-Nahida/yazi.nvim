local prev_win = -1
local winnr = -1
local bufnr = -1
local tempname = ""
---@class YaziFloatWindowOptions
---@field border?       "none" | "single" | "double" | "rounded" | "solid" | "shadow"
---@field title?        string
---@field title_pos?    "center" | "left" | "right"
---@field size?         { width: number, height: number }
---@field style?        "" | "minimal"
---@field pos?          "tl" | "tr" | "cc" | "bl" | "br"
---@field command_args? TerminalOpenOptions
local default_opts = {
  size = {
    width = 0.9,
    height = 0.8,
  },
  command_args = {
    open_dir = vim.cmd.edit,
    open_file = vim.cmd.edit,
  },
  pos = "cc",
  style = "minimal",
  border = "single",
  title = " Yazi ",
  title_pos = "center",
}

local function open(open_file, open_dir)
  if vim.loop.fs_statfs(tempname) then
    local filenames = vim.fn.readfile(tempname)
    if vim.fn.isdirectory(filenames[1]) then
      if #filenames == 1 then
        open_dir(filenames[1])
      end
      return
    end
    for _, filename in ipairs(filenames) do
      open_file(filename)
    end
  end
end

local function close_float_win()
  vim.api.nvim_win_close(winnr, true)
  vim.api.nvim_buf_delete(bufnr, { force = true })
  vim.api.nvim_set_current_win(prev_win)
end

---@class TerminalOpenOptions
---@field open_file? fun(path: string)
---@field open_dir?  fun(path: string)
---@field cwd?       string
---@field on_open?   fun()
---@param opts TerminalOpenOptions
local function open_yazi(opts)
  prev_win = vim.api.nvim_get_current_win()
  ---@diagnostic disable-next-line: cast-local-type
  local win = require("yazi.float_win")
  win:Create({
    width = default_opts.size.width,
    height = default_opts.size.height,
    title = default_opts.title,
    title_pos = default_opts.title_pos,
    style = default_opts.style,
    border = default_opts.border,
  }, {
    pos = default_opts.pos,
  })
  WinInfo = win:GetInfo()
  winnr, bufnr = WinInfo.winnr, WinInfo.bufnr
  if opts and opts.on_open then
    opts.on_open()
  else
    if default_opts.command_args.on_open then
      default_opts.command_args.on_open()
    end
  end
  vim.cmd.startinsert()
  ---@diagnostic disable-next-line: cast-local-type
  tempname = vim.fn.tempname()
  vim.fn.termopen('yazi --chooser-file="' .. tempname .. '"', {
    cwd = opts and opts.cwd or default_opts.command_args.cwd,
    on_exit = function()
      if vim.api.nvim_win_is_valid(winnr) then
        close_float_win()
        open(
          opts and opts.open_file or default_opts.command_args.open_file,
          opts and opts.open_dir or default_opts.command_args.open_dir
        )
      end
      vim.fn.delete(tempname)
    end,
  })
end

---@param opts nil | YaziFloatWindowOptions
local function setup(opts)
  default_opts = vim.tbl_extend("force", default_opts, opts or {})
  vim.api.nvim_create_user_command("Yazi", open_yazi, {})
end

return {
  setup = setup,
  open = open_yazi,
}

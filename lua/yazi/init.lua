---@class YaziFloatWindowOptions
---@field border?     "none" | "single" | "double" | "rounded" | "solid" | "shadow"
---@field title?      string
---@field title_pos?  "center" | "left" | "right"
---@field size?       { width: number, height: number }
---@field style?      "" | "minimal"
---@field pos?        "tl" | "tr" | "cc" | "bl" | "br"

local prev_win = -1
local winnr = -1
local bufnr = -1
local tempname = ""
---@type YaziFloatWindowOptions
local default_opts = {
  size = {
    width = 0.9,
    height = 0.8,
  },
  pos = "cc",
  style = "minimal",
  border = "single",
  title = " Yazi ",
  title_pos = "center",
}

local function open(open_command, open_dir)
  if vim.loop.fs_statfs(tempname) then
    local filenames = vim.fn.readfile(tempname)
    if vim.fn.isdirectory(filenames[1]) then
      if #filenames == 1 then
        open_dir(filenames[1])
      end
      return
    end
    if vim.api.nvim_buf_get_name(0) == "" then
      open_command = "edit"
    end
    for _, filename in ipairs(filenames) do
      vim.cmd(string.format(":%s %s", open_command, filename))
    end
  end
end

local function close_float_win()
  vim.api.nvim_win_close(winnr, true)
  vim.api.nvim_buf_delete(bufnr, { force = true })
  vim.api.nvim_set_current_win(prev_win)
end

---@class TerminalOpenOptions
---@field open_command? string
---@field open_dir?     fun(path: string)
---@field cwd?          string
---@field on_open?      function
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
  if opts.on_open then
    opts.on_open()
  end
  vim.cmd.startinsert()
  ---@diagnostic disable-next-line: cast-local-type
  tempname = vim.fn.tempname()
  vim.fn.termopen('yazi --chooser-file="' .. tempname .. '"', {
    cwd = opts.cwd,
    on_exit = function()
      if vim.api.nvim_win_is_valid(winnr) then
        close_float_win()
        open(
          opts and opts.open_command or "edit",
          opts and opts.open_dir or function(_) end
        )
      end
      vim.fn.delete(tempname)
    end,
  })
end

local function setup(opts)
  default_opts = vim.tbl_extend("force", default_opts, opts or {})
  vim.api.nvim_create_user_command("Yazi", open_yazi, {})
end

return {
  setup = setup,
  open = open_yazi,
}

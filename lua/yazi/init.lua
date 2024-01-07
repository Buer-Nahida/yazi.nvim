---@class YaziFloatWindowOptions
---@field border?     "none" | "single" | "double" | "rounded" | "solid" | "shadow"
---@field title?      string
---@field title_pos? "center" | "left" | "right"
---@field size?      { width: number, height: number }
---@field style?     "" | "minimal"
---@field pos?       "tl" | "tr" | "cc" | "bl" | "br"

local prev_win = -1
local winnr = -1
local bufnr = -1
local tempname = ""
local workpath = ""
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

local function open_file(open_command)
  if vim.fn.filereadable(vim.fn.expand(tempname)) == 1 then
    if vim.api.nvim_buf_get_name(0) == "" then
      open_command = "edit"
    end
    local filenames = vim.fn.readfile(tempname)
    for _, filename in ipairs(filenames) do
      vim.cmd(string.format(":%s %s", open_command, filename))
    end
  end
end

local function on_end()
  vim.fn.delete(tempname)
  vim.cmd("silent! lcd " .. workpath)
end

local function yazi_open(name)
  vim.api.nvim_create_autocmd("TermOpen", {
    buffer = bufnr,
    callback = function()
      vim.api.nvim_command("file " .. name)
      vim.cmd([[startinsert]])
    end,
  })
end

local function close_float_win()
  vim.api.nvim_win_close(winnr, true)
  vim.api.nvim_buf_delete(bufnr, { force = true })
  vim.api.nvim_set_current_win(prev_win)
end

local function yazi(open_command)
  prev_win = vim.api.nvim_get_current_win()
  ---@diagnostic disable-next-line: cast-local-type
  workpath = vim.fn.getcwd()
  vim.cmd("silent! lcd %:p:h")
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
  yazi_open("Yazi")
  ---@diagnostic disable-next-line: cast-local-type
  tempname = vim.fn.tempname()
  vim.fn.termopen('yazi --chooser-file="' .. tempname .. '"', {
    on_exit = function()
      if vim.api.nvim_win_is_valid(winnr) then
        close_float_win()
        open_file(open_command or "edit")
      end
      on_end()
    end,
  })
end

local function setup(opts)
  default_opts = vim.tbl_extend("force", default_opts, opts or {})
  vim.api.nvim_create_user_command("Yazi", yazi, {})
end

return {
  setup = setup,
  yazi = yazi,
}

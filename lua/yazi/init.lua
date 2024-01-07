local prev_win = -1
local winnr = -1
local bufnr = -1
local tempname = ""
local workpath = ""
local default_opts = {
  win = {
    width = 0.8,
    height = 0.8,
    position = "cc",
  },
}

local function open_file(open)
  if vim.fn.filereadable(vim.fn.expand(tempname)) == 1 then
    if vim.api.nvim_buf_get_name(0) == "" then
      open = "edit"
    end
    local filenames = vim.fn.readfile(tempname)
    for _, filename in ipairs(filenames) do
      vim.cmd(string.format(":%s %s", open, filename))
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

local function yazi(open)
  prev_win = vim.api.nvim_get_current_win()
  ---@diagnostic disable-next-line: cast-local-type
  workpath = vim.fn.getcwd()
  vim.cmd("silent! lcd %:p:h")
  local win = require("yazi.float_win")
  win:Create({
    width = default_opts.win.width,
    height = default_opts.win.height,
    title = " Yazi ",
  }, {
    pos = default_opts.win.position,
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
        open_file(open or "edit")
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

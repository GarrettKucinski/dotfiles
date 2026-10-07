-- Zellij-style window management: a zoom toggle and a sticky resize mode.
local M = {}

local step = { cols = 5, rows = 2 }

-- Keys accepted while in resize mode. Holding any of them auto-repeats because
-- each keypress is read directly, with no <C-w> prefix to retype.
local resize_keys = {
  ["<"] = "vertical resize -%d",
  ["h"] = "vertical resize -%d",
  [">"] = "vertical resize +%d",
  ["l"] = "vertical resize +%d",
  ["-"] = "resize -%d",
  ["j"] = "resize -%d",
  ["+"] = "resize +%d",
  ["k"] = "resize +%d",
}

local function resize(key)
  local cmd = resize_keys[key]
  vim.cmd(cmd:format(cmd:find("vertical") and step.cols or step.rows))
end

local function resize_mode(first)
  resize(first)
  while true do
    vim.cmd.redraw()
    vim.api.nvim_echo({ { "-- RESIZE -- h/l/</> width  j/k/-/+ height  <Esc> done", "ModeMsg" } }, false, {})
    local ok, key = pcall(vim.fn.getcharstr)
    if not ok or key == "\27" then
      break
    end
    if not resize_keys[key] then
      -- Any other key leaves resize mode and is handled normally.
      vim.api.nvim_feedkeys(key, "mi", false)
      break
    end
    resize(key)
  end
  vim.api.nvim_echo({ { "" } }, false, {})
end

-- Per-tab zoom state: the layout to restore and the window count it applies to.
local function toggle_zoom()
  local zoom = vim.t.window_zoom
  local wins = #vim.api.nvim_tabpage_list_wins(0)
  if zoom then
    vim.t.window_zoom = nil
    -- winrestcmd() is only valid for the same set of windows; otherwise just even out.
    if zoom.wins == wins then
      vim.cmd(zoom.restore)
    else
      vim.cmd.wincmd("=")
    end
    return
  end
  if wins == 1 then
    return
  end
  vim.t.window_zoom = { restore = vim.fn.winrestcmd(), wins = wins }
  vim.cmd.wincmd("|")
  vim.cmd.wincmd("_")
end

function M.setup()
  vim.keymap.set("n", "<C-w>f", toggle_zoom, { desc = "Toggle window zoom" })
  for _, key in ipairs({ "<", ">", "+", "-" }) do
    vim.keymap.set("n", "<C-w>" .. key, function()
      resize_mode(key)
    end, { desc = "Resize mode (" .. key .. ")" })
  end
end

return M

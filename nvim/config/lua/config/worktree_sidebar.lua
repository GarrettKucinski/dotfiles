local M = {}

local namespace = vim.api.nvim_create_namespace("worktree_sidebar")
local tabs = {}
local config = { search_root = vim.fn.expand("~/dev"), max_depth = 6, width = 36 }

local function command(args)
  local result = vim.system(args, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout)
end

local function git(path, ...)
  return command(vim.list_extend({ "git", "-C", path }, { ... }))
end

local function discover()
  local entries = {}
  if vim.fn.executable("fd") == 1 then
    local output = command({ "fd", "-H", "-d", tostring(config.max_depth), "^\\.git$", config.search_root })
    for entry in (output or ""):gmatch("[^\n]+") do
      entries[#entries + 1] = vim.fs.dirname(entry:gsub("/$", ""))
    end
  end
  entries[#entries + 1] = vim.fn.getcwd()

  local groups = {}
  for _, path in ipairs(entries) do
    local common = git(path, "rev-parse", "--path-format=absolute", "--git-common-dir")
    if common and not groups[common] then
      local output = git(path, "worktree", "list", "--porcelain")
      if output then
        local worktrees = {}
        local current
        for line in (output .. "\n\n"):gmatch("([^\n]*)\n") do
          if line:sub(1, 9) == "worktree " then
            current = { path = vim.fs.normalize(line:sub(10)), branch = "(detached)" }
          elseif line:sub(1, 7) == "branch " and current then
            current.branch = line:sub(8):gsub("^refs/heads/", "")
          elseif line == "" and current then
            worktrees[#worktrees + 1] = current
            current = nil
          end
        end
        if #worktrees > 0 then
          local primary = worktrees[1]
          table.sort(worktrees, function(a, b)
            if a == primary then
              return true
            end
            if b == primary then
              return false
            end
            return a.branch < b.branch
          end)
          groups[common] = {
            name = vim.fs.basename(primary.path),
            primary = primary.path,
            worktrees = worktrees,
          }
        end
      end
    end
  end

  local sorted = vim.tbl_values(groups)
  table.sort(sorted, function(a, b)
    return a.name < b.name
  end)
  return sorted
end

local function current_tab()
  local tab = vim.api.nvim_get_current_tabpage()
  tabs[tab] = tabs[tab] or {}
  return tabs[tab]
end

local function sidebar_open(state)
  return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function editor_window(state)
  if state.editor and vim.api.nvim_win_is_valid(state.editor) then
    return state.editor
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= state.win then
      return win
    end
  end
end

local function render(state)
  if not sidebar_open(state) then
    return
  end

  local lines = { "Worktrees", "  ↵ open    r refresh    q close", "" }
  local row_paths = {}
  local headings = {}
  local active_rows = {}
  local dots = {}
  local secondary_rows = {}
  local badges = {}
  local cwd = vim.fs.normalize(vim.fn.getcwd())

  for _, group in ipairs(discover()) do
    headings[#headings + 1] = #lines
    lines[#lines + 1] = group.name
    for index, worktree in ipairs(group.worktrees) do
      local active = worktree.path == cwd
      local badge = worktree.path == group.primary and " [primary]" or ""
      lines[#lines + 1] = (active and "  ● " or "  ○ ") .. worktree.branch .. badge
      row_paths[#lines] = worktree.path
      dots[#dots + 1] = { row = #lines, active = active }
      if badge ~= "" then
        badges[#badges + 1] = { row = #lines, start = #lines[#lines] - #badge }
      end
      if active then
        active_rows[#active_rows + 1] = #lines
      end
      lines[#lines + 1] = "      " .. vim.fs.basename(worktree.path)
      row_paths[#lines] = worktree.path
      secondary_rows[#secondary_rows + 1] = #lines
      if active then
        active_rows[#active_rows + 1] = #lines
      end
      if index < #group.worktrees then
        lines[#lines + 1] = ""
      end
    end
    lines[#lines + 1] = ""
  end

  if #lines == 3 then
    lines[#lines + 1] = "No Git worktrees found under " .. config.search_root
  end

  state.row_paths = row_paths
  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.bo[state.buf].modifiable = false
  vim.api.nvim_buf_clear_namespace(state.buf, namespace, 0, -1)
  for _, row in ipairs(headings) do
    vim.api.nvim_buf_add_highlight(state.buf, namespace, "Title", row, 0, -1)
  end
  for _, row in ipairs(active_rows) do
    vim.api.nvim_buf_set_extmark(state.buf, namespace, row - 1, 0, {
      line_hl_group = "CursorLine",
    })
  end
  for _, row in ipairs(secondary_rows) do
    vim.api.nvim_buf_add_highlight(state.buf, namespace, "Comment", row - 1, 0, -1)
  end
  for _, badge in ipairs(badges) do
    vim.api.nvim_buf_add_highlight(state.buf, namespace, "Comment", badge.row - 1, badge.start, -1)
  end
  for _, dot in ipairs(dots) do
    vim.api.nvim_buf_add_highlight(
      state.buf,
      namespace,
      dot.active and "DiagnosticOk" or "Comment",
      dot.row - 1,
      2,
      5
    )
  end
end

M.discover = discover

function M.refresh()
  render(current_tab())
end

function M.open_selected()
  local state = current_tab()
  local path = state.row_paths and state.row_paths[vim.api.nvim_win_get_cursor(0)[1]]
  if not path then
    return
  end

  local target = editor_window(state)
  if not target then
    vim.cmd("rightbelow vnew")
    target = vim.api.nvim_get_current_win()
  end

  vim.api.nvim_set_current_win(target)
  vim.cmd("tcd " .. vim.fn.fnameescape(path))
  vim.api.nvim_win_set_buf(target, vim.api.nvim_create_buf(true, false))
  state.editor = target
  render(state)
end

function M.toggle()
  local state = current_tab()
  if sidebar_open(state) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  state.editor = vim.api.nvim_get_current_win()
  state.buf = state.buf and vim.api.nvim_buf_is_valid(state.buf) and state.buf or vim.api.nvim_create_buf(false, true)
  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].bufhidden = "hide"
  vim.bo[state.buf].swapfile = false
  vim.bo[state.buf].filetype = "worktree-sidebar"

  vim.cmd("topleft " .. config.width .. "vsplit")
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.win, state.buf)
  vim.wo[state.win].number = false
  vim.wo[state.win].relativenumber = false
  vim.wo[state.win].signcolumn = "no"
  vim.wo[state.win].wrap = false
  vim.wo[state.win].winfixwidth = true

  vim.keymap.set("n", "<CR>", M.open_selected, { buffer = state.buf, silent = true })
  vim.keymap.set("n", "r", M.refresh, { buffer = state.buf, silent = true })
  vim.keymap.set("n", "q", M.toggle, { buffer = state.buf, silent = true })
  render(state)
end

function M.setup(opts)
  config = vim.tbl_extend("force", config, opts or {})
  vim.api.nvim_create_user_command("WorktreeSidebar", M.toggle, {})
  vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      vim.schedule(M.refresh)
    end,
  })
end

return M

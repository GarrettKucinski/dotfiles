local M = {}

-- Longest worktree path that is or contains `file`, so nested worktrees resolve correctly.
local function owning_worktree(file, worktrees)
  local best
  for _, path in ipairs(worktrees) do
    local inside = file == path or file:sub(1, #path + 1) == path .. "/"
    if inside and (not best or #path > #best) then
      best = path
    end
  end
  return best
end

-- The worktree you're "in": the current buffer's file if it has one, else cwd
-- (which project.nvim may have set to a subdirectory of the worktree).
local function entries()
  local results, paths = {}, {}
  for _, group in ipairs(require("config.worktree_sidebar").discover()) do
    for _, worktree in ipairs(group.worktrees) do
      results[#results + 1] = {
        repo = group.name,
        group = group.primary,
        branch = worktree.branch,
        path = worktree.path,
        primary = worktree.path == group.primary,
      }
      paths[#paths + 1] = worktree.path
    end
  end

  local name = vim.api.nvim_buf_get_name(0)
  local anchor = vim.bo.buftype == "" and name ~= "" and name or vim.fn.getcwd()
  local active = owning_worktree(vim.fs.normalize(anchor), paths)
  local current_group
  for _, item in ipairs(results) do
    item.active = item.path == active
    if item.active then
      current_group = item.group
    end
  end
  return results, current_group
end

-- Re-point buffers from sibling worktrees at the same relative path in `target`;
-- close ones with no counterpart. Modified buffers are left alone.
local function migrate_buffers(target, siblings)
  local skipped = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.api.nvim_buf_get_name(buf)
    local root = vim.bo[buf].buftype == "" and name ~= "" and owning_worktree(vim.fs.normalize(name), siblings)
    if root and root ~= target then
      if vim.bo[buf].modified then
        skipped[#skipped + 1] = vim.fn.fnamemodify(name, ":~")
      else
        local counterpart = target .. name:sub(#root + 1)
        local replacement
        if vim.uv.fs_stat(counterpart) then
          replacement = vim.fn.bufadd(counterpart)
          vim.bo[replacement].buflisted = true
        end
        for _, win in ipairs(vim.fn.win_findbuf(buf)) do
          local cursor = vim.api.nvim_win_get_cursor(win)
          vim.api.nvim_win_set_buf(win, replacement or vim.api.nvim_create_buf(true, false))
          if replacement then
            pcall(vim.api.nvim_win_set_cursor, win, cursor)
          end
        end
        vim.api.nvim_buf_delete(buf, {})
      end
    end
  end
  if #skipped > 0 then
    vim.notify("Kept unsaved buffers from previous worktree:\n" .. table.concat(skipped, "\n"), vim.log.levels.WARN)
  end
end

function M.pick(opts)
  opts = opts or {}
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")

  local results, current_group = entries()
  local show_all = current_group == nil
  local repo_width = 0
  for _, item in ipairs(results) do
    repo_width = math.max(repo_width, #item.repo)
  end

  local displayer = entry_display.create({
    separator = " ",
    items = { { width = 1 }, { width = repo_width }, { remaining = true } },
  })

  local function make_finder()
    local visible = vim.tbl_filter(function(item)
      return show_all or item.group == current_group
    end, results)
    return finders.new_table({
      results = visible,
      entry_maker = function(item)
        return {
          value = item,
          ordinal = item.repo .. " " .. item.branch,
          path = item.path,
          display = function()
            return displayer({
              { item.active and "●" or " ", "DiagnosticOk" },
              { item.repo, "TelescopeResultsIdentifier" },
              { item.branch .. (item.primary and " [primary]" or "") },
            })
          end,
        }
      end,
    })
  end

  local function title()
    return show_all and "Worktrees (all)" or "Worktrees (" .. vim.fs.basename(current_group) .. ")  <C-a> all"
  end

  pickers
    .new(opts, {
      prompt_title = title(),
      finder = make_finder(),
      sorter = conf.generic_sorter(opts),
      previewer = false,
      attach_mappings = function(prompt_bufnr, map)
        map({ "i", "n" }, "<C-a>", function()
          if not current_group then
            return
          end
          show_all = not show_all
          local picker = action_state.get_current_picker(prompt_bufnr)
          picker.prompt_border:change_title(title())
          picker:refresh(make_finder(), { reset_prompt = false })
        end, { desc = "Toggle all repos" })
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if not selection then
            return
          end
          local siblings = {}
          for _, item in ipairs(results) do
            if item.group == selection.value.group then
              siblings[#siblings + 1] = item.path
            end
          end
          migrate_buffers(selection.path, siblings)
          vim.cmd("cd " .. vim.fn.fnameescape(selection.path))
          require("telescope.builtin").find_files({ cwd = selection.path, hidden = true })
        end)
        return true
      end,
    })
    :find()
end

function M.setup()
  vim.api.nvim_create_user_command("Worktrees", function()
    M.pick()
  end, {})
  vim.keymap.set("n", "<leader>gw", M.pick, { desc = "[G]it [W]orktree picker" })
end

return M

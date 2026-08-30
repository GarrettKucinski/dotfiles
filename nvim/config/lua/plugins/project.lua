local function find_repos()
  local repos = {}
  local hits = vim.fn.systemlist({ "fd", "-H", "-d", "4", [[^\.git$]], vim.fn.expand("~/dev") })
  for _, hit in ipairs(hits) do
    table.insert(repos, vim.fn.fnamemodify(hit:gsub("/$", ""), ":h"))
  end
  table.sort(repos)
  return repos
end

local function pick_repo()
  local conf = require("telescope.config").values
  require("telescope.pickers")
    .new({}, {
      prompt_title = "Repos",
      finder = require("telescope.finders").new_table({ results = find_repos() }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        require("telescope.actions").select_default:replace(function()
          local selection = require("telescope.actions.state").get_selected_entry()
          require("telescope.actions").close(prompt_bufnr)
          require("telescope.builtin").find_files({ cwd = selection[1] })
        end)
        return true
      end,
    })
    :find()
end

return {
  {
    "ahmedkhalf/project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    opts = {
      manual_mode = false,
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "go.mod", "package.json", "Makefile", "Cargo.toml" },
      scope_chdir = "global",
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
    keys = {
      {
        "<leader>fp",
        "<cmd>Telescope projects<cr>",
        desc = "[F]ind [P]roject",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>fR",
        pick_repo,
        desc = "[F]ind [R]epo",
      },
    },
  },
}

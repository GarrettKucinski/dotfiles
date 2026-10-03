return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    -- Renders in normal/command/terminal modes; insert mode and the cursor line show raw markdown.
    opts = {},
    keys = {
      { "<leader>tm", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "[T]oggle [M]arkdown rendering" },
    },
  },
}

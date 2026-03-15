return {
  "loctvl842/monokai-pro.nvim",
  enabled = false, -- Disabled to avoid conflicts with rose-pine
  config = function()
    require("monokai-pro").setup({
      transparent_background = false,
      terminal_colors = true,
      devicons = true,
      styles = {
        comment = { italic = true },
        keyword = { italic = true },
        type = { italic = true },
        storageclass = { italic = true },
        structure = { italic = true },
        parameter = { italic = true },
        annotation = { italic = true },
        tag_attribute = { italic = true },
      },
      filter = "octagon",
      day_night = {
        enable = false,
        day_filter = "spectrum",
        night_filter = "spectrum",
      },
      inc_search = "background",
      background_clear = {
        "toggleterm",
        "telescope",
        "renamer",
        "notify",
      },
      plugins = {
        bufferline = {
          underline_selected = false,
          underline_visible = false,
        },
        indent_blankline = {
          context_highlight = "default",
          context_start_underline = false,
        },
      },
      override = function()
        return {
          -- Keywords (if, for, while, etc.) - Aqua Blue
          Keyword = { fg = "#78dce8", italic = true },
          Statement = { fg = "#78dce8", italic = true },
          Conditional = { fg = "#78dce8", italic = true },
          Repeat = { fg = "#78dce8", italic = true },
          
          -- Variables - Purple
          Identifier = { fg = "#ae81ff" },
          Variable = { fg = "#ae81ff" },
          
          -- Comments with italics
          Comment = { fg = "#75715e", italic = true },
          
          -- Brackets and punctuation - Grey
          Delimiter = { fg = "#75715e" },
          Punctuation = { fg = "#75715e" },
          MatchParen = { fg = "#75715e", bg = "#49483e" },
          ["@punctuation.bracket"] = { fg = "#75715e" },
          ["@punctuation.delimiter"] = { fg = "#75715e" },
        }
      end
    })
  end
}

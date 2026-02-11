return {
  { "ellisonleao/gruvbox.nvim" },
  {
    "Tsuzat/NeoSolarized.nvim",
    opts = {
      transparent = false,
      -- Italics for different hightlight groups (eg. Statement, Condition,
      -- Comment, Include, etc.)
      enable_italics = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        functions = { bold = true },
        variables = {},
        string = {
          italic = true,
        },
      },
      -- Add specific hightlight groups
      on_highlights = function(highlights, colors)
        highlights.IblIndent.fg = colors.bg1
        highlights.IblScope.bg = colors.bg0
      end,
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}

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
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- parsers
      ensure_installed = {
        "json",
        "latex",
        "markdown",
        "markdown_inline",
        "regex",
        "query",
        "yaml",
      },
    },
  },
}

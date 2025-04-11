return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      typescript = { "prettier" },
      sh = { "shfmt" },
    },
    formatters = {
      shfmt = {
        append_args = {
          "-i=4", -- indentation
          "-ci", -- indent switch cases
          "-fn", -- function next line
          "-bn", -- allow binary operators beginning of line
        },
      },
    },
  },
}

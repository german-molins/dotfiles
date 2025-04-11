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
          "--indent=4",
          "--case-indent",
          "--func-next-line",
          "--binary-next-line",
        },
      },
    },
  },
}

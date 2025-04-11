return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      typescript = { "prettier" },
      lua = { "stylua" },
      sh = { "shfmt" },
    },
    formatters = {
      shfmt = {
        append_args = {
          "--indent=4",
          "--func-next-line",
          "--binary-next-line",
        },
      },
    },
  },
}

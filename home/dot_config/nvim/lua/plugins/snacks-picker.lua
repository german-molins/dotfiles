return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      layout = {
        fullscreen = true,
        cycle = true,
        --- Use the default layout or vertical if the window is too narrow
        preset = function()
          return vim.o.columns >= 200 and "default" or "vertical"
        end,
      },
      hidden = true,
    },
  },
}

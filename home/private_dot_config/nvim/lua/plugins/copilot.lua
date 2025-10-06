return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  opts = {
    filetypes = {
      markdown = false,
      text = false,
    },
    copilot_node_command = vim.fn.system("mise which node --cd=\"$HOME\""):gsub("\n", ""),
  },
}

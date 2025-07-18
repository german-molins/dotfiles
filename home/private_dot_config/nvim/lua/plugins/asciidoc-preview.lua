return {
  "tigion/nvim-asciidoc-preview",
  ft = { "asciidoc" },
  build = "cd server && npm install --omit=dev",
  ---@module 'asciidoc-preview'
  ---@type asciidoc-preview.Config
}

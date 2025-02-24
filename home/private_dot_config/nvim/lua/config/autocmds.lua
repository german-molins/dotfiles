local TEXT_FILETYPES = {
  "text",
  "plaintex",
  "typst",
  "gitcommit",
  "markdown",
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = TEXT_FILETYPES,
  callback = function()
    vim.opt.formatoptions:append("a")
  end,
})

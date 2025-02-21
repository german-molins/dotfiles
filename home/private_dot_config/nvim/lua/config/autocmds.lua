local TEXT_FILETYPES = {
  "text",
  "plaintex",
  "typst",
  "gitcommit",
  "markdown",
}

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  pattern = TEXT_FILETYPES,
  callback = function()
    vim.opt_local.spell = false
    vim.opt_local.wrap = true
  end,
})

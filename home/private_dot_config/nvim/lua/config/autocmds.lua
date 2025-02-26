local TEXT_FILETYPES = {
  "text",
  "plaintex",
  "typst",
  "gitcommit",
  "markdown",
}

--[[ 
Enable automatic formatting ('a' option) for text files,
but only when not in diff mode to preserve diff view formatting.
]]
--
vim.api.nvim_create_autocmd("FileType", {
  pattern = TEXT_FILETYPES,
  callback = function()
    if not vim.o.diff then
      vim.opt.formatoptions:append("a")
    end
  end,
})

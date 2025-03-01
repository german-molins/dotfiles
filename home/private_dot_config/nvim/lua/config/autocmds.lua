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

local ts_utils = require("nvim-treesitter.ts_utils")

-- Function to check if the cursor is in a specific Treesitter node type
local function is_cursor_in_node_type(node_types)
  local node = ts_utils.get_node_at_cursor()
  while node do
    local type = node:type()
    if vim.tbl_contains(node_types, type) then
      return true
    end
    node = node:parent()
  end
  return false
end

-- Function to toggle formatoptions based on cursor position
local function toggle_formatoptions()
  local node_types = { "code_fence_content", "quote_block", "frontmatter" }
  if is_cursor_in_node_type(node_types) then
    vim.bo.formatoptions = vim.bo.formatoptions:gsub("a", "") -- Disable autoformatting
  else
    if not vim.bo.formatoptions:match("a") then
      vim.bo.formatoptions = vim.bo.formatoptions .. "a" -- Re-enable autoformatting
    end
  end
end

-- Set up an autocommand to toggle formatoptions on cursor movement
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  pattern = "markdown",
  callback = toggle_formatoptions,
})

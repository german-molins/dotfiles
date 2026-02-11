local M = {}

function M.require_all_modules_in_dir(dir)
  local files = vim.fn.readdir(dir, [[v:val =~ '\.lua$']])

  for _, file in ipairs(files) do
    local module_path = dir .. "/" .. file
    local module_name = file:gsub("%.lua$", "")
    local is_directory = vim.fn.isdirectory(module_path) == 1

    if is_directory then
      M.require_all_modules_in_dir(module_path)
    else
      local require_path = dir:gsub("^" .. vim.fn.getcwd() .. "/", ""):gsub("/", ".") .. "." .. module_name
      require(require_path)
    end
  end
end

return M

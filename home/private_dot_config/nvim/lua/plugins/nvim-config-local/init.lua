local module_loader = require("plugins.nvim-config-local.module_loader")

local function create_or_append_nvim_lua(nvim_lua_path)
  local file = io.open(nvim_lua_path, "a+")

  vim.fn.mkdir(vim.fn.getcwd() .. "/.nvim", "p")

  if file then
    file:write("\n-- Custom Lua module loading mechanism\n")
    file:write("require('plugins.nvim-config-local.module_loader')\n")
    file:write("  .require_all_modules_in_dir(vim.fn.getcwd() .. '/.nvim')\n")
    file:close()
  end
end

local Path = require("plenary.path")

vim.api.nvim_create_user_command("DotfilesConfigCopy", function()
  local templates_dir = vim.fn.stdpath("config") .. "/lua/plugins/nvim-config-local/templates"
  local files = vim.fn.readdir(templates_dir, [[v:val =~ '\.lua$']])

  require("fzf-lua").fzf_exec(files, {
    prompt = "Select template> ",
    actions = {
      ["default"] = function(selected)
        local src = Path:new(templates_dir, selected[1])
        local dest = Path:new(vim.fn.getcwd(), ".nvim", selected[1])
        dest:parent():mkdir({ parents = true })
        src:copy({ destination = dest })
        print("Template file copied to .nvim/: " .. selected[1])
      end,
    },
  })
end, {})

vim.api.nvim_create_user_command("DotfilesConfigInit", function()
  local nvim_lua_path = vim.fn.getcwd() .. "/.nvim.lua"

  create_or_append_nvim_lua(nvim_lua_path)
  print(".nvim.lua initialized or updated")
end, {})

return {
  "klen/nvim-config-local",
  opts = {
    config_files = { ".nvim.lua" },
  },
}

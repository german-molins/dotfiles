local function is_monorepo(file)
  return string.find(file, "/packages/") ~= nil
end

local function get_monorepo_package_path(file)
  if is_monorepo(file) then
    return string.match(file, "(.-/packages/[^/]+)")
  end
  return nil
end

local function get_package_path(file)
  if is_monorepo(file) then
    return get_monorepo_package_path(file)
  else
    return vim.fn.getcwd()
  end
end

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/neotest-jest",
  },
  opts = {
    adapters = {
      ["neotest-python"] = {},

      ["neotest-jest"] = {
        jestCommand = "npm test --",
        jestConfigFile = function(file)
          return get_package_path(file) .. "/jest.config.ts"
        end,
        env = { CI = true },
        cwd = function(file)
          return get_package_path(file)
        end,
      },
    },
    status = { virtual_text = true },
    output = { open_on_run = true },
    quickfix = {
      open = function()
        if LazyVim.has("trouble.nvim") then
          require("trouble").open({ mode = "quickfix", focus = false })
        else
          vim.cmd("copen")
        end
      end,
    },
  },
  keys = function(_, keys)
    table.insert(keys, {
      "<leader>tT",
      function()
        local file = vim.fn.expand("%:p")
        local cwd = get_package_path(file)

        require("neotest").run.run(cwd)
      end,
      desc = "Run All Test Files (Neotest)(dotfiles)",
    })
  end,
}

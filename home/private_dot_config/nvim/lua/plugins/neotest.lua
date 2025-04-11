local function get_monorepo_package_path(file)
  if string.find(file, "/packages/") then
    return string.match(file, "(.-/packages/[^/]+)")
  end
  return nil
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
          local package_path = get_monorepo_package_path(file)
          if package_path then
            return package_path .. "/src/jest.config.ts"
          end
          return vim.fn.getcwd() .. "/jest.config.ts"
        end,
        env = { CI = true },
        cwd = function(file)
          return get_monorepo_package_path(file) or vim.fn.getcwd()
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
        local cwd = vim.fn.getcwd()
        local file = vim.fn.expand("%:p")

        local package_path = get_monorepo_package_path(file)
        if package_path then
          cwd = package_path
        end

        require("neotest").run.run(cwd)
      end,
      desc = "Run All Test Files (Neotest)(dotfiles)",
    })
  end,
}

local function is_monorepo(file)
  return string.find(file, "/packages/") ~= nil
end

local function get_monorepo_package_path(file)
  if is_monorepo(file) then
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
          local cwd

          if is_monorepo(file) then
            cwd = get_monorepo_package_path(file)
          else
            cwd = vim.fn.getcwd()
          end

          return cwd .. "/jest.config.ts"
        end,
        env = { CI = true },
        cwd = function(file)
          if is_monorepo(file) then
            return get_monorepo_package_path(file)
          else
            return vim.fn.getcwd()
          end
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
        local cwd

        if is_monorepo(file) then
          cwd = get_monorepo_package_path(file)
        else
          cwd = vim.fn.getcwd()
        end

        require("neotest").run.run(cwd)
      end,
      desc = "Run All Test Files (Neotest)(dotfiles)",
    })
  end,
}

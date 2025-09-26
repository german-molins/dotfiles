return {
  "zk-org/zk-nvim",
  config = function()
    require("zk").setup({
      picker = "fzf_lua",

      lsp = {
        config = {
          cmd = { "zk", "lsp" },
          name = "zk",
        },

        auto_attach = {
          enabled = true,
          filetypes = { "markdown" },
        },
      },
    })

    local commands = require("zk.commands")
    commands.add("ZkNewLink", function(options)
      local title = vim.fn.input("Title: ")
      if title == "" then
        return
      end
      require("zk.api").new(nil, { title = title, dir = "archive" }, function(err, res)
        if err then
          vim.notify("Error creating note: " .. err, vim.log.levels.ERROR)
          return
        end

        local filename = vim.fn.fnamemodify(res.path, ":t:r")
        local link = string.format("[[%s|%s]]", filename, title)
        vim.api.nvim_put({ link }, "c", true, true)

        vim.cmd("edit " .. res.path)
        local buf = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(buf)
        vim.api.nvim_win_set_cursor(0, { line_count, 0 })
        vim.cmd("startinsert")
      end)
    end)

    commands.add("ZkNewJournal", function(options)
      require("zk.api").new(nil, { dir = "journal" }, function(err, res)
        if err then
          vim.notify("Error creating journal note: " .. err, vim.log.levels.ERROR)
          return
        end

        vim.cmd("edit " .. res.path)
        local buf = vim.api.nvim_get_current_buf()
        local line_count = vim.api.nvim_buf_line_count(buf)
        vim.api.nvim_win_set_cursor(0, { line_count, 0 })
        vim.cmd("startinsert")
      end)
    end)

    vim.keymap.set("n", "<leader>zn", ":ZkNewLink<CR>", { desc = "Create new Zk note with link" })
    vim.keymap.set("n", "<leader>zj", ":ZkNewJournal<CR>", { desc = "Create new Zk journal note" })
  end,
}

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<CR>", ":wa<CR>", { desc = "Write all buffers", silent = true })
vim.keymap.set("n", "<BS>", ":xall<CR>", { desc = "Write all buffers and exit" })

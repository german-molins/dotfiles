-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<CR>", "<cmd>wa<CR>", { desc = "Write all buffers" })
vim.keymap.set("n", "<BS>", "<cmd>xall<CR>", { desc = "Write all buffers and exit" })

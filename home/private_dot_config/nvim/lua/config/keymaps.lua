-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Map Enter in normal mode to write all buffers
vim.keymap.set('n', '<CR>', ':wa<CR>', { desc = 'Write all buffers' })

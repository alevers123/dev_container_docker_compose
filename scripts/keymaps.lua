-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = LazyVim.safe_keymap_set

map("i", "jj", "<ESC>", {desc="Leave insert mode", silent=true})
map("i", "<C-j>", "<Down>", {desc="Move down in insert mode", silent=true})
map("i", "<C-k>", "<Up>", {desc="Move up in insert mode", silent=true})
map("i", "<C-h>", "<Left>", {desc="Move left in insert mode", silent=true})
map("i", "<C-l>", "<Right>", {desc="Move right in insert mode", silent=true})
map("n", "<leader>o", "o<ESC>", {desc="Insert line below in normal mode", silent=true})
map("n", "<leader>O", "O<ESC>", {desc="Insert line below in normal mode", silent=true})

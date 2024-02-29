-- Functional wrapper for mapping custom keybindings
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Colemak: hjkl to mnei, and i to t

local customKeyboardAvailable = true
-- Only if custom keyboard with layers or kmonad not available
if not customKeyboardAvailable then
  map("n", "m", "h")  -- move Lef
  map("n", "n", "gj") -- move Down (g to allow move within wrapped lines)
  map("n", "e", "gk") -- move Up (g to allow move within wrapped lines)
  map("n", "i", "l")  -- move Right
  map("n", "l", "i")  -- (t)ype           replaces (i)nsert
  map("n", "L", "I")  -- (T)ype at bol    replaces (I)nsert
  map("n", "j", "e")  -- end of word      replaces (e)nd
  map("n", "h", "n")  -- next match       replaces (n)ext
  map("n", "H", "N")  -- previous match   replaces (N) prev

  -- Visual Colemak
  map("v", "m", "h")  -- move Left
  map("v", "n", "gj") -- move Down (g to allow move within wrapped lines)
  map("v", "e", "gk") -- move Up (g to allow move within wrapped lines)
  map("v", "i", "l")  -- move Right
end

-- Swap ; and : to enter commands without pressing shift
map("n", ";", ":")
map("n", ":", ";")

-- Diagnostcs
vim.keymap.set('n', '<leader>ie', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>in', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<C-S-m>', "<C-w>h", {})
vim.keymap.set('n', '<C-S-n>', "<C-w>j", {})
vim.keymap.set('n', '<C-S-e>', "<C-w>k", {})
vim.keymap.set('n', '<C-S-i>', "<C-w>l", {})


if HARPOON_IS_ACTIVE then
  local harpoon = require("harpoon")
  vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
  vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

  vim.keymap.set("n", "<C-n>", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<C-e>", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<C-i>", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<C-o>", function() harpoon:list():select(4) end)

  -- Toggle previous & next buffers stored within Harpoon list
  vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
  vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
end

-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Colemak: hjkl to mnei, and i to t
map("n", "m", "h")  -- move Left
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

-- Swap ; and : to enter commands without pressing shift
map("n", ";", ":")
map("n", ":", ";")

-- Diagnostcs
vim.keymap.set('n', '<leader>ie', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>in', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<C-m>', "<C-w>h", {})
vim.keymap.set('n', '<C-n>', "<C-w>j", {})
vim.keymap.set('n', '<C-e>', "<C-w>k", {})
vim.keymap.set('n', '<C-i>', "<C-w>l", {})

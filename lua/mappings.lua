-- Keymaps for better default experience
--
--
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wraasta
--
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })




vim.keymap.set('n', '<leader>q', ":q<cr>", { desc = 'Quit' })

vim.keymap.set('n', 'n', "nzz", { silent = true, noremap = true })
vim.keymap.set('n', 'N', "Nzz", { silent = true, noremap = true })

-- Custom
vim.keymap.set({ 'n', 'v' }, 'gl', "$", { silent = true, noremap = true })         -- go last char on line
vim.keymap.set({ 'n', 'v' }, 'gh', "_", { silent = true, noremap = true })         -- go first char on line
vim.keymap.set({ 'n' }, '<leader>p', ":b#<cr>", { silent = true, noremap = true }) -- go to previous buffer

-- HOP
vim.keymap.set('n', 's', ":HopChar2<cr>", { silent = true, noremap = true })

--Redo with U
vim.keymap.set('n', 'U', "<C-r>", { silent = true, noremap = true })

-- Vertical scrolling
vim.keymap.set('n', '<C-d>', "<C-d>zz", { silent = true, noremap = true })
vim.keymap.set('n', '<C-u>', "<C-u>zz", { silent = true, noremap = true })


-- Buffer handling
vim.keymap.set('n', '<leader>w', ":w<cr>", { desc = 'save', noremap = true })
vim.keymap.set('n', '<leader>x', ":bd<cr>", { desc = 'Close buffer', noremap = true })


if COLEMAK_MODE then
  -- Neotree
  vim.keymap.set('n', '<leader>t', ":Neotree toggle<cr>", { desc = 'Toggle neotree', noremap = true })

  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>ie', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', '<leader>in', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
  vim.keymap.set('n', '<leader>if', ":Format<cr>", { desc = 'Format' })

  if HARPOON_IS_ACTIVE then
    local harpoon = require("harpoon")
    vim.keymap.set("n", "<C-y>", function() harpoon:list():append() end)
    vim.keymap.set("n", "<leader>n", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<C-n>", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<C-e>", function() harpoon:list():select(2) end)
    vim.keymap.set("n", "<C-i>", function() harpoon:list():select(3) end)
    vim.keymap.set("n", "<C-o>", function() harpoon:list():select(4) end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
    vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
  end
else
  -- Neotree
  vim.keymap.set('n', '<leader>e', ":Neotree toggle<cr>", { desc = 'Toggle neotree', noremap = true })
  -- Diagnostic keymaps
  vim.keymap.set('n', '<leader>lk', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', '<leader>lj', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
  vim.keymap.set('n', '<leader>lf', ":Format<cr>", { desc = 'Format' })
end

-- Keymaps for better default experience
--
--
-- See `:help vim.keymap.set()`

-- Remap for dealing with word

vim.keymap.set('n', 'n', 'nzz', { silent = true, noremap = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true, noremap = true })

vim.keymap.set('n', '<leader>v', ':vsplit<cr>', { silent = true, noremap = true, desc = 'split' })

-- Map <leader>y to yank to the system clipboard
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })

-- Map <leader>p to paste from the system clipboard
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>p', '"+p', { noremap = true, silent = true })


-- Custom
vim.keymap.set({ 'n' }, 'L', ':b#<cr>', { silent = true, noremap = true }) -- go to previous buffer

-- Quick fix
vim.keymap.set('n', '<Leader>n', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>p', ':cprev<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', ':cclose<CR>', { noremap = true, silent = true })

-- TODO
vim.keymap.set('n', '<Leader>Q', ':TodoQuickFix<CR>', { noremap = true, silent = true, desc = 'Show todo quick fix' })

-- HOP
vim.keymap.set('n', 's', ':HopChar2<cr>', { silent = true, noremap = true })

--Redo with U
vim.keymap.set('n', 'U', '<C-r>', { silent = true, noremap = true })

-- Vertical scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { silent = true, noremap = true })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { silent = true, noremap = true })

-- Buffer handling
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = 'save', noremap = true })
vim.keymap.set('n', '<leader>x', ':bd<cr>', { desc = 'Close buffer', noremap = true })

-- Neotree
vim.keymap.set('n', '<leader>e', ':Neotree toggle<cr>', { desc = 'Toggle neotree', noremap = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>lk', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '<leader>lj', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>lf', ':Format<cr>', { desc = 'Format' })

-- python ENVS
-- vim.keymap.set('n', '<leader>lj', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

if HARPOON_IS_ACTIVE then
    local harpoon = require 'harpoon'
    vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():append()
    end, { desc = 'Add to harpoon' })
    vim.keymap.set('n', '<leader>j', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set('n', '<C-j>', function()
        harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<C-k>', function()
        harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<C-l>', function()
        harpoon:list():select(3)
    end)
    vim.keymap.set('n', '<C-;>', function()
        harpoon:list():select(4)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>hp', function()
        harpoon:list():prev()
    end)
    vim.keymap.set('n', '<leader>hn', function()
        harpoon:list():next()
    end)
end

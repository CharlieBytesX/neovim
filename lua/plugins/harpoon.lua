-- navigates to next mark



vim.keymap.set('n', '<leader>hm', require('harpoon.mark').add_file, { noremap = true, desc = "mark" })
vim.keymap.set('n', '<leader>hh', require('harpoon.ui').toggle_quick_menu, { noremap = true })
vim.keymap.set('n', '<leader>hn', require('harpoon.ui').nav_next, { noremap = true })
vim.keymap.set('n', '<leader>hp', require('harpoon.ui').nav_prev, { noremap = true })

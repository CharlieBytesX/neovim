-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
-- vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.number = true

vim.opt.scrolloff = 10
-- vim.o.cmdheight = 0

-- Enable mouse mode
vim.o.mouse = 'a'
vim.o.wrap = false

vim.opt.splitright = true
vim.opt.tabstop = 2
-- Set the number of spaces to use for each level of indentation
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- vim.opt.expandtab = true

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menu,menuone,noselect'

vim.o.termguicolors = true

-- Toggle between autoformat
vim.cmd [[
  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
  augroup END
]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '



COLEMAK_MODE = true


require("setup_lazy")
require("plugins")
require("options")

require("autocmd")


-- fire outside config
require('neodev').setup()
require("plugins.lsp")

local colorschemes = {
  Mocha = "catppuccin-mocha",
  RosepineMoon = "rose-pine-moon",
  RosepineMain = "rose-pine-main",
}

local colorscheme = colorschemes.RosepineMoon

vim.cmd('colorscheme ' .. colorscheme)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
require("mappings")
if COLEMAK_MODE then
  require("colemak")
end

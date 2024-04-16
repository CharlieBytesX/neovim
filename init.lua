-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '



-- Takes env variable (setted every time with an alias in the shell config, for quick change between colemak and qwerty mode)

local colemakEnvValue = os.getenv("COLEMAK_MODE")
COLEMAK_MODE = (colemakEnvValue == "true") or (colemakEnvValue == 1)


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

require("mappings")

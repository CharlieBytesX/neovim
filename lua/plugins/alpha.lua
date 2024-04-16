local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'
dashboard.section.header.val = vim.split([[








██╗  ██╗██╗███████╗███████╗
██║ ██╔╝██║██╔════╝██╔════╝
█████╔╝ ██║███████╗███████╗
██╔═██╗ ██║╚════██║╚════██║
██║  ██╗██║███████║███████║
╚═╝  ╚═╝╚═╝╚══════╝╚══════╝



  ]], "\n")
dashboard.section.buttons.val = {}
local function pick_color()
  local colors = { "String", "Identifier", "Keyword", "Number" }
  return colors[math.random(#colors)]
end

dashboard.section.header.opts.hl = "Number"

local handle = io.popen('fortune')
local fortune = handle:read("*a")
handle:close()
dashboard.section.footer.val = fortune

dashboard.config.opts.noautocmd = true

vim.cmd [[autocmd User AlphaReady echo 'ready']]

alpha.setup(dashboard.config)

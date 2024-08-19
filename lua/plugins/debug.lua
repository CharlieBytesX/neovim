local dap, dapui = require "dap", require "dapui"

-- Setup Telescope dap extension
local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
  telescope.load_extension "dap"
end

-- Setup cmp dap
local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
    sources = cmp.config.sources({
      { name = "dap" },
    }, {
      { name = "buffer" },
    }),
  })
end

-- Set Icons
vim.api.nvim_call_function(
  "sign_define",
  { "DapBreakpoint", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
)

vim.api.nvim_call_function(
  "sign_define",
  { "DapBreakpointCondition", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
)

vim.api.nvim_call_function(
  "sign_define",
  { "DapLogPoint", { linehl = "", text = "", texthl = "diffRemoved", numhl = "" } }
)

vim.api.nvim_call_function(
  "sign_define",
  { "DapStopped", { linehl = "GitSignsChangeVirtLn", text = "", texthl = "diffChanged", numhl = "" } }
)

vim.api.nvim_call_function(
  "sign_define",
  { "DapBreakpointRejected", { linehl = "", text = "", texthl = "", numhl = "" } }
)

-- Setup DAPUI
dapui.setup({

  icons = { collapsed = "", current_frame = "", expanded = "" },
  layouts = {
    {
      elements = {
        { id = "breakpoints", size = 0.1 },
        { id = "watches",     size = 0.1 },
        { id = "scopes",      size = 0.8 },
      },
      size = 80,
      position = "left",
    },
    -- { elements = { "console", "repl" }, size = 0.25, position = "bottom" },
    { elements = { "console" }, size = 0.25, position = "bottom" },
    { elements = { "repl" },    size = 0.20, position = "bottom" },
  },
  force_buffers = true,
  render = {
    indent = 2,
    max_type_length = 6,
    max_value_lines = 1,
  },
})

-- vim.keymap.set('n', '<leader>e', ':Neotree toggle<cr>', { desc = 'Toggle neotree', noremap = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require("dapui").close()<CR>',
  { desc = "close dap ui", noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>do', ':lua require("dapui").open()<CR>',
  { desc = "open dap ui", noremap = true, silent = true })

vim.keymap.set('n', '<leader>dd', function() require('dap').continue() end)
-- vim.keymap.set('n', '', function() require('dap').step_over() end)
-- vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
-- vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
-- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
vim.keymap.set('n', '<Leader>dlp',
  function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
vim.keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
vim.keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

-- Setup Virtual Text
require("nvim-dap-virtual-text").setup {}


dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

require("language_specific.rust.utils_local")
require("language_specific.rust.dap")
require("language_specific.rust.test_run")
require("language_specific.rust.test_debug")

-- Function to setup key mappings in Neovim
function SetupRustMappings()
  -- Map keys to run tests, build, and run the Rust project
  vim.api.nvim_set_keymap('n', '<leader>rt', ':lua RunRustTests()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>rs', ':lua SelectAndRunTest()<CR>',
    { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>rr', ':lua BuildAndRunRust()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>rb', ':lua BuildRustProject()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ra', ':lua GetCurrentFileNameForRust()<CR>', { noremap = true, silent = true })
  -- DEBUG TEST

  vim.api.nvim_set_keymap('n', '<leader>dt', ':lua SelectAndDebugTest()<CR>', { noremap = true, silent = true })
end

-- Call the setup function to set the mappings
SetupRustMappings()

local dap = require('dap')
local utils = require("general_utils")
require("language_specific.rust.utils_local")

-- Configure nvim-dap for codelldb
dap.adapters.lldb = {
  type = 'executable',
  command = '/home/charlie/.local/share/nvim/mason/bin/codelldb', -- Replace with the path to your codelldb executable
  name = "lldb"
}

-- Function to get executables from target/debug and target/release
local function get_executables()
  local targets = {}
  local workspace_root = Get_workspace_folder_from_rust_analyzer()
  print("root:", workspace_root)
  if not workspace_root then
    print("No workspace folder found")
    return targets
  end

  local target_dirs = { 'target/debug', 'target/release' }

  for _, dir in ipairs(target_dirs) do
    local target_dir = workspace_root .. '/' .. dir
    for file in io.popen('ls ' .. target_dir):lines() do
      table.insert(targets, target_dir .. '/' .. file)
    end
  end

  return targets
end

function PrintWorkspace()
  print(utils.Tprint(get_executables(), 2))
end

dap.configurations.rust = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      local targets = get_executables()
      if #targets == 0 then
        print("No executables found")
        return nil
      end
      return vim.fn.input('Choose executable: ', targets[1], 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

vim.api.nvim_set_keymap('n', '<leader>dd', ':lua PrintWorkspace()<CR>',
  { noremap = true, silent = true })

require("dapui").setup({})

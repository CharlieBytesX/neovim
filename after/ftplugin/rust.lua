--
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

-- Function to get the current file name without extension
function GetCurrentFileNameForRust()
  local file_path = vim.api.nvim_buf_get_name(0)
  -- Get the active LSP clients for the current buffer
  local clients = vim.lsp.get_clients()

  -- Check if there is at least one active client
  if next(clients) == nil then
    print("No active LSP client found.")
    return
  end

  local work_dir = ""
  -- Iterate over the clients to get the root directory (usually there will be only one per buffer)
  for _, client in ipairs(clients) do
    if client.config.root_dir then
      work_dir = client.config.root_dir
    end
  end
  if not work_dir then
    work_dir = ""
  end

  local result = string.gsub(file_path, work_dir, "")
  result = string.gsub(result, "/src/", "")
  local segments = {}

  -- Split the path into segments by '/'
  for segment in string.gmatch(result, "([^/]+)") do
    table.insert(segments, segment)
  end

  -- Remove the last segment
  table.remove(segments) -- Removes the last segment

  -- Rebuild the path
  result = table.concat(segments, "::")
  result = result .. "::test"
  return result
end

-- Function to extract test functions from the current file
function ExtractTests()
  local tests = {}
  -- Get the contents of the current buffer
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    -- Simple pattern matching for Rust test functions (e.g., #[test] or fn test_* )
    if line:match("^%s*fn%s+test_[%w_]*") then
      -- Extract the test name
      local test_name = line:match("fn%s+(test_[%w_]+)")
      if test_name then
        table.insert(tests, test_name)
      end
    end
  end
  return tests
end

-- Function to prompt the user to select a test to run
function SelectAndRunTest()
  -- Extract tests from the current file
  local tests = ExtractTests()

  if #tests == 0 then
    print("No tests found in this file.")
    return
  end

  -- Add an option to run all tests
  table.insert(tests, 1, "Run all tests")
  -- Telescope picker for selecting a test
  pickers.new({}, {
    prompt_title = "Select Test to Run",
    finder = finders.new_table({
      results = tests
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      -- Define what happens on selection
      actions.select_default:replace(function()
        local choice = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if choice == nil then
          print("Invalid selection.")
          return
        end

        -- Run the selected test or all tests
        if choice.index == 1 then
          -- Run all tests in the current file
          local file_name = GetCurrentFileNameForRust()
          if file_name then
            vim.cmd("tabnew | terminal cargo test  " .. file_name)
          else
            print("Could not determine file name.")
          end
        else
          -- Run the selected test
          local selected_test = choice.value
          vim.cmd("vsplit | terminal cargo test " .. selected_test)
        end
      end)

      return true
    end,
  }):find()

  -- -- Present a selection prompt to the user
  -- local options = {}
  -- for i, test in ipairs(tests) do
  --   table.insert(options, string.format("%d. %s", i, test))
  -- end
  --
  -- -- Use vim's inputlist to prompt the user to choose a test
  -- local choice = vim.fn.inputlist(options)
  --
  -- if choice < 1 or choice > #tests then
  --   print("Invalid selection.")
  --   return
  -- end
  -- -- Run the selected test or all tests
  -- if choice == 1 then
  --   -- Run all tests in the current file
  --   local file_name = GetCurrentFileNameForRust()
  --   if file_name then
  --     vim.cmd("tabnew | terminal cargo test  " .. file_name)
  --   else
  --     print("Could not determine file name.")
  --   end
  -- else
  --   -- Run the selected test
  --   local selected_test = tests[choice]
  --   vim.cmd("split | terminal cargo test " .. selected_test)
  -- end
end

-- Function to run Rust tests
function RunRustTests()
  -- Open a new split terminal to run the tests
  vim.cmd(" tabnew | terminal cargo test")
end

-- Function to build and run the Rust project
function BuildAndRunRust()
  -- Open a new split terminal to build and run the project
  vim.cmd("tabnew | terminal cargo run")
end

-- Optional: Function to just build the Rust project
function BuildRustProject()
  -- Open a new split terminal to build the project
  vim.cmd("tanew | terminal cargo build")
end

-- Function to setup key mappings in Neovim
function SetupRustMappings()
  -- Map keys to run tests, build, and run the Rust project
  vim.api.nvim_set_keymap('n', '<leader>rt', ':lua RunRustTests()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>rs', ':lua SelectAndRunTest()<CR>',
    { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>rr', ':lua BuildAndRunRust()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>rb', ':lua BuildRustProject()<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<leader>ra', ':lua GetCurrentFileNameForRust()<CR>', { noremap = true, silent = true })
end

-- Call the setup function to set the mappings
SetupRustMappings()

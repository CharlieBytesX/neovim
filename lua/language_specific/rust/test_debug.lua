local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local dap = require('dap')


-- Function to get the current Rust file's name
function GetCurrentRustFileName()
  -- Get the current file path
  local file_path = vim.api.nvim_buf_get_name(0)

  -- Extract the file name from the file path
  local file_name = file_path:match("([^/]+)%.rs$")

  if file_name then
    return file_name
  else
    print("Current file is not a Rust file.")
    return nil
  end
end

-- Function to find the correct test binary name
function FindTestBinaryName()
  local result = vim.fn.system("ls target/debug/deps/ | grep -E '^.*-.*\\.dylib$'") -- Adjust pattern for your OS
  if vim.v.shell_error == 0 then
    local binaries = vim.split(result, "\n")
    if #binaries > 0 then
      return binaries[1] -- Use the first binary found (adjust if needed)
    end
  end
  print("Test binary not found.")
  return nil
end

function SelectAndDebugTest()
  -- Extract tests from the current file
  local tests = ExtractTests()

  if #tests == 0 then
    print("No tests found in this file.")
    return
  end

  -- Prefix each test with a number for easier selection
  local numbered_tests = {}
  for i, test in ipairs(tests) do
    table.insert(numbered_tests, string.format("%d. %s", i, test))
  end

  -- Telescope picker for selecting a test to debug
  pickers.new({}, {
    prompt_title = "Select Test to Debug",
    finder = finders.new_table({
      results = numbered_tests
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      -- Default action (selection via arrow keys or input) handling
      actions.select_default:replace(function()
        -- Get the currently selected item (the highlighted item)
        local selected_entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Extract the selected number from the displayed entry
        local choice = tonumber(selected_entry.value:match("^(%d+)"))

        if choice and choice > 0 and choice <= #tests then
          -- Get the selected test function name
          local selected_test = tests[choice]

          -- Get the current Rust file's name
          local file_name = GetCurrentRustFileName()

          if file_name then
            -- Compile the test binary using cargo
            local compile_result = vim.fn.system("cargo test --no-run")
            if vim.v.shell_error ~= 0 then
              print("Failed to compile tests:", compile_result)
              return
            end

            -- Find the correct test binary name
            local binary_name = FindTestBinaryName()

            if binary_name then
              -- Start DAP to debug the selected test
              dap.run({
                type = "lldb", -- The type must match your debugger adapter setup
                request = "launch",
                program = function()
                  -- Generate the path to the test binary
                  return vim.fn.getcwd() .. "/target/debug/deps/" .. binary_name
                end,
                args = { "--nocapture", selected_test }, -- Run the selected test function
                cwd = vim.fn.getcwd(),                   -- Set the working directory
                stopOnEntry = false,
                runInTerminal = true,
              })
            else
              print("Unable to determine the test binary name.")
            end
          else
            print("Unable to determine the current Rust file name.")
          end
        else
          print("Invalid selection.")
        end
      end)

      return true
    end,
  }):find()
end

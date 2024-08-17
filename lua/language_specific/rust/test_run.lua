--
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values


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

  local rust_project_workspace = Get_workspace_folder_from_rust_analyzer()

  -- Prefix each test with a number for easier selection
  local numbered_tests = {}
  for i, test in ipairs(tests) do
    table.insert(numbered_tests, string.format("%d. %s", i, test))
  end

  -- Telescope picker for selecting a test
  pickers.new({}, {
    prompt_title = "Select Test to Run",
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

        if choice == 1 then
          -- Run all tests in the current file
          local file_name = GetCurrentFileNameForRust()
          if file_name then
            vim.cmd("tabnew | terminal cd " .. rust_project_workspace .. "  cargo test " .. file_name)
          else
            print("Could not determine file name.")
          end
        else
          -- Run the selected test
          local selected_test = tests[choice]
          vim.cmd("tabnew | terminal cd " .. rust_project_workspace .. "  cargo test " .. selected_test)
        end
      end)

      -- Handle pressing Enter in insert mode after typing a number or navigating
      map('i', '<CR>', function()
        local prompt_text = action_state.get_current_line()
        local selected_number = tonumber(prompt_text)

        if selected_number and selected_number >= 1 and selected_number <= #numbered_tests then
          actions.close(prompt_bufnr)

          -- Run the selected test or all tests
          if selected_number == 1 then
            -- Run all tests in the current file
            local file_name = GetCurrentFileNameForRust()
            if file_name then
              vim.cmd("tabnew | terminal cd " .. rust_project_workspace .. "  cargo test " .. file_name)
            else
              print("Could not determine file name.")
            end
          else
            -- Run the selected test
            local selected_test = tests[selected_number]
            vim.cmd("tabnew | terminal cd " .. rust_project_workspace .. "  cargo test " .. selected_test)
          end
        else
          -- No number was typed; run the currently highlighted option
          actions.select_default(prompt_bufnr)
        end
      end)

      return true
    end,
  }):find()
end

-- Function to run Rust tests
function RunRustTests()
  local rust_project_workspace = Get_workspace_folder_from_rust_analyzer()
  -- Open a new split terminal to run the tests
  vim.cmd("tabnew |  terminal cd " .. rust_project_workspace .. " && cargo test")
end

-- Function to build and run the Rust project
function BuildAndRunRust()
  local rust_project_workspace = Get_workspace_folder_from_rust_analyzer()
  print("what:", rust_project_workspace)
  -- Open a new split terminal to build and run the project
  vim.cmd("tabnew |  terminal cd " .. rust_project_workspace .. "&& cargo run")
end

-- Optional: Function to just build the Rust project
function BuildRustProject()
  -- Open a new split terminal to build the project
  vim.cmd("tanew | terminal cargo build")
end

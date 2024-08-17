-- Function to get the current file name without extension
local utils = require("general_utils")
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

function Get_workspace_folder_from_rust_analyzer()
  local clients = vim.lsp.get_clients()
  for _, client in pairs(clients) do
    print(client.name)
    if client.name == 'rust_analyzer' then
      -- print(utils.Tprint(client.config, 2))
      return client.config.cmd_cwd
    end
  end
  return nil
end

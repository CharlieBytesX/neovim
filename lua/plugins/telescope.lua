-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
---@diagnostic disable-next-line: redundant-parameter
require('telescope').setup {
  pickers = {
    buffers = {
      -- sort_lastused = true, -- Sort buffers by last accessed time
      mappings = {
        i = {
          ["<c-d>"] = require('telescope.actions').delete_buffer + require('telescope.actions').move_to_top,
        },
        n = {
          ["<c-d>"] = require('telescope.actions').delete_buffer + require('telescope.actions').move_to_top,
        }
      }
    }

  },

  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

local function search_all_files_except_node_modules()
  require('telescope.builtin').find_files({
    find_command = {
      'rg', '--files', '--hidden', '--glob', '!.git/', '--glob', '!.node_modules/**', '!target/**'
    },
    prompt_title = "< Search All Files Except .node_modules >",
  })
end

local function search_files()
  require('telescope.builtin').find_files({
    find_command = {
      'rg', '--files', '--hidden', '--glob', '!.git/', '--glob', '!.node_modules/**'
    },
    prompt_title = "< Search All Files Except .node_modules >",
  })
end

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>f', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
local function search_methods_and_functions()
  require('telescope.builtin').lsp_document_symbols({
    symbols = { "method", "function" }
  })
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols, { desc = '[S]earch [S]ymbols' })
vim.keymap.set('n', '<leader>sf', search_methods_and_functions, { desc = '[S]earch [S]ymbols' })
-- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>o', search_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sa', search_all_files_except_node_modules, { desc = '[S]earch .[a]ll Files' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

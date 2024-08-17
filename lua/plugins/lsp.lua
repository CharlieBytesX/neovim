local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  nmap('K', vim.lsp.buf.hover, 'hover')
  nmap('<leader>lr', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>la', function()
    vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
  end, '[C]ode [A]ction')

  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>lds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<leader>lK', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- Create a command `:Format` local to the LSP buffer
end

local add_formatting = function(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.notify('Formatting with ' .. client.name)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.

require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  rust_analyzer = {},
  -- tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs', 'templ', "htmldjango" } },
  htmx = { filetypes = { 'html', 'templ', "htmldjango" } },
  emmet_language_server = { filetypes = { 'html', 'templ', 'typescriptreact', 'javascriptreact', 'htmldjango', 'svelte' } },
  --
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        if client.name ~= 'tsserver' and client.name ~= 'tailwindcss' then
          add_formatting(client, bufnr)
        end
      end,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

function ToggleLspVirtualText(display_mode)
  if vim.bo.filetype == '' then
    print 'No active LSP client for current buffer'
    return
  end

  if display_mode == 'underline' then
    vim.diagnostic.config { virtual_text = false, underline = true, signs = false }
  elseif display_mode == 'all' then
    vim.diagnostic.config { virtual_text = true, underline = true, signs = true }
  elseif display_mode == 'icons' then
    vim.diagnostic.config { virtual_text = false, underline = false, signs = true }
  elseif display_mode == 'underline&icons' then
    vim.diagnostic.config { virtual_text = false, underline = true, signs = true }
  else
    print 'Invalid display mode. Available options: underline, all, icons'
    return
  end
  print('LSP virtual text display mode set to ' .. display_mode)
end

vim.api.nvim_create_user_command('VTAll', function()
  ToggleLspVirtualText 'all'
end, {})

vim.api.nvim_create_user_command('VTUnderline', function()
  ToggleLspVirtualText 'underline'
end, {})

vim.api.nvim_create_user_command('VTIcons', function()
  ToggleLspVirtualText 'icons'
end, {})

vim.api.nvim_create_user_command('VTUnderlineIcons', function()
  ToggleLspVirtualText 'underline&icons'
end, {})

-- vim.diagnostic.config { virtual_text = false, underline = false, signs = true }

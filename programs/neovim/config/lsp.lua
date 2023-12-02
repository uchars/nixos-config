local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename)
  nmap('<leader>ca', vim.lsp.buf.code_action)

  nmap('gd', vim.lsp.buf.definition)
  nmap('gr', require('telescope.builtin').lsp_references)
  nmap('gI', require('telescope.builtin').lsp_implementations)
  nmap('<leader>D', vim.lsp.buf.type_definition)
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols)
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover)
  nmap('<C-k>', vim.lsp.buf.signature_help)

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration)
  nmap('[e', vim.diagnostic.goto_prev)
  nmap(']e', vim.diagnostic.goto_next)
  nmap('[E', function()
    vim.diagnostic.goto_prev {
      severity = vim.diagnostic.severity.ERROR,
      float = false,
    }
  end)
  nmap(']E', function()
    vim.diagnostic.goto_next {
      severity = vim.diagnostic.severity.ERROR,
      float = false,
    }
  end)
  nmap('[d', vim.diagnostic.goto_prev)
  nmap(']d', vim.diagnostic.goto_next)
  nmap('<leader>e', vim.diagnostic.open_float)
  nmap('<leader>vd', vim.diagnostic.open_float)
  nmap('<leader>q', vim.diagnostic.setloclist)

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('lspconfig').gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').clangd.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').cmake.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').bashls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').html.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { 'html', 'twig', 'hbs' },
}

require('lspconfig').lua_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').nil_ls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').marksman.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').dartls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').cssls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('lspconfig').ocamllsp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('fidget').setup {
  window = { blend = 0 },
  text = { spinner = 'earth' },
}

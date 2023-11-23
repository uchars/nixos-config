local null_ls = require 'null-ls'
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.dart_format,
    null_ls.builtins.formatting.nixfmt,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.clang_format,
  },
  on_attach = function(client, bufnr)
    if client.supports_method 'textDocument/formatting' then
      vim.api.nvim_clear_autocmds { buffer = bufnr }
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}

vim.api.nvim_create_user_command('DisableLspFormatting', function()
  vim.api.nvim_clear_autocmds { buffer = 0 }
end, { nargs = 0 })

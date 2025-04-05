-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
      'jayp0521/mason-null-ls.nvim',
    },

    config = function()
      local null_ls = require 'null-ls'
      local formatting = null_ls.builtins.formatting

      -- list of formatters & linters for mason to install
      require('mason-null-ls').setup {
        ensure_installed = {
          -- 'checkmake',
          'prettier', -- ts/js formatter
          'eslint_d', -- ts/js linter
          'shfmt',
          'ruff', -- python formatter
        },
        automatic_installation = true,
      }

      local sources = {
        formatting.prettier.with { filetypes = { 'json', 'yaml', 'markdown' } },
        formatting.shfmt.with { args = { '-i', '4' } },

        -- NOTE: extra arg sorts imports
        require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
        -- require 'none-ls.formatting.ruff_format',
      }

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
        sources = sources,
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { async = false }
              end,
            })
          end
        end,
      }
    end,
  },
}

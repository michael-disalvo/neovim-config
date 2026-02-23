return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    config = function()
      vim.lsp.config["rust_analyzer"] = {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = {
          'Cargo.lock',
          '.git',
          'Cargo.toml',
        },

        -- rust-analyzer specific settings
        settings = {
          ['rust-analyzer'] = {
            -- Disable diagnostics (no warnings/errors)
            diagnostics = { enable = false },

            -- Disable completions
            completion = {
              autoimport = false,
              autoself = false,
            },

            -- Optional: speed + quietness
            cargo = { loadOutDirsFromCheck = false },
            checkOnSave = false,
            procMacro = { enable = false },
          },
        },
      }

      vim.lsp.config["gopls"] = {
        settings = {
          gopls = {
            staticcheck = false,
          },
        },
      }

      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },

        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      --vim.lsp.enable("rust_analyzer")
      --vim.lsp.enable("gopls")
      vim.lsp.enable("lua_ls")

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('my.lsp', {}),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if not client:supports_method('textDocument/willSaveWaitUntil')
              and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
              end,
            })
          end

          client.server_capabilities.semanticTokensProvider = nil
        end,
      })
    end
  }
}

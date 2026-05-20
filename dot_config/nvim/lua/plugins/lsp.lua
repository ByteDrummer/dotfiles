return {
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {},
  },

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/cmp-path' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'rafamadriz/friendly-snippets' },
      { 'onsails/lspkind.nvim' },
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require("luasnip")

      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip').filetype_extend("javascript", { "javascriptreact" })

      cmp.setup({
        sources = {
          { name = 'lazydev' },
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'buffer',  keyword_length = 3 },
          { name = 'luasnip', keyword_length = 2 },
        },
        mapping = {
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-f>"] = cmp.mapping.scroll_docs(5),
          ["<C-b>"] = cmp.mapping.scroll_docs(-5),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end),
        },
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
            col_offset = -3,
            side_padding = 0,
          },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
          end
        }
      })
    end
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- LspAttach is where you enable features that only work if there is a
      -- language server active in the file
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions, opts)
          vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set('n', 'gi', require('telescope.builtin').lsp_implementations, opts)
          vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
          vim.keymap.set('n', 'go', require('telescope.builtin').lsp_type_definitions, opts)
          vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
          vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)

          vim.keymap.set({ 'n', 'x' }, '<F3>', function()
            local opts = {
              async = false,
              timeout_ms = 10000,
              filter = function(client)
                -- List of clients to exclude
                local exclude = { "ts_ls", "html" }
                -- Check if the client is in the exclude list
                return not vim.tbl_contains(exclude, client.name)
              end,
            }

            -- Check if we are in a visual mode
            local mode = vim.api.nvim_get_mode().mode
            if mode:match("^[vV\22]") then
              -- Exit visual mode
              vim.api.nvim_input("<Esc>")
              -- Set formatting range
              opts.range = {
                ["start"] = vim.api.nvim_buf_get_mark(0, '<'),
                ["end"] = vim.api.nvim_buf_get_mark(0, '>'),
              }
            end

            vim.lsp.buf.format(opts)
          end)

          vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = {
          style = 'minimal',
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
          },
        },
      })

      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      for _, server in ipairs(require('mason-lspconfig').get_installed_servers()) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      vim.lsp.config("ts_ls", {
        settings = {
          implicitProjectConfiguration = {
            checkJs = true
          }
        }
      })

      -- Automatically enable installed servers
      require("mason-lspconfig").setup()
    end
  },

  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'lua-language-server',
        'clangd',
        'pyright', 'ruff',
        'typescript-language-server', 'tailwindcss-language-server', 'prettier',
        'bash-language-server', 'shfmt', 'shellcheck',
        'dockerfile-language-server', 'docker-compose-language-service',
        'html-lsp',
        'json-lsp'
      }
    }
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      return
      {
        sources =
        {
          formatting.prettier,
          formatting.shfmt,
          require("none-ls.formatting.ruff"),
        }
      }
    end
  }
}

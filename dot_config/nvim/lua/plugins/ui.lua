return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    config = function()
      vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files)
      vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep)
      vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers)
      vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags)

      require('telescope').setup {
        pickers = {
          find_files = {
            hidden = true
          }
        }
      }
    end
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
  },

  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = {
        '*', -- Highlight all files, but customize some others.
        cmp_docs = { always_update = true },
        cmp_menu = { always_update = true }
      },
      user_default_options = {
        tailwind = true
      }
    }
  },

  { "unblevable/quick-scope" },

  {
    "karb94/neoscroll.nvim",
    opts = {}
  },

  {
    "navarasu/onedark.nvim",
    opts = {
      cmp_itemkind_reverse = true,
      transparent = true,
    },
    config = function(_, opts)
      require('onedark').setup(opts)
      require('onedark').load()
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#393f4a", fg = "NONE" })
      vim.api.nvim_set_hl(0, "BufferCurrent", { bg = "#282c34", fg = "#aab2bf", bold = true })
      vim.api.nvim_set_hl(0, "BufferCurrentSign", { bg = "#282c34", fg = "#c678dd" })
      vim.api.nvim_set_hl(0, "BufferCurrentMod", { bg = "#282c34", fg = "#d19a66", bold = true, italic = true })
      vim.api.nvim_set_hl(0, "BufferCurrentTarget", { bg = "#282c34", fg = "#e5c07b", bold = true })
      vim.api.nvim_set_hl(0, "BufferInactive", { bg = "#31353f", fg = "#848b98" })
      vim.api.nvim_set_hl(0, "BufferVisibleTarget", { bg = "#282c34", fg = "#e5c07b", bold = true })
      vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = "#848b98" })
      vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = "#848b98" })
      vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = "#848b98" })
      vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#aab2bf" })
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "▏" },
      scope = { enabled = false }
    }
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { '<F1>',      function() require("ui_modes"):tree_toggle() end, silent = true },
      { '<leader>n', ":NvimTreeFindFile<CR>",                          silent = true },
    },
    opts = {
      disable_netrw = true,
      hijack_netrw  = true,
      hijack_cursor = true,
      diagnostics   = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        }
      },
      filters       = {
        git_ignored = false,
      },
      view          = {
        width = 34,
      },
      renderer      = {
        indent_markers = {
          enable = true,
        },
        icons = {
          show = {
            folder_arrow = false,
          }
        },
      },
    }

  },

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local ts = require("nvim-treesitter")

      -- Automatic parser installation
      ts.install({
        'cpp',
        'javascript',
        'html',
        'python',
        'bash',
        'java',
        'json',
        'vim',
        'lua'
      })

      -- Feature activation
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true }),
        callback = function(args)
          local bufnr = args.buf

          -- Only enable if a parser is actually installed for this filetype
          local parser = vim.treesitter.get_parser(bufnr, nil, { error = false })
          if parser then
            -- Highlighting
            vim.treesitter.start(bufnr)

            -- Folding
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldmethod = 'expr'

            -- Indentation
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = true,
        globalstatus = true
      },
      sections = {
        lualine_a = {
          { 'mode', separator = { right = '', left = '' }, right_padding = 2 },
        },
        lualine_b = { 'branch', "diff",
          {
            'diagnostics',
            sections = { 'error', 'warn', 'info', 'hint' },
            symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }
          }
        },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = {
          { 'location', separator = { right = '', left = '' }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = {}
    }
  },

  {
    'romgrk/barbar.nvim',
    lazy = false,
    dependencies = {
      'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    keys = {
      { '<A-,>', ':BufferPrevious<CR>',     silent = true },
      { '<A-.>', ':BufferNext<CR>',         silent = true },
      { '<A-<>', ':BufferMovePrevious<CR>', silent = true },
      { '<A->>', ':BufferMoveNext<CR>',     silent = true },
      { '<A-c>', ':BufferClose<CR>',        silent = true },
      { '<A-p>', ':BufferPick<CR>',         silent = true },
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      exclude_ft = { 'dap-repl', 'qf' },
      exclude_name = { 'python' },
      icons = {
        modified = { button = '' }
      }
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)

        map('v', '<leader>hs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('v', '<leader>hr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)

        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hi', gitsigns.preview_hunk_inline)

        map('n', '<leader>hb', function()
          gitsigns.blame_line({ full = true })
        end)

        map('n', '<leader>hd', gitsigns.diffthis)

        map('n', '<leader>hD', function()
          gitsigns.diffthis('~')
        end)

        map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
        map('n', '<leader>hq', gitsigns.setqflist)

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        map('n', '<leader>tw', gitsigns.toggle_word_diff)

        -- Text object
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end
    },
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { '<F6>', function() require("ui_modes"):outline_toggle() end, silent = true } },
    opts = {}
  },
}

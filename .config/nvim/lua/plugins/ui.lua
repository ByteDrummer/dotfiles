return {
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
    end
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "▏" }
    }
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { '<F1>',      function() require("ui_modes"):tree_toggle() end, silent = true },
      { '<leader>r', ':NvimTreeRefresh<CR>',                           silent = true },
      { '<leader>n', ':NvimTreeFindFile<CR>',                          silent = true },
    },

    config = function()
      require 'nvim-tree'.setup {
        disable_netrw = true,
        hijack_netrw  = true,
        diagnostics   = {
          enable = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          }
        },
        git           = {
          ignore = false,
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
    end,

  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        highlight = {
          enable = true,
          disable = {},
        },
        indent = {
          enable = false,
          disable = {},
        },
        ensure_installed = {
          'cpp',
          'javascript',
          'html',
          'python',
          'bash',
          'java',
          'json',
          'vim'
        },

      })
    end
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
      signs = {
        add          = { text = '▎' },
        change       = { text = '▎' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then return ']h' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[h', function()
          if vim.wo.diff then return '[h' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line { full = true } end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    },
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { '<F6>', function() require("ui_modes"):outline_toggle() end, silent = true } },
    opts = {}
  },
}

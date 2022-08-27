" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

" plugins ------------------------------------
Plug 'windwp/nvim-autopairs' " auto bracket matching
Plug 'navarasu/onedark.nvim' " colorscheme
Plug 'lukas-reineke/indent-blankline.nvim' " vertical indentation lines
Plug 'karb94/neoscroll.nvim' " smooth scrolling
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " for syntax highlighting
Plug 'nvim-lualine/lualine.nvim' " custom statusline
Plug 'romgrk/barbar.nvim' " custom tabline
Plug 'kyazdani42/nvim-web-devicons' " icon glyphs
Plug 'kyazdani42/nvim-tree.lua' " file tree
Plug 'lewis6991/gitsigns.nvim' " diff symbols
Plug 'nvim-lua/plenary.nvim' " gitsigns dependancy
Plug 'akinsho/toggleterm.nvim' " terminal
Plug 'mfussenegger/nvim-dap' " debugger
Plug 'rcarriga/nvim-dap-ui' "UI for debugger
Plug 'scrooloose/nerdcommenter' " quickly comment blocks of code
Plug 'tpope/vim-surround' " quickly surround selection with brackets
Plug 'unblevable/quick-scope' " show unique word characters in a line
Plug 'simrat39/symbols-outline.nvim' " code outline

" LSP plgins ------------------------------------
Plug 'onsails/lspkind.nvim' " kind symbols
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim' " auto install packages
Plug 'jose-elias-alvarez/null-ls.nvim' " integrate formatters and linters
" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
" Quickstart boilerplate
Plug 'VonHeikemen/lsp-zero.nvim'

call plug#end()

" oneline setups ------------------------------------
lua require('nvim-autopairs').setup()
lua require('neoscroll').setup()

" LSP settings ------------------------------------
lua << EOF
local lsp = require('lsp-zero')
local lspkind = require('lspkind')

lsp.set_preferences({
  suggest_lsp_servers = true,
  setup_servers_on_start = true,
  set_lsp_keymaps = true,
  configure_diagnostics = true,
  cmp_capabilities = true,
  manage_nvim_cmp = true,
  call_servers = 'local',
  sign_icons = {
    error = '',
    warn = '',
    hint = '',
    info = ''
  }
})

lsp.nvim_workspace()

lsp.setup_nvim_cmp {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        return vim_item
      end
    })
  }
}

lsp.setup()

require'mason-tool-installer'.setup {
  ensure_installed = {'pyright', 'autopep8'}
}

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.autopep8
    }
})
EOF

nnoremap <leader>f :LspZeroFormat<CR>

" indent-blankline setting ------------------------------------
lua << EOF
require("indent_blankline").setup {
  char = "▏"
}
EOF

" gitsigns settings ------------------------------------
lua << EOF
require('gitsigns').setup({
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '▎', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '▎', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']h', "&diff ? ']h' : '<cmd>Gitsigns next_hunk<CR>'", {expr=true})
    map('n', '[h', "&diff ? '[h' : '<cmd>Gitsigns prev_hunk<CR>'", {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})
EOF

" toggleterm settings ------------------------------------
lua << EOF
term_open = false

require("toggleterm").setup{
  shade_terminals = false,
  open_mapping = [[<c-\>]],
  on_close = function()
    term_open = false
  end,
  on_open = function()
    term_open = true
  end
}

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

term_toggle = function()
  if debug_open then
    debug_mode_close()
  end
  vim.cmd('ToggleTerm')
end
EOF

map <silent> <C-\> :lua term_toggle()<CR>

" nvim-tree settings ------------------------------------
lua << EOF
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  git = {
    ignore = false,
  },
  view = {
    width = 34,
  },
  renderer = {
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

tree_toggle = function()
  if debug_open then
    debug_mode_close()
  end
  vim.cmd("NvimTreeToggle")
  if require'nvim-tree.view'.is_visible() then
    require'bufferline.state'.set_offset(35, '')
  else
    require'bufferline.state'.set_offset(0)
  end
end
EOF

nmap <silent> <F1> :lua tree_toggle()<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" treesitter settings ------------------------------------
set foldexpr=nvim_treesitter#foldexpr()

lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    'javascript',
    'html',
    'python',
    'bash',
    'java',
    'json'
  },
}
EOF

" barbar settings ------------------------------------
let bufferline = get(g:, 'bufferline', {})
let bufferline.tabpages = v:false
let bufferline.icon_close_tab_modified = ''
nnoremap <silent>    <A-,> :BufferPrevious<CR>
nnoremap <silent>    <A-.> :BufferNext<CR>
nnoremap <silent>    <A-<> :BufferMovePrevious<CR>
nnoremap <silent>    <A->> :BufferMoveNext<CR>
nnoremap <silent>    <A-c> :BufferClose<CR>
nnoremap <silent>    <A-p> :BufferPick<CR>
let bufferline.exclude_ft = ['dap-repl', 'qf']
let bufferline.exclude_name = ['python']

" DAP settings ------------------------------------
autocmd ColorScheme *
      \ highlight DapBreakpoint ctermfg=198 gui=bold guifg=#e06c75|
      \ highlight DapStopped ctermfg=198 guifg=#98c379

lua << EOF
local dap = require('dap')

require("dapui").setup{
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
}

promptArgs = function()
  out = {}
  str = vim.fn.input('Provide args: ');
  str:gsub("%S+", function(c) table.insert(out,c) end)
  return out
end;
 
dap.adapters.python = {
  type = 'executable';
  command = '/usr/bin/python';
  args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
  {
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";
    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end;
    args = promptArgs;
    console = "integratedTerminal";
  },
}

vim.fn.sign_define('DapBreakpoint', {text='', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='DapStopped', linehl='', numhl=''})

debug_open = false
debug_mode_toggle = function()
  pcall(vim.cmd, 'SymbolsOutlineClose')
  vim.cmd('NvimTreeClose')

  if term_open then
    vim.cmd('ToggleTerm')
  end

  require'dapui'.toggle{ reset = true }
  debug_open = not debug_open

  if debug_open then
    require'bufferline.state'.set_offset(41, '')
  else
    require'bufferline.state'.set_offset(0)
  end
end

debug_mode_close = function()
  require'dapui'.close()
  debug_open = false
  require'bufferline.state'.set_offset(0)
end
EOF

nnoremap <silent> <F3> :lua debug_mode_toggle()<CR>
nnoremap <silent> <leader>c :lua require'dap'.continue()<CR>
nnoremap <silent> <leader>s :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>si :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>so :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>
nnoremap <silent> <leader>t :lua require'dap'.terminate()<CR>

" symbols-outline settings ------------------------------------
lua << EOF
require("symbols-outline").setup()

outline_toggle = function()
  if debug_open then
    debug_mode_close()
  end
  vim.cmd('SymbolsOutline')
end
EOF

nnoremap <F5> :lua outline_toggle()<CR>

" lualine settings ------------------------------------
lua << EOF
require'lualine'.setup {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    always_divide_middle = true,
    globalstatus=true
  },
  sections = {
    lualine_a = {
      { 'mode', separator ={ right = '', left = ''}, right_padding = 2 },
    },
    lualine_b = {'branch', "diff",
      {
        'diagnostics',
        sections = {'error', 'warn', 'info', 'hint'},
        symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}
      }
    },
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {
      { 'location', separator = { right = '',  left = ''}, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
EOF

" Vim settings ------------------------------------
syntax enable " Enables syntax highlighing
set nowrap " disable line wrapping since it interferes with colorcolumn
set hidden " Required to keep multiple buffers open
set encoding=utf-8 " The encoding displayed
set fileencoding=utf-8 " The encoding written to file
set pumheight=10 " Make completion menu smaller
set cmdheight=2 " More space for displaying messages
set iskeyword+=- " treat dash separated words as a word text object"
set mouse=a " Enable your mouse
set splitbelow " Horizontal splits will automatically be below
set splitright " Vertical splits will automatically be to the right
set tabstop=2 " Insert 2 spaces for a tab
set shiftwidth=2 " Change the number of space characters inserted for indentation
set smarttab " Makes tabbing smarter will realize you have 2 vs 4
set expandtab " Converts tabs to spaces
set smartindent " Makes indenting smart
set autoindent " Good auto indent
set number " Line numbers
set cursorline " Enable highlighting of the current line
set noshowmode " We don't need to see things like -- INSERT -- anymore
set updatetime=300 " Faster UI responsiveness with certain plugins
set clipboard=unnamedplus " Copy paste between vim and everything else
set colorcolumn=81 " Column indicating max text width
set relativenumber " Line numbers counted relative to cursor
set signcolumn=yes " Always show the signcolumn
set ignorecase " case insensitive search
set smartcase " case sensitive search if capital letter is used
set foldmethod=expr " folding by expression defined using treesitter
set foldlevel=99 " have all folds open when opening a file
autocmd FileType * set formatoptions-=cro " Stop newline continution of comments
colorscheme onedark

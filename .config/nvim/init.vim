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
Plug 'mfussenegger/nvim-dap' " debugger
Plug 'rcarriga/nvim-dap-ui' "UI for debugger
Plug 'scrooloose/nerdcommenter' " quickly comment blocks of code
Plug 'tpope/vim-surround' " quickly surround selection with brackets
Plug 'unblevable/quick-scope' " show unique word characters in a line
Plug 'simrat39/symbols-outline.nvim' " code outline

" LSP plgins ------------------------------------
" LSP Support
Plug 'neovim/nvim-lspconfig'                          
Plug 'williamboman/mason.nvim', {'do': ':MasonUpdate'}
Plug 'williamboman/mason-lspconfig.nvim'              
" Autocompletion
Plug 'hrsh7th/nvim-cmp'    
Plug 'hrsh7th/cmp-path' " cmp source for filesystem paths
Plug 'hrsh7th/cmp-nvim-lsp' " cmp source for LSP servers
Plug 'hrsh7th/cmp-buffer' " cmp source for buffer words
Plug 'L3MON4D3/LuaSnip' " cmp source for snippet engine
Plug 'saadparwaiz1/cmp_luasnip' " allow custom snippets for LuaSnip
Plug 'rafamadriz/friendly-snippets' " custom snippets collection
Plug 'onsails/lspkind.nvim' " kind symbols
" Extras
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim' " auto install packages
Plug 'jose-elias-alvarez/null-ls.nvim' " integrate formatters and linters
" Boiler plate
Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v2.x'}

call plug#end()

" oneline setups ------------------------------------
lua require('nvim-autopairs').setup()
lua require('neoscroll').setup()

" LSP settings ------------------------------------
lua << EOF
local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})

  vim.keymap.set({'n', 'x'}, '<F3>', function()
    vim.lsp.buf.format({async = false, timeout_ms = 10000})
  end)
end)

lsp.set_sign_icons({
  error = '',
  warn = '',
  hint = '',
  info = ''
})

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip').filetype_extend("javascript", { "javascriptreact" })

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
  mapping = {
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  },
  formatting = {
    fields = {'abbr', 'kind', 'menu'},
    format = require('lspkind').cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
    })
  }
})

require'mason-tool-installer'.setup {
  ensure_installed = {
    'pyright', 'autopep8',
    'typescript-language-server',
    'bash-language-server', 'beautysh', 'shellcheck'
  }
}

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.beautysh,
        require("null-ls").builtins.formatting.autopep8
    }
})
EOF

" onedark settings ------------------------------------
lua << EOF
require('onedark').setup {
  highlights = {
    VertSplit = {fg = "#282C34"}
  }
}
EOF

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
    map('n', ']h', function()
      if vim.wo.diff then return ']h' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[h', function()
      if vim.wo.diff then return '[h' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

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
    require'bufferline.api'.set_offset(34, '')
  else
    require'bufferline.api'.set_offset(0)
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
    'json',
    'vim'
  },
}
EOF

" barbar settings ------------------------------------
lua << EOF
vim.g.barbar_auto_setup = false -- disable auto-setup

require("barbar").setup({
  exclude_ft = {'dap-repl', 'qf'},
  exclude_name = {'python'},
  icons = {
    modified = {button = ''}
  }
})

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
map('n', '<A-p>', '<Cmd>BufferPick<CR>', opts)
EOF

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

  require'dapui'.toggle{ reset = true }
  debug_open = not debug_open

  if debug_open then
    require'bufferline.api'.set_offset(40, '')
  else
    require'bufferline.api'.set_offset(0)
  end
end

debug_mode_close = function()
  require'dapui'.close()
  debug_open = false
  require'bufferline.api'.set_offset(0)
end
EOF

nnoremap <silent> <F5> :lua debug_mode_toggle()<CR>
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

nnoremap <F6> :lua outline_toggle()<CR>

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

call plug#begin('~/.vim/plugged')

" plugins ------------------------------------
Plug 'windwp/nvim-autopairs' " auto bracket matching
Plug 'ful1e5/onedark.nvim' "colorscheme
Plug 'lukas-reineke/indent-blankline.nvim' " vertical indentation lines
Plug 'psliwka/vim-smoothie' " smooth scrolling
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim' " lua statusline
Plug 'romgrk/barbar.nvim' " lua tabline
Plug 'kyazdani42/nvim-web-devicons' " icon glyphs
Plug 'kyazdani42/nvim-tree.lua' " file tree
Plug 'nvim-lua/plenary.nvim' " gitsigns dependancy
Plug 'lewis6991/gitsigns.nvim' " diff symbols
Plug 'liuchengxu/vista.vim' " file outline for faster navigation
Plug 'akinsho/toggleterm.nvim' " terminal
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP
Plug 'mfussenegger/nvim-dap' "DAP
Plug 'rcarriga/nvim-dap-ui' "UI for DAP
Plug 'honza/vim-snippets' " code snippets
Plug 'scrooloose/nerdcommenter' " quickly comment blocks of code
Plug 'tpope/vim-surround' " quickly surround selection with brackets
Plug 'adelarsq/vim-matchit' " extension of % matching, helpful for html tags
Plug 'unblevable/quick-scope' " show unique word characters in a line

call plug#end()

autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

lua << EOF
require('nvim-autopairs').setup{}
EOF

" indent-blankline setting
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
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 500,
  },
  view = {
    width = 34,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {}
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  },
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
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

autocmd ColorScheme * 
  \ highlight NvimTreeFolderIcon guifg=#61afef

nmap <silent> <F1> :lua tree_toggle()<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>


" treesitter settings ------------------------------------
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
    'java'
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
require("dapui").setup()

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
  vim.cmd('Vista!')
  vim.cmd('NvimTreeClose')
  if term_open then
    vim.cmd('ToggleTerm')
  end
  require'dapui'.toggle()
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

" quick-scope settings ------------------------------------
let g:qs_buftype_blacklist = ['terminal', 'nofile']
autocmd ColorScheme *
      \ highlight QuickScopePrimary guifg=#c678dd gui=underline ctermfg=155 cterm=underline |
      \ highlight QuickScopeSecondary guifg=#56b6c2 gui=underline ctermfg=81 cterm=underline

" vista.vim settings ------------------------------------
lua << EOF
vista_toggle = function()
  if debug_open then
    debug_mode_close()
  end
  vim.cmd('Vista!!')
end
EOF

nnoremap <silent> <F2> :lua vista_toggle()<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'
let g:vista#renderer#enable_icon = 1
let g:vista_sidebar_width = 34

" onedark settings ------------------------------------
let g:onedark_sidebars = ['coc-explorer', 'vista', 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_watches']
let g:onedark_dark_float = 0

" lualine settings ------------------------------------
lua << EOF
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {'NvimTree', 'vista'},
    always_divide_middle = true,
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
    lualine_c = {'filename', 'g:coc_status'},
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

" coc settings ------------------------------------
" Resolve workspace folder for coc-pyright
autocmd FileType python let b:coc_root_patterns = ['.git', '.env', '.venv']

" List of extensions to install
let g:coc_global_extensions = ['coc-snippets', 'coc-marketplace', 'coc-tsserver', 'coc-eslint', 'coc-sql', 'coc-html', 'coc-json', 'coc-java', 'coc-clangd', 'coc-pyright', 'coc-sh']

" use tab to trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" format file
map <leader>f :call CocAction('format') <CR>

augroup mygroup
  autocmd!
  "" Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  "" Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" remap keys for applying codeAction on the current cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" remap keys for applying codeAction to the current line
nmap <leader>al  <Plug>(coc-codeaction-line)
" remap keys for applying codeAction to the current selection
xmap <leader>as  <Plug>(coc-codeaction-selected)
nmap <leader>as  <Plug>(coc-codeaction-selected)
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ab  <Plug>(coc-codeaction)

" apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>Cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" remap <C-f> and <C-b> to scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Vim settings ------------------------------------
syntax enable " Enables syntax highlighing
set hidden " Required to keep multiple buffers open multiple buffers
set encoding=utf-8 " The encoding displayed
set pumheight=10 " Makes popup menu smaller
set fileencoding=utf-8 " The encoding written to file
set ruler " Show the cursor position all the time
set cmdheight=2 " More space for displaying messages
set iskeyword+=- " treat dash separated words as a word text object"
set mouse=a " Enable your mouse
set splitbelow " Horizontal splits will automatically be below
set splitright " Vertical splits will automatically be to the right
set t_Co=256 " Support 256 colors
set conceallevel=0 " So that I can see `` in markdown files
set tabstop=2 " Insert 2 spaces for a tab
set shiftwidth=2 " Change the number of space characters inserted for indentation
set smarttab " Makes tabbing smarter will realize you have 2 vs 4
set expandtab " Converts tabs to spaces
set smartindent " Makes indenting smart
set autoindent " Good auto indent
set number " Line numbers
set cursorline " Enable highlighting of the current line
set background=dark " tell vim what the background color looks like
set showtabline=2 " Always show tabs
set noshowmode " We don't need to see things like -- INSERT -- anymore
set nobackup " This is recommended by coc
set nowritebackup " This is recommended by coc
set updatetime=300 " Faster completion
set timeoutlen=500 " By default timeoutlen is 1000 ms
set shortmess+=c " Don't pass messages to |ins-completion-menu|
set clipboard=unnamedplus " Copy paste between vim and everything else
set colorcolumn=81 " Column indicating max text width
set relativenumber " Line numbers counted relative to cursor
set signcolumn=yes " Always show the signcolumn
set ignorecase " case insensitive search
set smartcase " case sensitive search if capital letter is used
autocmd FileType * set formatoptions-=cro " Stop newline continution of comments
colorscheme onedark
" Darken split separator and statusline placeholder
hi VertSplit guibg=#21252b guifg=#21252b
hi StatusLineNC gui=bold guibg=#21252b guifg=#21252b
hi StatusLine gui=bold guibg=#21252b guifg=#21252b

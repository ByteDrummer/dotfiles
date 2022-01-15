call plug#begin('~/.vim/plugged')

" theme plugins ------------------------------------
Plug 'ful1e5/onedark.nvim' "colorscheme
Plug 'Yggdroot/indentLine' " vertical indentation lines
Plug 'psliwka/vim-smoothie' " smooth scrolling
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim' " lua statusline
Plug 'romgrk/barbar.nvim' " lua tabline
Plug 'kyazdani42/nvim-web-devicons' " icon glyphs
Plug 'kyazdani42/nvim-tree.lua' " file tree

" workflow plugins ------------------------------------
Plug 'airblade/vim-gitgutter' " git diff in gutter
Plug 'tpope/vim-fugitive' " git integration
Plug 'liuchengxu/vista.vim' " file outline for faster navigation
Plug 'voldikss/vim-floaterm' " floating terminal window
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP
Plug 'mfussenegger/nvim-dap' "DAP
Plug 'Pocco81/DAPInstall.nvim' "Manager for DAP adapters
Plug 'rcarriga/nvim-dap-ui' "UI for DAP
Plug 'honza/vim-snippets' " code snippets
Plug 'scrooloose/nerdcommenter' " quickly comment blocks of code
Plug 'tpope/vim-surround' " quickly surround selection with brackets
Plug 'adelarsq/vim-matchit' " extension of % matching, helpful for html tags
Plug 'unblevable/quick-scope' " show unique word characters in a line
Plug 'lervag/vimtex' " extra features for LaTeX

Plug 'instant-markdown/vim-instant-markdown', {'rtp': 'after'} " Markdown viewer

call plug#end()

" nvim-tree settings ------------------------------------
autocmd ColorScheme * 
  \ highlight NvimTreeFolderIcon guifg=#61afef

let g:nvim_tree_indent_markers = 1

let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 0,
    \ }

lua << EOF
require'nvim-tree'.setup {
  disable_netrw       = true,
  hijack_netrw        = true,
  open_on_setup       = false,
  ignore_ft_on_setup  = {},
  auto_close          = false,
  open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  update_to_buf_dir   = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
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
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 35,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    auto_resize = false,
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
  }
}

tree = {}
tree.toggle = function()
  require'nvim-tree'.toggle()
  if require'nvim-tree.view'.win_open() then
    require'bufferline.state'.set_offset(35, '')
  else
    require'bufferline.state'.set_offset(0)
  end
end

return tree
EOF

nmap <silent> <F1> :lua tree.toggle()<CR>
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
    'bash'
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
nnoremap <silent> <C-s>    :BufferPick<CR>
let bufferline.exclude_ft = ['dap-repl', 'qf']

" DAP settings ------------------------------------
autocmd ColorScheme *
      \ highlight DapBreakpoint ctermfg=198 gui=bold guifg=#e06c75|
      \ highlight DapStopped ctermfg=198 guifg=#98c379

lua << EOF
local dap = require('dap')
local dap_install = require("dap-install")
require("dapui").setup()

dap_install.setup({
      installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
})

dap_install.config("python", {})

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
  },
}

vim.fn.sign_define('DapBreakpoint', {text='', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='DapStopped', linehl='', numhl=''})
EOF

nnoremap <silent> <F3> :lua require'dapui'.toggle()<CR>
nnoremap <silent> <leader>c :lua require'dap'.continue()<CR>
nnoremap <silent> <leader>s :lua require'dap'.step_over()<CR>
nnoremap <silent> <leader>si :lua require'dap'.step_into()<CR>
nnoremap <silent> <leader>so :lua require'dap'.step_out()<CR>
nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
nnoremap <silent> <leader>dl :lua require'dap'.run_last()<CR>

" floaterm settings ------------------------------------
let g:floaterm_keymap_toggle = '<Leader>t'
let g:floaterm_width=0.6
let g:floaterm_height=0.6
let g:floaterm_title= ''
autocmd ColorScheme *
      \ hi Floaterm guibg=#282c34 |
      \ hi FloatermBorder guibg=#282c34 guifg=#646e82

" Markdown viewer settings ------------------------------------
let g:instant_markdown_autostart = 0

" quick-scope settings ------------------------------------
let g:qs_buftype_blacklist = ['terminal', 'nofile']
autocmd ColorScheme *
      \ highlight QuickScopePrimary guifg=#c678dd gui=underline ctermfg=155 cterm=underline |
      \ highlight QuickScopeSecondary guifg=#56b6c2 gui=underline ctermfg=81 cterm=underline

" vista.vim settings ------------------------------------
nmap <silent> <F2> :Vista!!<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'
let g:vista#renderer#enable_icon = 1
let g:vista_sidebar_width = 35

" indentLine setting ------------------------------------s
let g:indentLine_char = '▏'
let g:indentLine_fileTypeExclude = ['NvimTree', 'vista']
let g:indentLine_concealcursor = "" " change concealcursor overwrite

" onedark settings ------------------------------------
let g:onedark_sidebars = ['coc-explorer']
let g:onedark_dark_float = 0

" disable concealing for Markdown
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" gitgutter settings ------------------------------------
nmap <silent> ]h <Plug>(GitGutterNextHunk)
nmap <silent> [h <Plug>(GitGutterPrevHunk)

" lualine settings ------------------------------------
lua << EOF
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch',
      {
        "diff",
        diff_color = {
            added = { fg = "#98c379" },
            modified = { fg = "#e5c07b" },
            removed = { fg = "#e06c75" },
        }
      },

      {
        'diagnostics',
        sections = {'error', 'warn', 'info', 'hint'},
        symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}
      }
    },
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
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
" highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

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

" use `[d` and `]d` to navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" format file
map <leader>f :call CocAction('format') <CR>

augroup mygroup
  autocmd!
  "" Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  "" Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" remap <C-f> and <C-b> to scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Vim settings ------------------------------------
syntax on " enable syntax highlighting
filetype plugin on " enable filetype plugins
set hidden " required to keep multiple buffers open multiple buffers
set encoding=utf-8 " set utf-8 as the encoding
set fileencoding=utf-8 " the encoding written to file
set pumheight=10 " makes popup menu smaller
set cmdheight=2  " more space for displaying messages
set iskeyword+=- " treat dash separated words as a word text object"
set termguicolors " enable true colors
set splitbelow " horizontal splits will automatically be below
set splitright " vertical splits will automatically be to the right
set foldmethod=indent " enable folding based on indentation
set foldlevelstart=99 " start unfolded
set ignorecase " case insensitive search
set smartcase " case sensetive search when there are uppercase characters
set showbreak=↳ " linewarp marker symbol
set hlsearch " highlight search matches
set tabstop=2 " show existing tab with 2 spaces width
set shiftwidth=2 " when indenting with >, <, and = use 2 spaces width
set softtabstop=2 " when indenting with tab and backspace use 2 spaces width
set expandtab " use softtabstop number of spaces when indenting
set smarttab " makes tabbing smarter will realize you have 2 vs 4
set autoindent " apply indentation of current line to next line
set smartindent " apply indentation after { symbols
set ruler " show line and character poistion
set undolevels=1000	" number of undo levels
set backspace=indent,eol,start " no limit to backspace
set cursorline " highlight the line the cursor is on
set number  " show line numbers
set relativenumber  "show number away from current line relatively
set showtabline=2 " always show tabs
set mouse=a " enable mouse mode
set incsearch " show highling while searching
set background=dark  " set the scheme to have dark background
set colorcolumn=81 " indicator of the textwidth
set nobackup " this is recommended by coc
set nowritebackup " this is recommended by coc
set updatetime=300 " faster completion
set shortmess+=c " Don't pass messages to ins-completion-menu.
set timeoutlen=500 " by default timeoutlen is 1000 ms
set clipboard=unnamedplus " copy paste between vim and everything else
set signcolumn=yes " always show gutter/signcolumn
set noshowmode " disable -- INSERT -- messages
set fillchars+=vert:\▏
colorscheme onedark

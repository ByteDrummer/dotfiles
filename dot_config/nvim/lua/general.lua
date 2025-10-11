-- disable line wrapping since it interferes with colorcolumn
vim.opt.wrap = false
-- The encoding written to file
vim.opt.fileencoding = "utf-8"
-- Make completion menu smaller
vim.opt.pumheight = 10
-- More space for displaying messages
vim.opt.cmdheight = 2
-- treat dash separated words as a word text object"
vim.opt.iskeyword:append("-")
-- Horizontal splits will automatically be below
vim.opt.splitbelow = true
-- Vertical splits will automatically be to the right
vim.opt.splitright = true
-- Insert 2 spaces for a tab
vim.opt.tabstop = 2
-- Change the number of space characters inserted for indentation
vim.opt.shiftwidth = 2
-- Converts tabs to spaces
vim.opt.expandtab = true
-- Makes indenting smart
vim.opt.smartindent = true
-- Line numbers
vim.opt.number = true
-- Enable highlighting of the current line
vim.opt.cursorline = true
-- We don't need to see things like -- INSERT -- anymore
vim.opt.showmode = false
-- Faster UI responsiveness with certain plugins
vim.opt.updatetime = 300
-- Copy paste between vim and everything else
vim.opt.clipboard = "unnamedplus"
-- Enable yanking to system clipboard over ssh
--vim.g.clipboard = "osc52"
-- Column indicating max text width
vim.opt.colorcolumn = "81"
-- Line numbers counted relative to cursor
vim.opt.relativenumber = true
-- Always show the signcolumn
vim.opt.signcolumn = "yes"
-- case insensitive search
vim.opt.ignorecase = true
-- case sensitive search if capital letter is used
vim.opt.smartcase = true
-- folding by expression defined using treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- Disable folding at startup.
vim.opt.foldlevel = 99
-- Stop newline continution of comments
vim.api.nvim_create_autocmd("BufEnter", { callback = function() vim.opt.formatoptions:remove { "c", "r", "o" } end })

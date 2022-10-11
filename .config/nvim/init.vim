
call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'morhetz/gruvbox'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'airblade/vim-rooter'
Plug 'neovim/nvim-lspconfig'
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

call plug#end()

set background=dark
set clipboard+=unnamedplus
set number
set cursorline
set mouse=a
set splitbelow splitright
set wildmenu
set title
set shiftwidth=4
set tabstop=4

" Italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

colorscheme gruvbox

highlight Comment cterm=italic gui=italic

let mapleader = ","

" Find files using Telescope command-line sugar.
nnoremap <leader>r <cmd>Telescope oldfiles<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>p <cmd>Telescope find_files<cr>

" Convenience mappings
nnoremap <space> <cmd>Telescope commands<cr>

" Copy/paste
vnoremap <D-c> "+y
nnoremap <D-v> "+p
inoremap <D-v> <esc>"+pi
cnoremap <D-v> <c-r>+

" Save
nnoremap z :w<enter>

lua require('config')

